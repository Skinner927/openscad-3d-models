// The tie tab's two slots must be open all the way through, wide enough
// for a 3 x 2.5 mm zip tie. Must render empty.
include <../lib.scad>
intersection() {
  mg995_holder();
  for (sy = [-1, 1])
    translate([holder_px0 - tie_tab_l / 2 - 1.5, sy * tie_slot_y - 1.25, servo_ear_top - 1]) cube([3, 2.5, holder_t + 2]);
}
