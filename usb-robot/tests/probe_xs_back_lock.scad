// X lock screw on the x-slider's back (-Y) face, centred, for the towers
// (their front faces the X axis). The screw path from the back face to
// the rail slot, its nut, and the nut's insertion slot from the -X end
// must all be open. Must render empty.
include <../stage.scad>
z = stage_base_h + xs_lock_z;
intersection() {
  stage_x_slider();
  union() {
    // screw path: back face -> rail slot
    translate([xs_xc, -xs_w / 2 - 1, z]) rotate([-90, 0, 0]) cylinder(d = 2.6, h = xs_w / 2 - 4);
    // nut (axis along Y)
    translate([xs_xc, xs_back_nut_y, z]) rotate([90, 0, 0]) cylinder(d = 5.4 / cos(30), h = 2.4, center = true, $fn = 6);
    // insertion slot from the -X end face to the nut
    translate([xs_xc - xs_len / 2 - 1, xs_back_nut_y - 1.2, z - 2.6]) cube([xs_len / 2 + 1, 2.4, 5.2]);
  }
}
