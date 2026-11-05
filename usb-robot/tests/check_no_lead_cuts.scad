// The old servo-lead notch / trough and zip-tie slots in the X base and
// X carriage were removed (no wire can route through them). Their former
// spots must be solid: sample boxes minus the part must be empty.
include <../axes.scad>
difference() {
  union() {
    translate([x_shaft_x - 3, xb_y0 + 0.5, 0.5]) cube([6, 6, xb_t - 1]);
    for (dx = [-10, 10]) translate([x_shaft_x + dx - 1, xb_y0 + 12.5, 0.5]) cube([2, 4, xb_t - 1]);
  }
  x_base();
}
difference() {
  union() {
    translate([y_shaft_x_rel - 3, xc_y0 + 3.5, xc_top - 3.5]) cube([6, 5, 3]);
    for (dy = [12, 24]) translate([xc_x0 + 3.5, xc_y0 + dy + 0.5, xc_top - 5]) cube([4, 2, 4.5]);
  }
  x_carriage();
}
