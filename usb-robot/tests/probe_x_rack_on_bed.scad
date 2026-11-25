// The X rack (on the X carriage's -Y face) must reach the carriage's bottom
// face so it prints without supports: material in a thin slab at the bed,
// in front of the -Y face. Must render non-empty.
include <../axes.scad>
intersection() {
    x_carriage();
    translate([xc_x0 + 5, xc_y0 - 3, xc_z0]) cube([xc_len - 10, 2.5, 0.3]);
}
