// The front X lock nut must not be able to spin in its pocket. A real nut
// (5.5 AF) turned 20 deg from its seated orientation, swept from the screw
// axis up through the open drop-in slot, must hit the pocket walls.
// Must render NON-empty.
include <../stage.scad>
af = 5.5;
d = af / cos(30);
z = stage_base_h + xs_lock_z;
intersection() {
  stage_x_slider();
  for (fx = [-8, 8]) hull() for (dz = [0, xs_h])
    translate([xs_xc + fx, -xs_back_nut_y, z + dz]) rotate([90, 0, 0]) rotate([0, 0, 90 + 20])
      cylinder(d = d, h = 4, center = true, $fn = 6);
}
