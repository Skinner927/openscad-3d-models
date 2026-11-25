// Bulkhead body + strain relief need a clear 22 mm x 45 mm zone behind the
// plate. Nothing in either tower may enter it, at any stage travel corner.
include <../port_tower.scad>

for (i = [0, 1], dx = [-stage_travel, stage_travel], dz = [-stage_travel, stage_travel])
    intersection() {
        port_tower_world(i, dx, dz);
        translate([port_x[i] - dx, port_face_y + plate_t, port_z + dz])
            rotate([-90, 0, 0]) cylinder(d = 22, h = bh_rear_clear);
    }
