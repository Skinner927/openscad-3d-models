// The X adjust nuts must not spin: a real M3 nut (5.4 AF, measured) turned
// 8 deg, swept up through each slot's open top, must hit the walls of both
// x-slider adjust slots. Must render NON-empty.
include <../stage.scad>
af = 5.4;
xz = stage_base_h + xs_screw_z;
module x_swept(sx) hull() for (dz = [0, xs_h])
  translate([xs_xc + sx * (xs_len / 2 - 6), 0, xz + dz]) rotate([0, 90, 0]) rotate([0, 0, 8])
    cylinder(d = af / cos(30), h = 2.4, center = true, $fn = 6);
// each slot's hits, moved to a common point, must overlap
intersection() {
  translate([-(xs_xc - (xs_len / 2 - 6)), 0, -xz]) intersection() { stage_x_slider(); x_swept(-1); }
  translate([-(xs_xc + (xs_len / 2 - 6)), 0, -xz]) intersection() { stage_x_slider(); x_swept(1); }
}
