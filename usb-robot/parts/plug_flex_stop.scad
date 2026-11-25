// Flexure stop strap: one in front of the flexure, one behind, held by
// the same 2x M3x16 + nuts through the flexure's top bar. Qty 2.
// Print flat with the pin pointing up.
include <../plug_mount.scad>
rotate([-90, 0, 0]) translate([0, -strap_t, 0]) plug_flex_stop();
