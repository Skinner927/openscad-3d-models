// The mirrored stage base must equal the normal one turned 180 deg about Z,
// so one STL serves both towers. Symmetric difference must render empty.
include <../stage.scad>
module a() { stage_hand(true) stage_base(); }
module b() { rotate([0, 0, 180]) stage_base(); }
union() { difference() { a(); b(); } difference() { b(); a(); } }
