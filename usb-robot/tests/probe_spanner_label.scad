// The spanner's handle must carry its size, recessed into the top face:
// the label's own outline, from just below the top face up, must cut
// nothing. Must render EMPTY.
include <../spanner.scad>
intersection() {
  nut_spanner();
  translate([0, 0, spanner_t - spanner_label_depth + 0.05]) linear_extrude(2) spanner_label_2d();
}
