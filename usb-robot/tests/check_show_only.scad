// $only = "<part>" must reduce the whole assembly to that one part (used to
// find each part's visible area for the labelled assembly image).
// Must render EMPTY.
include <../assembly_lib.scad>
$only = "x_base";
module scene() {
  fixed_world(); x_pinion_world(); moving_world(port_x[0], 20);
  y_pinion_world(port_x[0]); plug_body_world(port_x[0], 20);
}
difference() { scene(); x_base(); }
