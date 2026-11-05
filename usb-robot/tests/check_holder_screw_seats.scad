// Every holder floor screw head must seat on a full ring of carriage /
// base material (the land under the holder). Ring minus the part must be
// empty: no cutout may break into a head seat.
include <../axes.scad>
module seat_rings(t) {
  // the head's own footprint, held 0.05 off the land's faces (coplanar slivers)
  for (p = holder_floor_pts) translate([p[0], p[1], t - holder_floor_land(t) + 0.05])
    difference() {
      cylinder(d=m3_head_d, h=holder_floor_land(t) - 0.1, $fn=24);
      translate([0, 0, -1]) cylinder(d=m3_d + 0.5, h=t + 2, $fn=24);
    }
}
difference() {
  at_inverted_servo(y_shaft_x_rel, y_shaft_y, y_pinion_z0, 90) translate([0, 0, holder_floor_up])
    mirror([0, 0, 1]) translate([0, 0, -xc_h]) seat_rings(xc_h);
  x_carriage();
}
difference() {
  at_inverted_servo(x_shaft_x, x_shaft_y, x_pinion_z0, 90) translate([0, 0, holder_floor_up])
    mirror([0, 0, 1]) translate([0, 0, -xb_t]) seat_rings(xb_t);
  x_base();
}
