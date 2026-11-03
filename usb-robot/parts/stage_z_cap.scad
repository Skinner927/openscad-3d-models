// Column cap holding the Z adjust screw. Print flat. Qty 3 (one with mirrored = true, for port tower B).
include <../stage.scad>
/* [Options] */
// true for port tower B (mirror image, X adjust screw faces outward)
mirrored = false;

stage_hand(mirrored) translate([-xs_xc, 0, -col_top]) stage_z_cap();
