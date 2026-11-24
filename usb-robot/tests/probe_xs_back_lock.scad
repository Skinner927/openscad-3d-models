// X lock screw on the x-slider's back (-Y) face, centred, for the towers
// (their front faces the X axis). The screw path from the back face to
// the rail slot, its corner-down nut, and the nut's push-in path from the
// slider's bottom face must all be open. Must render empty.
include <../stage.scad>
z = stage_base_h + xs_lock_z;
af = 5.4;
intersection() {
  stage_x_slider();
  union() {
    // screw path: back face -> rail slot
    translate([xs_xc, -xs_w / 2 - 1, z]) rotate([-90, 0, 0]) cylinder(d = 2.6, h = xs_w / 2 - 4);
    // nut (axis along Y, corner down)
    translate([xs_xc, xs_back_nut_y, z]) rotate([90, 0, 0]) rotate([0, 0, 90]) cylinder(d = af / cos(30), h = 4, center = true, $fn = 6);
    // push-in path from the bottom face up to the nut
    translate([xs_xc - af / 2, xs_back_nut_y - 2, stage_base_h - 1]) cube([af, 4, xs_lock_z + 1]);
  }
}
