// X carriage: X rack, Y rail, inverted Y servo holder. Qty 1.
// Print as shown (slots down; they bridge).
include <../axes.scad>
translate([-xc_x0, -xc_y0 + 10, -xc_z0]) x_carriage();
