// Tower B's cap is the normal cap flipped upside down (180 deg about Y),
// so one STL serves every stage. The mirrored cap must equal the flipped
// one: symmetric difference must render empty.
include <../stage.scad>
c = [xs_xc, 0, col_top + cap_t / 2];
module a() { translate([xs_xc, 0, 0]) mirror([1, 0, 0]) translate([-xs_xc, 0, 0]) stage_z_cap(); }
module b() { translate(c) rotate([0, 180, 0]) translate(-c) stage_z_cap(); }
union() { difference() { a(); b(); } difference() { b(); a(); } }
