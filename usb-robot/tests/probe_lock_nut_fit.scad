// Lock-screw nuts are 4 mm thick (M3 nylock-size). Each lock pocket must
// take a 4 mm nut (5.4 AF real size) on the screw axis, plus its insertion
// path. Covers the x-slider front lock (drop in from top), back lock (slide
// in from the -X end) and the z-slider lock (drop in from top).
// Must render empty.
include <../stage.scad>
n = 4;
af = 5.4;
d = af / cos(30);
z = stage_base_h + xs_lock_z;
intersection() {
  stage_x_slider();
  union() {
    // front lock nuts (corner down, 8 off centre each side, personal
    // preference for the male stage) + drop-in path + screw path from the face
    for (fx = [-8, 8]) {
      translate([xs_xc + fx, -xs_back_nut_y, z]) rotate([90, 0, 0]) rotate([0, 0, 90]) cylinder(d = d, h = n, center = true, $fn = 6);
      translate([xs_xc + fx - af / 2, -xs_back_nut_y - n / 2, z]) cube([af, n, xs_h + 1]);
      translate([xs_xc + fx, xs_w / 2 + 1, z]) rotate([90, 0, 0]) cylinder(d = 2.6, h = xs_w / 2 - 4 + 1);
    }
    // back lock nut (corner down) + push-in path from the bottom face
    translate([xs_xc, xs_back_nut_y, z]) rotate([90, 0, 0]) rotate([0, 0, 90]) cylinder(d = d, h = n, center = true, $fn = 6);
    translate([xs_xc - af / 2, xs_back_nut_y - n / 2, stage_base_h - 1]) cube([af, n, xs_lock_z + 1]);
  }
}
lz = zs_z0 + zs_h - 5;
x1 = xs_xc + zs_w / 2;
intersection() {
  stage_z_slider();
  union() {
    translate([x1 - zl_nut_out - 2.2, zl_screw_y, lz]) rotate([0, 90, 0]) cylinder(d = d, h = n, center = true, $fn = 6);
    translate([x1 - zl_nut_out - 2.2 - n / 2, zl_screw_y - af / 2, lz]) cube([n, af, zs_h]);
    // Z lock M3x12 socket head (5.5) recessed 3 mm into the side face
    translate([x1 + 0.01, zl_screw_y, lz]) rotate([0, -90, 0]) cylinder(d = 5.5, h = 3);
  }
}
