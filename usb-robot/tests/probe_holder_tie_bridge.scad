// Zip-tie tab on the holder's far (-x upright, world -Y) end: the bridge
// between its two slots, where the lead lies, must be material.
// Must render non-empty.
include <../lib.scad>
intersection() {
  mg995_holder();
  translate([holder_px0 - tie_tab_l / 2 - 1, -1, servo_ear_top + 1]) cube([2, 2, holder_t - 2]);
}
