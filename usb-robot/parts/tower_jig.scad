// Tower placement jig. Qty 1. Print flat as exported, no supports.
// Use: screw the X base down, butt the jig's straight edge against the
// X base's back edge with its arms around the back corners, drop the
// two bare stage bases into the pockets (tower B = mirrored base on the
// right), screw them down, lift the jig off.
include <../tower_jig.scad>
translate([-(xb_x0 - jig_clr - jig_arm_w), -(xb_y1 - jig_arm_l), 0]) tower_jig_world();
