// Both spanner ends must take a real nut (5.4 AF, flats on the jaws) and
// let it slide straight out through the mouth. Must render EMPTY.
include <../spanner.scad>
af = 5.4;
for (e = [0, 1]) intersection() {
  spanner_at(e);
  hull() for (y = [0, 20]) translate([0, y, 0])
    rotate([0, 0, 90]) cylinder(d = af / cos(30), h = spanner_t + 2, center = true, $fn = 6);
}
