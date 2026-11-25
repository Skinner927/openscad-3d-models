// Plug mount fully inserted at each port: the stage, flexure, clamp and
// straps must not touch the port tower, nut or bulkhead (male stage at
// every Z travel corner; plug body itself excluded).
include <../plug_mount.scad>

for (i = [0, 1], dz = [-stage_travel, 0, stage_travel])
    intersection() {
        plug_mount_world(port_x[i], y_travel, 0, dz);
        union() { port_tower_world(i); bulkhead_world(i); }
    }
