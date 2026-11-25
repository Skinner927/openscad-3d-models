// The pinion clearance under the X servo is a through speed hole, not a
// 1 mm pocket: a column through the full plate around the shaft must
// hold no X base material. Must render empty.
include <../axes.scad>
intersection() {
  x_base();
  translate([x_shaft_x, x_shaft_y, -1]) cylinder(r = pinion_pd / 2, h = xb_t + 2);
}
