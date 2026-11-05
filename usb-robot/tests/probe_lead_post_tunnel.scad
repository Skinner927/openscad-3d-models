// The post's zip-tie tunnel (along Y, under the top bridge) must be open
// right through. Empty.
include <../axes.scad>
intersection() {
  x_base();
  translate([lead_post_x - 1.25, lead_post_y - 20, lead_post_tunnel_z - 1.25]) cube([2.5, 40, 2.5]);
}
