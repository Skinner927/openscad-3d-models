// ============================================================
//  Plug carriage: X base (fixed, X servo) -> X carriage (rack on
//  its -Y face, Y servo) -> Y carriage (rack on its -X face, male
//  stage pad, cable pillar).
//  World coords; carriage modules take x_pos (plug X) / y_pos.
// ============================================================
include <stage.scad>

runner_w = 10;     // plain (non-dovetail) rear X runner
runner_h = dt_h;

// ---------------- X base ----------------
xb_x0 = x_rail_x0 - 6;
xb_x1 = x_rail_x0 + x_rail_len + 6;
xb_y0 = x_shaft_y - servo_body[0] + servo_shaft_off - 12;
xb_y1 = xc_y1;
xb_screws = [[xb_x0 + 7, xb_y0 + 7], [xb_x1 - 7, xb_y0 + 7],
             [xb_x0 + 7, xb_y1 - 7], [xb_x1 - 7, xb_y1 - 7],
             [(xb_x0 + xb_x1) / 2, xb_y1 - 7]];

module x_servo_holder_world() {
    at_inverted_servo(x_shaft_x, x_shaft_y, x_pinion_z0, 90) mg995_holder();
}
// Holder floor-screw holes, mapped from the holder frame to the floor.
module x_holder_floor_holes() {
    at_inverted_servo(x_shaft_x, x_shaft_y, x_pinion_z0, 90) translate([0, 0, holder_floor_up])
        mirror([0, 0, 1]) translate([0, 0, -xb_t]) holder_floor_holes(xb_t);
}
module x_servo_world() {
    at_inverted_servo(x_shaft_x, x_shaft_y, x_pinion_z0, 90) mg995_model();
    x_servo_holder_world();
}
module x_pinion_world() {
    translate([x_shaft_x, x_shaft_y, x_pinion_z0]) color("Gold") pinion();
}

module x_base() {
    difference() {
        union() {
            translate([xb_x0, xb_y0, 0]) cube([xb_x1 - xb_x0, xb_y1 - xb_y0, xb_t]);
            translate([x_rail_x0, x_rail_y[1], xb_t]) dovetail_rail(x_rail_len);
            translate([x_rail_x0, x_rail_y[0] - runner_w / 2, xb_t - 0.01])
                cube([x_rail_len, runner_w, runner_h + 0.01]);
        }
        wood_screw_holes(xb_screws, xb_t, cbore = 2);
        x_holder_floor_holes();
        // pinion clearance pocket (keeps the plate clear of the gear)
        translate([x_shaft_x, x_shaft_y, xb_t - 1]) cylinder(r = pinion_pd / 2 + gear_mod + 1, h = 2);
        // servo-lead exit notch at the rear edge, plus zip-tie slots
        translate([x_shaft_x - 6, xb_y0 - 1, -1]) cube([12, 8, xb_t + 2]);
        for (dx = [-10, 10]) translate([x_shaft_x + dx - 1.5, xb_y0 + 12, -1]) cube([3, 5, xb_t + 2]);
    }
}

// ---------------- X carriage (modelled at x_pos = 0) ----------------
module y_servo_holder_local() {
    at_inverted_servo(y_shaft_x_rel, y_shaft_y, y_pinion_z0, 90) mg995_holder();
}
module y_holder_floor_holes() {
    at_inverted_servo(y_shaft_x_rel, y_shaft_y, y_pinion_z0, 90) translate([0, 0, holder_floor_up])
        mirror([0, 0, 1]) translate([0, 0, -xc_h]) holder_floor_holes(xc_h);
}
module y_servo_local() {
    at_inverted_servo(y_shaft_x_rel, y_shaft_y, y_pinion_z0, 90) mg995_model();
}

module x_carriage() {
    difference() {
        union() {
            translate([xc_x0, xc_y0, xc_z0]) cube([xc_len, xc_y1 - xc_y0, xc_h]);
            // X rack on the -Y face, teeth toward -Y
            translate([xc_x0, xc_y0 + 0.01, x_rack_z0]) mirror([0, 1, 0]) rack(xc_len, base_h = rack_base);
            // Y rail on top, under the Y carriage
            translate([-xs_xc, xc_y0, xc_top]) rotate([0, 0, 90]) dovetail_rail(xc_y1 - xc_y0);
        }
        y_holder_floor_holes();
        translate([xc_x0 - 1, x_rail_y[1], xc_z0]) dovetail_slot(xc_len + 2);
        translate([xc_x0 - 1, x_rail_y[0] - runner_w / 2 - clr - 0.15, xc_z0 - 1])
            cube([xc_len + 2, runner_w + 2 * clr + 0.3, runner_h + clr + 1]);
        translate([xc_x0 - 1, x_rail_y[0], xc_z0]) rotate([90, 0, 90]) linear_extrude(xc_len + 2)
            chamfer_mouth(runner_w + 2 * clr + 0.3);
        // lightening / Y-servo lead pass-through + zip-tie slots
        translate([y_shaft_x_rel - 6, xc_y0 + 3, xc_top - 4]) cube([12, 6, 5]);
        for (dy = [12, 24]) translate([xc_x0 + 3, xc_y0 + dy, xc_z0 + runner_h + 2]) cube([5, 3, xc_h]);
    }
}
module x_carriage_world(x_pos) { translate([x_pos, 0, 0]) x_carriage(); }
module y_servo_world(x_pos) { translate([x_pos, 0, 0]) { y_servo_local(); y_servo_holder_local(); } }
module y_pinion_world(x_pos) {
    translate([x_pos + y_shaft_x_rel, y_shaft_y, y_pinion_z0]) color("Gold") pinion();
}

echo("CHECK", "x_rail_len", x_rail_len);
// X base front edge to the port towers' base front edge (Y)
echo("CHECK", "xbase_tower_gap", (tower_y - stage_D / 2) - xb_y1);
echo("CHECK", "x_mesh_gap", (x_pitch_y - x_shaft_y) - pinion_pd / 2);
echo("CHECK", "x_travel_needed", x_pos_max - x_pos_min);

// ---------------- Y carriage (coords relative to male stage origin
//                  in X/Y, world Z) ----------------
pillar_w   = 16;
// top of the flexure frame (mirrors plug_mount.scad) + 6 so the cable clears it
pillar_top = port_z + plug_drop - 1 + flex_isl_h + 6 + 5 + 6;

module y_carriage() {
    difference() {
        union() {
            translate([yc_x0, yc_y0, yc_z0]) cube([yc_x1 - yc_x0, yc_len, yc_h]);
            // Y rack on the -X face, teeth toward -X
            translate([yc_x0 + 0.01, yc_y0, y_rack_z0]) rotate([0, 0, 90]) rack(yc_len, base_h = rack_base);
            // cable strain-relief pillar at the rear, in line with the plug
            translate([xs_xc - pillar_w / 2, yc_y0, yc_z0]) cube([pillar_w, yc_pillar_d, pillar_top - yc_z0]);
        }
        translate([0, yc_y0 - 1, yc_z0]) rotate([0, 0, 90]) dovetail_slot(yc_len + 2);
        // M4 bolts up through captive nuts into the stage base
        for (p = stage_mount_pts) translate([p[0], p[1], yc_z0]) {
            screw_hole(m4_d, yc_h);
            translate([0, 0, -0.01]) m4_nut_trap(m4_nut_t + 0.5);
        }
        // two zip-tie slots through the pillar, near its front face
        for (dz = [6, 18]) translate([xs_xc - pillar_w / 2 - 1, yc_y0 + yc_pillar_d - 5.5, pillar_top - dz])
            cube([pillar_w + 2, 3, 5]);
    }
}
module y_carriage_world(x_pos, y_pos) {
    o = ms_origin(x_pos, y_pos);
    translate([o[0], o[1], 0]) y_carriage();
}

echo("CHECK", "m4_stage_bolt_protrude", m4_stage_bolt_len - ((stage_base_h - 3) + yc_h));
echo("CHECK", "y_mesh_gap", ((y_pitch_x_rel - xs_xc) - y_shaft_x_rel) - pinion_pd / 2);
echo("CHECK", "pillar_top_z", pillar_top);
echo("CHECK", "pillar_min", port_z + 25);
// rack length left past the pinion centre at the worst travel end
echo("CHECK", "x_rack_engage_min",
     min(x_shaft_x - (x_pos_max + xc_x0), (x_pos_min + xc_x1) - x_shaft_x));
echo("CHECK", "y_rack_engage_min",
     min(y_shaft_y - (ms_origin(0, y_travel)[1] + yc_y0), (ms_origin(0, 0)[1] + yc_y1) - y_shaft_y));
