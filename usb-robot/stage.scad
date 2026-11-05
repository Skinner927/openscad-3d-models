// ============================================================
//  Positioning stage: base (X dovetail) -> x-slider with column
//  (Z dovetail) -> z-slider (payload face toward +Y) + column cap.
//  Every axis: M3 adjust screw captured in the fixed part by head +
//  nylock, threading into a captive nut in the moving part
//  (0.5 mm/turn, both directions), plus an M3 lock screw.
//  Modules model parts in stage-local coordinates at mid travel.
// ============================================================
include <lib.scad>

// Dovetail standing on the column's +Y face, running along Z.
// multmatrix maps (x,y,z) -> (y,z,x): run->Z, width->X, height->Y.
module zrail_frame() { multmatrix([[0,1,0,0],[0,0,1,0],[1,0,0,0]]) children(); }

module stage_base() {
    rail_x0 = -stage_L / 2;
    rail_len = stage_L - stage_tab_t;
    tab_h = stage_base_h + xs_screw_z + 6;
    difference() {
        union() {
            translate([-stage_L / 2, -stage_D / 2, 0]) cube([stage_L, stage_D, stage_base_h]);
            translate([rail_x0, 0, stage_base_h]) dovetail_rail(rail_len);
            // adjust-screw tab
            translate([stage_L / 2 - stage_tab_t, -8, 0]) cube([stage_tab_t, 16, tab_h]);
        }
        wood_screw_holes(stage_mount_pts, stage_base_h, cbore = 3);
        // X adjust screw through tab (head outside, nylock inside)
        translate([stage_L / 2 - stage_tab_t - 1, 0, stage_base_h + xs_screw_z])
            rotate([0, 90, 0]) screw_hole(m3_d, stage_tab_t + 2);
    }
}

// Orientation mark: up-arrow (+Z) recessed zs_arrow_depth into a face
// that looks toward +Y, centred on the origin (head 9 wide, tip 7 up).
module up_arrow_cut() {
    translate([0, 0.01, 0]) rotate([90, 0, 0]) linear_extrude(zs_arrow_depth + 0.01)
        polygon([[-1.5, -7], [1.5, -7], [1.5, 1], [4.5, 1], [0, 7], [-4.5, 1], [-1.5, 1]]);
}

// X lock screws: height above the base top (onto the rail flank), and the
// back nut's Y (the front one mirrors it).
xs_lock_z = 3; // nuts rest flat on the base 0.25 below the axis and lift onto it
xs_back_nut_y = -9;
xs_front_nut_rest = (m3_nut_af - 0.2) / 2; // front nut sits flat-down too
// Upper stack shares the x-slider's X offset.
col_ovh = (col_w - xs_len) / 2;   // column overhang past the block, per X side
module stage_x_slider() {
    x0 = xs_xc - xs_len / 2;
    difference() {
        union() {
            translate([x0, -xs_w / 2, stage_base_h]) cube([xs_len, xs_w, xs_h]);
            // column
            translate([xs_xc - col_w / 2, col_y0, xs_top - 0.01]) cube([col_w, col_t, col_h + 0.01]);
            translate([xs_xc, col_y1, xs_top]) zrail_frame() dovetail_rail(col_h);
            // 45 deg supports under the column where it overhangs the block (X sides)
            for (sx = [-1, 1]) let (e = xs_xc + sx * xs_len / 2, o = sx * col_ovh)
                translate([0, col_y1, 0]) rotate([90, 0, 0]) linear_extrude(col_t)
                    polygon([[e - sx * 0.01, xs_top - col_ovh - 0.01], [e - sx * 0.01, xs_top + 0.01],
                             [e + o, xs_top + 0.01]]);
        }
        translate([x0 - 1, 0, stage_base_h]) dovetail_slot(xs_len + 2);
        // X adjust: screw enters +X face, nut dropped in from the top
        translate([x0 + xs_len + 0.01, 0, stage_base_h + xs_screw_z]) rotate([0, -90, 0])
            screw_hole(m3_d, xs_adj_hole);
        translate([x0 + xs_len - 6 - m3_nut_t / 2, -(m3_nut_af + clr) / 2, stage_base_h + xs_screw_z - 3.5])
            cube([m3_nut_t + 0.4, m3_nut_af + clr, xs_h]);
        // X lock (male stage): horizontal from the +Y face onto the rail
        // flank, nut dropped in from the top, flats down
        translate([xs_xc + 8, xs_w / 2 + 0.01, stage_base_h + xs_lock_z]) rotate([90, 0, 0])
            screw_hole(m3_d, xs_w / 2 - 3);
        translate([xs_xc + 8 - (m3_nut_af + clr) / 2 / cos(30), -xs_back_nut_y - (m3_nut_t + 0.4) / 2, stage_base_h - 0.01])
            cube([(m3_nut_af + clr) / cos(30), m3_nut_t + 0.4, xs_h]);
        // X lock (towers): centred on the -Y (back) face, which faces away
        // from the X axis. The column covers the top, so the nut slides in
        // along X from the -X end face, flats up.
        translate([xs_xc, -xs_w / 2 - 0.01, stage_base_h + xs_lock_z]) rotate([-90, 0, 0])
            screw_hole(m3_d, xs_w / 2 - 3);
        translate([x0 - 1, xs_back_nut_y - (m3_nut_t + 0.4) / 2, stage_base_h + xs_lock_z - (m3_nut_af + clr) / 2])
            cube([xs_xc - x0 + 1 + (m3_nut_af + clr) / 2 / cos(30), m3_nut_t + 0.4, m3_nut_af + clr]);
        // recessed up-arrow on the Z rail's front face (matches the z-slider's)
        translate([xs_xc, col_y1 + dt_h, xs_top + col_h / 2]) up_arrow_cut();
        // cap screws (tapped into column top)
        for (sx = [-8, 8]) translate([xs_xc + sx, col_y0 + 5, col_top - 10])
            screw_hole(m3_tap, 10.1);
    }
}

module stage_z_slider() {
    y0 = col_y1;
    x0 = xs_xc - zs_w / 2;
    difference() {
        translate([x0, y0, zs_z0]) cube([zs_w, zs_t, zs_h]);
        translate([xs_xc, col_y1, zs_z0 - 1]) zrail_frame() dovetail_slot(zs_h + 2);
        // payload holes + nut slots from the bottom
        for (p = payload_pts) {
            translate([xs_xc + p[0], payload_face_y + 0.01, stage_payload_z + p[1]])
                rotate([90, 0, 0]) screw_hole(m3_d, payload_hole_depth);
            translate([xs_xc + p[0] - (m3_nut_af + clr) / 2, payload_face_y - 4 - (m3_nut_t + 0.4) / 2, zs_z0 - 1])
                cube([m3_nut_af + clr, m3_nut_t + 0.4, zs_h / 2 + 1 + 3.3]);
        }
        // recessed up-arrow on the payload face: shows which way is up when
        // mounting the port bracket / flexure
        translate([xs_xc, payload_face_y, stage_payload_z]) up_arrow_cut();
        // Z adjust: through hole, nut slot from the -X side 5 below the top
        translate([xs_xc + zs_screw_x, zs_screw_y, zs_z0 + zs_h - zs_adj_hole]) screw_hole(m3_d, zs_adj_hole + 0.1);
        translate([x0 - 1, zs_screw_y - (m3_nut_af + clr) / 2, zs_z0 + zs_h - 5 - (m3_nut_t + 0.4) / 2])
            cube([zs_screw_x + zs_w / 2 + 1 + (m3_nut_af + clr) / 2, m3_nut_af + clr, m3_nut_t + 0.4]);
        // Z lock: from the +X (outward) side onto the rail flank, nut dropped in from the top
        lz = zs_z0 + zs_h - 5;
        x1 = x0 + zs_w;
        translate([x1 + 0.01, col_y1 + 2, lz]) rotate([0, -90, 0]) screw_hole(m3_d, zs_w / 2 - 4);
        translate([x1 - 2.5 - (m3_nut_t + 0.4), col_y1 + 2 - zl_pocket_w / 2, lz - (m3_nut_af + clr) / 2 / cos(30)])
            cube([m3_nut_t + 0.4, zl_pocket_w, zs_h]);
    }
}

module stage_z_cap() {
    difference() {
        // stops 1 mm short of the payload face so the payload never rubs it
        translate([xs_xc - col_w / 2, col_y0, col_top]) cube([col_w, payload_face_y - col_y0 - 1, cap_t]);
        for (sx = [-8, 8]) translate([xs_xc + sx, col_y0 + 5, col_top]) screw_hole(m3_d, cap_t);
        translate([xs_xc + zs_screw_x, zs_screw_y, col_top]) screw_hole(m3_d, cap_t);
    }
}

// ---- placed at a fine-travel offset (dx, dz) ----
module stage_x_slider_placed(dx = 0) { translate([dx, 0, 0]) stage_x_slider(); }
module stage_z_cap_placed(dx = 0)    { translate([dx, 0, 0]) stage_z_cap(); }
module stage_z_slider_placed(dx = 0, dz = 0) { translate([dx, 0, dz]) stage_z_slider(); }

// Children placed at the payload face centre (origin on the face, +Y out).
module stage_payload_origin(dx = 0, dz = 0) {
    translate([xs_xc + dx, payload_face_y, stage_payload_z + dz]) children();
}

// Optional mirror (tower B) wraps the stage-local geometry.
module stage_hand(mir) { if (mir) mirror([1, 0, 0]) children(); else children(); }

module stage_assembly(dx = 0, dz = 0) {
    color("SteelBlue") stage_base();
    color("LightSteelBlue") stage_x_slider_placed(dx);
    color("SkyBlue") stage_z_cap_placed(dx);
    color("CadetBlue") stage_z_slider_placed(dx, dz);
}

// ---- travel checks ----
_right_gap = (stage_L / 2 - stage_tab_t) - (xs_xc + xs_len / 2) - locknut_t;
_left_ok   = 10;   // slider may overhang the rail start by up to 10 mm
echo("CHECK", "stage_travel_x", 2 * min(_right_gap, _left_ok));
// adjust screws: head on the fixed tab/cap, tip must pass the moving nut
// at the far travel end and stay inside the hole at the near end
_xnut = xs_xc + xs_len / 2 - 6;                  // nut centre X at mid
_xtip = stage_L / 2 - x_adj_len;
echo("CHECK", "x_adj_engage", (_xnut - stage_travel - (m3_nut_t + 0.4) / 2) - _xtip);
echo("CHECK", "x_adj_hole", _xtip - (xs_xc + xs_len / 2 + stage_travel - xs_adj_hole));
_znut = zs_z0 + zs_h - 5;
_ztip = stage_top_z - z_adj_len;
echo("CHECK", "z_adj_engage", (_znut - stage_travel - (m3_nut_t + 0.4) / 2) - _ztip);
echo("CHECK", "z_adj_hole", _ztip - (zs_z0 + zs_h + stage_travel - zs_adj_hole));
echo("CHECK", "z_lock_pocket_w", zl_pocket_w);
// X lock nuts rest on the stage base (pockets open underneath). Screw axis
// minus the resting nut centre: the nut can lift a little but never drop.
// Real nut is 0.2 under m3_nut_af. Worst of the two pockets.
echo("CHECK", "xs_lock_nut_lift", min(xs_lock_z - xs_front_nut_rest, xs_lock_z - (m3_nut_af - 0.2) / 2));
echo("CHECK", "xs_lock_nut_lift_max", max(xs_lock_z - xs_front_nut_rest, xs_lock_z - (m3_nut_af - 0.2) / 2));
// port bracket M3x12 tip (through the 4 mm plate) must not bottom out
echo("CHECK", "bracket_screw_room", payload_hole_depth - (bracket_screw_len - plate_t));
// cap screw: thread into the column's 10 mm tapped hole
echo("CHECK", "cap_screw_engage", cap_screw_len - cap_t);
echo("CHECK", "cap_screw_bottom", 10 - (cap_screw_len - cap_t));
echo("CHECK", "stage_travel_z", 2 * min(stage_gap_z, cap_gap - locknut_t));
