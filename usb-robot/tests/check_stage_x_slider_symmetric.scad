// The x-slider must be mirror-symmetric about its own centre (x = xs_xc),
// so one STL serves both towers (X adjust screw from either end).
// Symmetric difference must render empty.
include <../stage.scad>
module a() { stage_x_slider(); }
module b() { translate([xs_xc, 0, 0]) mirror([1, 0, 0]) translate([-xs_xc, 0, 0]) stage_x_slider(); }
union() { difference() { a(); b(); } difference() { b(); a(); } }
