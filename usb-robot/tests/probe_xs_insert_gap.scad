// One-piece base: each x-slider goes on by lowering it straight down into
// the gap between the two towers' rail ends, then sliding it outward. Its
// solid outline (hull: the body above the slot lands on any rail under
// it), centred in the gap and 2 mm either side, must clear the base.
// Must render EMPTY.
include <../axes.scad>
gx = (tower_x(0) + tower_x(1)) / 2; // gap centre (world X)
intersection() {
  x_base();
  for (s = [-2, 2], i = [0, 1]) translate([gx + s, tower_y, 0.01]) rotate([0, 0, 180]) stage_hand(i == 1)
    translate([-xs_xc, 0, 0]) hull() stage_x_slider();
}
