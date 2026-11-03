// Positioning stage base. Print as shown. Qty 3 (one with mirrored = true, for port tower B).
include <../stage.scad>
/* [Options] */
// true for port tower B (mirror image, X adjust screw faces outward)
mirrored = false;

stage_hand(mirrored) stage_base();
