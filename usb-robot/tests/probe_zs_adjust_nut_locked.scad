// The Z adjust nut must not spin: a real M3 nut (5.4 AF, measured) turned
// 8 deg, swept along the slot toward its -X opening (starting 1 mm short of
// the screw so the end wall doesn't count), must hit the slot's side walls.
// Must render NON-empty.
include <../stage.scad>
af = 5.4;
intersection() {
  stage_z_slider();
  hull() for (dx = [-1, -zs_w])
    translate([xs_xc + zs_screw_x + dx, zs_screw_y, zs_z0 + zs_h - 5]) rotate([0, 0, 8])
      cylinder(d = af / cos(30), h = 2.4, center = true, $fn = 6);
}
