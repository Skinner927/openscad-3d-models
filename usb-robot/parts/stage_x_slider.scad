// Positioning stage x-slider + column. Print upright as shown. Qty 3 (one with mirrored = true, for port tower B).
include <../stage.scad>
/* [Options] */
// true for port tower B (mirror image, X adjust screw faces outward)
mirrored = false;

stage_hand(mirrored) translate([-xs_xc, 0, -stage_base_h]) stage_x_slider();
