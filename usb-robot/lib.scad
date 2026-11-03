// ============================================================
//  USB Switcher Robot: shared geometry helpers
// ============================================================
include <common.scad>

// ---------- dovetails (profile in YZ, extruded along +X) ----------
function dt_profile(c = 0, below = 0) = [
    [-dt_neck / 2 - c, -below], [dt_neck / 2 + c, -below],
    [dt_neck / 2 + c, 0], [dt_w / 2 + c, dt_h + c],
    [-dt_w / 2 - c, dt_h + c], [-dt_neck / 2 - c, 0]];

// Male rail, base on z=0, centred on y=0, running x = 0..len.
module dovetail_rail(len) {
    rotate([90, 0, 90]) linear_extrude(len)
        polygon(dt_profile(0, 0.01));
}

// Matching slot (rail + clr), cut 1 mm below z=0 so it opens cleanly,
// with a 45 deg chamfer at the mouth so a squashed first layer can't pinch it.
module dovetail_slot(len) {
    rotate([90, 0, 90]) linear_extrude(len) {
        polygon(dt_profile(clr, 1));
        chamfer_mouth(dt_neck + 2 * clr);
    }
}
// 2D wedge widening a slot mouth of width w at y=0 by dt_chamfer per side.
module chamfer_mouth(w) {
    polygon([[-w / 2 - dt_chamfer, -1], [w / 2 + dt_chamfer, -1], [w / 2 + dt_chamfer, 0],
              [w / 2, dt_chamfer], [-w / 2, dt_chamfer], [-w / 2 - dt_chamfer, 0]]);
}
echo("CHECK", "dt_chamfer", dt_chamfer);

// ---------- fasteners ----------
module m3_nut_trap(depth) {
    cylinder(d = (m3_nut_af + clr) / cos(30), h = depth, $fn = 6);
}
module m4_nut_trap(depth) {
    cylinder(d = (m4_nut_af + clr) / cos(30), h = depth, $fn = 6);
}
module screw_hole(d, len) {
    translate([0, 0, -0.01]) cylinder(d = d, h = len + 0.02, $fn = 32);
}
// Through holes for wood screws / M4 into the plywood, with head counterbore.
module wood_screw_holes(pts, t, cbore = 0) {
    for (p = pts) translate([p[0], p[1], 0]) {
        translate([0, 0, -1]) cylinder(d = m4_d, h = t + 2, $fn = 32);
        if (cbore > 0)
            translate([0, 0, t - cbore]) cylinder(d = m4_head_d + 1, h = cbore + 1, $fn = 32);
    }
}

// ---------- bulkhead D-hole (axis Z, flat toward +Y) ----------
module d_hole(d = bh_hole_d, flat = bh_flat + bh_flat_clr, t = plate_t) {
    translate([0, 0, -0.01]) intersection() {
        cylinder(d = d, h = t + 0.02, $fn = 96);
        translate([-d / 2, -d / 2, 0]) cube([d, d / 2 + flat, t + 0.02]);
    }
}

// ---------- involute pinion + straight rack ----------
function _inv(a_rad) = tan(a_rad * 180 / PI) - a_rad;

// One tooth outline centred on +X (radians internally).
function _tooth(z, m, pa) = let(
    rp = m * z / 2, rb = rp * cos(pa), ro = rp + m, rr = rp - 1.25 * m,
    half = PI / (2 * z) + _inv(pa * PI / 180),
    tmax = sqrt(pow(ro / rb, 2) - 1),
    n = 10,
    flank = [for (k = [0:n]) let(t = tmax * k / n,
                 r = rb * sqrt(1 + t * t),
                 ang = half - (t - atan(t) * PI / 180))
             [r, ang]],
    rstart = min(rr, rb)
) concat(
    [[rstart * cos(-half * 180 / PI), rstart * sin(-half * 180 / PI)]],
    [for (p = flank) [p[0] * cos(-p[1] * 180 / PI), p[0] * sin(-p[1] * 180 / PI)]],
    [for (k = [n:-1:0]) let(p = flank[k]) [p[0] * cos(p[1] * 180 / PI), p[0] * sin(p[1] * 180 / PI)]],
    [[rstart * cos(half * 180 / PI), rstart * sin(half * 180 / PI)]]);

// Pinion that screws onto a stock MG995 round horn (horn sits in the
// recess underneath; screws go down through the pinion into the horn).
module pinion(teeth = pinion_teeth, mod = gear_mod, thick = gear_thick) {
    rr = mod * teeth / 2 - 1.25 * mod;
    difference() {
        linear_extrude(thick) union() {
            circle(r = rr + 0.01, $fn = teeth * 4);
            for (i = [0:teeth - 1]) rotate(i * 360 / teeth) polygon(_tooth(teeth, mod, gear_pa));
        }
        translate([0, 0, -0.01]) cylinder(d = horn_d + 0.4, h = horn_t + 0.2);
        screw_hole(3.5, thick);                                     // horn centre screw
        translate([0, 0, horn_t + 2]) cylinder(d = 7, h = thick);   // its head + driver
        for (i = [0:horn_hole_n - 1]) rotate(i * 360 / horn_hole_n)
            translate([horn_hole_r, 0, 0]) {
                screw_hole(horn_hole_d + 0.4, thick);
                translate([0, 0, horn_t + 0.2 + horn_screw_land]) cylinder(d = 4.5, h = thick);
            }
    }
}

horn_screw_land = 2.5;   // pinion material each horn screw passes (counterbored above)
echo("CHECK", "horn_screw_land", horn_screw_land);

function rack_pitch_y(base_h = 4, mod = gear_mod) = base_h + 1.25 * mod;

// Rack: teeth along +X from x=0..len, tips toward +Y, z = 0..thick.
module rack(len, mod = gear_mod, thick = gear_thick, base_h = 4) {
    p = PI * mod;
    t = tan(gear_pa);
    y0 = base_h; y1 = base_h + 2.25 * mod; yp = rack_pitch_y(base_h, mod);
    hw_root = p / 4 + 1.25 * mod * t - gear_backlash;
    hw_tip  = p / 4 - mod * t - gear_backlash;
    linear_extrude(thick) intersection() {
        union() {
            square([len, base_h + 0.01]);
            for (i = [0:floor(len / p)]) translate([i * p + p / 2, 0])
                polygon([[-hw_root, y0], [hw_root, y0], [hw_tip, y1], [-hw_tip, y1]]);
        }
        square([len, y1 + 1]);
    }
}

// ---------- MG995 (upright frame: body bottom z=0, shaft at x=y=0,
//            body length along X with the shaft near the +X end) ----------
servo_body_cx = servo_shaft_off - servo_body[0] / 2;   // body centre X
servo_ear_top = servo_ear_z + servo_ear_t;             // shaft-side ear face
servo_pinion_up = servo_ear_top + servo_ear_to_pinion; // pinion horn face

module mg995_model() {
    color("#222") {
        translate([servo_shaft_off - servo_body[0], -servo_body[1] / 2, 0]) cube(servo_body);
        translate([servo_body_cx - servo_ear_len / 2, -servo_body[1] / 2, servo_ear_z])
            cube([servo_ear_len, servo_body[1], servo_ear_t]);
        cylinder(d = 12, h = servo_pinion_up);
    }
}

// Holder for an inverted servo (separate print, plate on the bed).
// Upright frame: ear plate on the shaft side of the ears, a solid block
// at the far end and one long side wall on -y (away from the rack),
// both standing down to the floor at upright height floor_up.
// Ears screw in with M3 self-tappers; the holder screws to the floor
// with 3x M3 self-tappers from underneath (holder_floor_pts).
holder_t  = 6;
holder_floor_up = servo_pinion_up + gear_thick + 1;   // pinion sits 1 mm above the floor
holder_hw = pinion_pd / 2 + gear_mod + 3.5;            // plate half width (y)
holder_px0 = servo_body_cx - servo_ear_len / 2 - 5;
holder_px1 = servo_body_cx + servo_ear_len / 2 + 5;
holder_wall_x1 = -pinion_pd / 2 - gear_mod - 2;        // far block ends before the pinion
holder_side_x1 = pinion_pd / 2 - gear_mod - 1;         // side wall ends before the rack tips
holder_side_t  = 3;
function holder_overhang(wall_end) = holder_px1 - wall_end;
holder_floor_pts = [[holder_px0 + 5, -8], [holder_px0 + 5, 8],
                    [0, -holder_hw + holder_side_t / 2]];

module mg995_holder(floor_up = holder_floor_up) {
    hw = servo_body[1] / 2 + 6;
    difference() {
        union() {
            translate([holder_px0, -holder_hw, servo_ear_top]) cube([holder_px1 - holder_px0, holder_hw + hw, holder_t]);
            translate([holder_px0, -hw, servo_ear_top]) cube([holder_wall_x1 - holder_px0, 2 * hw, floor_up - servo_ear_top]);
            translate([holder_px0, -holder_hw, servo_ear_top])
                cube([holder_side_x1 - holder_px0, holder_side_t, floor_up - servo_ear_top]);
        }
        translate([servo_shaft_off - servo_body[0] - clr - 0.2, -servo_body[1] / 2 - clr, -1])
            cube([servo_body[0] + 2 * clr + 0.2, servo_body[1] + 2 * clr, servo_body[2] + 1 + clr]);
        cylinder(d = 14, h = floor_up + 1);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([servo_body_cx + sx * servo_hole_spacing / 2, sy * servo_hole_gap / 2, servo_ear_top - 0.01])
                cylinder(d = m3_tap, h = 14, $fn = 24);
        for (p = holder_floor_pts) translate([p[0], p[1], floor_up - 12]) cylinder(d = m3_tap, h = 12.1, $fn = 24);
    }
}

// Matching floor holes (counterbored from below) under a holder.
module holder_floor_holes(t) {
    for (p = holder_floor_pts) translate([p[0], p[1], 0]) {
        translate([0, 0, -1]) cylinder(d = m3_d, h = t + 2, $fn = 24);
        translate([0, 0, -1]) cylinder(d = m3_head_d + 0.6, h = 1 + 3, $fn = 24);
    }
}

echo("CHECK", "holder_overhang", holder_overhang(holder_side_x1));

module at_inverted_servo(x, y, pinion_z0, a) {
    translate([x, y, pinion_z0 + gear_thick + servo_pinion_up]) rotate([0, 0, a]) rotate([180, 0, 0])
        children();
}
