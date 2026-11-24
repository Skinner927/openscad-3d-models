// The spanner's 15 deg end must grip: a real nut (5.4 AF) turned 8 deg in
// the jaw must hit it. Must render NON-empty.
include <../spanner.scad>
af = 5.4;
intersection() {
  spanner_at(0);
  rotate([0, 0, 90 + 8]) cylinder(d = af / cos(30), h = spanner_t + 2, center = true, $fn = 6);
}
