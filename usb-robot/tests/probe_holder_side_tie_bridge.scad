// Side zip-tie tab on the holder's side wall (world -X): the bridge
// between its slots, where the lead lies, must be material. Non-empty.
include <../lib.scad>
intersection() {
  mg995_holder();
  translate([side_tie_x - 1, -holder_hw - tie_tab_l / 2 - 1, servo_ear_top + 1]) cube([2, 2, holder_t - 2]);
}
