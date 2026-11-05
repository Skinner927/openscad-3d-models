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
        // stops 0.5 short of the holder side wall so it never undercuts
        // the wall or its floor screw
        intersection() {
            translate([x_shaft_x, x_shaft_y, xb_t - 1]) cylinder(r = pinion_pd / 2 + gear_mod + 1, h = 2);
            at_inverted_servo(x_shaft_x, x_shaft_y, x_pinion_z0, 90)
                translate([-50, -(holder_hw - holder_side_t - 0.5), -100]) cube([100, 100, 200]);
        }
        // speed holes: the plywood gives the stiffness, so keep only a frame
        translate([0, 0, -1]) linear_extrude(xb_t + 2) xb_windows_2d();
    }
}

// Through-cutouts in the X base. Kept: an xb_frame perimeter, a strip
// under each rail, the servo holder footprint (+ margin), and a pad
// around every wood screw.
xb_frame  = 8;
xb_rib    = 8;      // cross ribs between the rails
xb_round  = 4;      // window corner radius
xb_holder_x = [x_shaft_x - holder_hw - 6, x_shaft_x + holder_hw + 6];
xb_rail_keep = [x_rail_y[0] - runner_w / 2 - 6, x_rail_y[1] - dt_w / 2 - 6,
                x_rail_y[1] + dt_w / 2 + 6];
module xb_windows_2d() {
    x0 = xb_x0 + xb_frame;  x1 = xb_x1 - xb_frame;
    ry0 = xb_y0 + xb_frame; ry1 = xb_rail_keep[0];          // behind the runner
    my0 = x_rail_y[0] + runner_w / 2 + 6; my1 = xb_rail_keep[1];  // between the rails
    n = 3;                                                  // windows between the rails
    w = (x1 - x0 - (n - 1) * xb_rib) / n;
    offset(r = xb_round) offset(delta = -xb_round) difference() {
        union() {
            translate([x0, ry0]) square([xb_holder_x[0] - x0, ry1 - ry0]);
            translate([xb_holder_x[1], ry0]) square([x1 - xb_holder_x[1], ry1 - ry0]);
            for (i = [0:n - 1]) translate([x0 + i * (w + xb_rib), my0]) square([w, my1 - my0]);
        }
        for (p = xb_screws) translate(p) circle(r = m4_head_d / 2 + 4);
    }
}
echo("CHECK", "xb_window_min", min(xb_holder_x[0] - xb_x0 - xb_frame,
                                     xb_rail_keep[1] - (x_rail_y[0] + runner_w / 2 + 6)));

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
            // X rack on the -Y face, teeth toward -Y. Runs down to the
            // carriage's bottom face so it prints without supports.
            translate([xc_x0, xc_y0 + 0.01, xc_z0]) mirror([0, 1, 0])
                rack(xc_len, thick = x_rack_z0 - xc_z0 + gear_thick, base_h = rack_base);
            // Y rail on top, under the Y carriage
            translate([-xs_xc, xc_y0, xc_top]) rotate([0, 0, 90]) dovetail_rail(xc_y1 - xc_y0);
        }
        y_holder_floor_holes();
        translate([xc_x0 - 1, x_rail_y[1], xc_z0]) dovetail_slot(xc_len + 2);
        translate([xc_x0 - 1, x_rail_y[0] - runner_w / 2 - clr - 0.15, xc_z0 - 1])
            cube([xc_len + 2, runner_w + 2 * clr + 0.3, runner_h + clr + 1]);
        translate([xc_x0 - 1, x_rail_y[0], xc_z0]) rotate([90, 0, 90]) linear_extrude(xc_len + 2)
            chamfer_mouth(runner_w + 2 * clr + 0.3);
    }
}
module x_carriage_world(x_pos) { translate([x_pos, 0, 0]) x_carriage(); }
module y_servo_world(x_pos) { translate([x_pos, 0, 0]) { y_servo_local(); y_servo_holder_local(); } }
module y_pinion_world(x_pos) {
    translate([x_pos + y_shaft_x_rel, y_shaft_y, y_pinion_z0]) color("Gold") pinion();
}

echo("CHECK", "x_rail_len", x_rail_len);
// holder floor screws: thread into the holder's 12 mm tapped hole, both floors
echo("CHECK", "holder_screw_engage_min", min([for (t = [xb_t, xc_h]) holder_screw_len - holder_floor_land(t)]));
echo("CHECK", "holder_screw_bottom_min", min([for (t = [xb_t, xc_h]) 12 - (holder_screw_len - holder_floor_land(t))]));
// Y holder's outer side-wall face must sit over the carriage (-X end)
echo("CHECK", "y_holder_on_carriage", (y_shaft_x_rel - holder_hw) - xc_x0);
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
            translate([yc_x0 + 0.01, yc_y0, yc_z0]) rotate([0, 0, 90])
                rack(yc_len, thick = y_rack_z0 - yc_z0 + gear_thick, base_h = rack_base);  // down to the bed
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
