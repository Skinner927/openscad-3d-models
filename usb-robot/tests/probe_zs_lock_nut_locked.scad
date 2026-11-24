// The z-slider's Z lock nut must not spin: a real nut (5.4 AF, measured)
// turned 8 deg from corner-down, swept up through the open top of its
// pocket, must hit the pocket walls. Must render NON-empty.
include <../stage.scad>
af = 5.4;
lz = zs_z0 + zs_h - 5;
x1 = xs_xc + zs_w / 2;
intersection() {
  stage_z_slider();
  hull() for (dz = [0, zs_h])
    translate([x1 - 2.5 - (lock_nut_t + 0.4) / 2, zl_screw_y, lz + dz]) rotate([0, 90, 0]) rotate([0, 0, 8])
      cylinder(d = af / cos(30), h = 4, center = true, $fn = 6);
}
