// The side tab's two slots must be open all the way through. Empty.
include <../lib.scad>
intersection() {
  mg995_holder();
  for (sx = [-1, 1])
    translate([side_tie_x + sx * tie_slot_y - 1.25, -holder_hw - tie_tab_l / 2 - 1.5, servo_ear_top - 1]) cube([2.5, 3, holder_t + 2]);
}
