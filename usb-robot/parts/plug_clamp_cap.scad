// Clamp cap: squeezes the plug block into the cradle with 2x M3x10
// self-tappers. Qty 1. Print on its flat back face.
include <../plug_mount.scad>
rotate([90, 0, 0]) translate([0, -cap_back_y, 0]) plug_clamp_cap();
