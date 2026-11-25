// One-piece base: x_base must carry both towers' X rails (from the
// shortened inner end to the tab) and the solid lower part of each
// adjust-screw tab. Must render EMPTY.
include <../axes.scad>
module tower_local(i) translate([tower_x(i), tower_y, 0]) rotate([0, 0, 180]) stage_hand(i == 1) children();
module needed() for (i = [0, 1]) tower_local(i) {
    translate([tower_rail_x0, 0, stage_base_h]) dovetail_rail(stage_L / 2 - stage_tab_t - tower_rail_x0);
    translate([stage_L / 2 - stage_tab_t, -8, 0]) cube([stage_tab_t, 16, stage_base_h + xs_screw_z - 3]);
}
difference() { needed(); x_base(); }
