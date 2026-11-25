// The lead post has a triangular gusset on each Y side, low down near the
// base. Sample boxes inside both gussets minus the X base must be empty
// (material present on both sides).
include <../axes.scad>
difference() {
  for (sy = [-1, 1])
    translate([lead_post_x - 1, lead_post_y + sy * (lead_post_w / 2 + 3) - 1, xb_t + 0.5]) cube([2, 2, 2]);
  x_base();
}
