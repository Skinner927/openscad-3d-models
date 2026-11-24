// The back X lock nut must not spin: a real nut (5.4 AF, measured) turned 8 deg
// from corner-down, swept down through the open bottom of its pocket,
// must hit the pocket walls. Must render NON-empty.
include <../stage.scad>
af = 5.4;
z = stage_base_h + xs_lock_z;
intersection() {
  stage_x_slider();
  hull() for (dz = [0, -5])
    translate([xs_xc, xs_back_nut_y, z + dz]) rotate([90, 0, 0]) rotate([0, 0, 90 + 8])
      cylinder(d = af / cos(30), h = 4, center = true, $fn = 6);
}
