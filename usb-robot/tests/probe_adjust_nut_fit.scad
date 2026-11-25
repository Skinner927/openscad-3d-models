// A real M3 nut (5.4 AF, measured) must fit each adjust slot centred on
// its screw, plus its insertion path. Must render empty.
include <../stage.scad>
af = 5.4;
d = af / cos(30);
xz = stage_base_h + xs_screw_z;
intersection() {
  stage_x_slider();
  for (sx = [-1, 1]) translate([xs_xc + sx * (xs_len / 2 - 6), 0, xz]) {
    rotate([0, 90, 0]) cylinder(d = d, h = 2.4, center = true, $fn = 6);
    translate([-1.2, -af / 2, 0]) cube([2.4, af, xs_h]);
  }
}
intersection() {
  stage_z_slider();
  translate([xs_xc + zs_screw_x, zs_screw_y, zs_z0 + zs_h - 5]) {
    cylinder(d = d, h = 2.4, center = true, $fn = 6);
    translate([-zs_w, -af / 2, -1.2]) cube([zs_w, af, 2.4]);
  }
}
