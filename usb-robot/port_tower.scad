// ============================================================
//  Female port tower: positioning stage (rotated 180 deg so its
//  payload face looks toward -Y) + bracket plate with the keyed
//  D-hole. The bulkhead goes in from the back (flange behind the
//  plate), nut on the front. Plate front face is at world y=0.
// ============================================================
include <stage.scad>

bracket_w      = 36;
bracket_hole_dz = port_z - stage_payload_z;   // hole above payload centre
bracket_bot    = -zs_h / 2;
bracket_top    = bracket_hole_dz + bh_nut_af / cos(30) / 2 + 3;
rib_t          = 5;     // rib width (X)
rib_d          = 7;     // rib depth (out of the plate front)

// Payload-face coordinates: origin at face centre, +Y away from the stage.
module port_bracket() {
    difference() {
        union() {
            translate([-bracket_w / 2, 0, bracket_bot]) cube([bracket_w, plate_t, bracket_top - bracket_bot]);
            // stiffening ribs, outboard of the nut and clear of the plug clamp
            for (sx = [-1, 1])
                translate([sx > 0 ? bracket_w / 2 - rib_t : -bracket_w / 2, plate_t - 0.01, bracket_bot])
                    hull() {
                        cube([rib_t, rib_d, 1]);
                        translate([0, 0, bracket_hole_dz - 14]) cube([rib_t, 0.01, 1]);
                    }
        }
        // keyed D-hole, flat on top
        translate([0, plate_t, bracket_hole_dz]) rotate([90, 0, 0]) d_hole(t = plate_t);
        // mounting screws into the z-slider's captive nuts
        for (p = payload_pts) translate([p[0], -0.01, p[1]]) rotate([-90, 0, 0]) {
            screw_hole(m3_d, plate_t + rib_d);
        }
    }
}

// Whole tower in world coordinates at fine-travel offset (dx, dz),
// measured in world X / Z.
// Tower B (i=1) is the mirror image so its X adjust screw faces outward.
module port_tower_world(i, dx = 0, dz = 0) {
    ldx = i == 0 ? -dx : dx;   // world dx -> stage-local dx
    translate([tower_x(i), tower_y, 0]) rotate([0, 0, 180]) stage_hand(i == 1) {
        stage_assembly(ldx, dz);
        stage_payload_origin(ldx, dz) color("Orange") port_bracket();
    }
}

// Bulkhead connector stand-in (for checks / preview), world coords.
module bulkhead_world(i, dx = 0, dz = 0) {
    translate([port_x[i] + dx, port_face_y, port_z + dz]) rotate([90, 0, 0]) color("DimGray") {
        cylinder(d = bh_thread_d, h = bh_thread_len - plate_t);                   // thread + face
        cylinder(d = bh_nut_af / cos(30), h = bh_nut_t, $fn = 6);                  // nut
        translate([0, 0, -plate_t - 2]) cylinder(d = bh_flange_d, h = 2);          // flange
        translate([0, 0, -plate_t - 40]) cylinder(d = 14, h = 38);                 // body
    }
}

echo("CHECK", "port_z", port_z);
