// Y-servo lead post on the X base's -X end: there must be material at the
// top of the post (the bridge the lead is tied to). Non-empty.
include <../axes.scad>
intersection() {
  x_base();
  translate([lead_post_x - 1, lead_post_y - 1, lead_post_top - 1.5]) cube([2, 2, 1]);
}
