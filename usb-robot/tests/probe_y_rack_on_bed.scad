// The Y rack (on the Y carriage's -X face) must reach the carriage's bottom
// face so it prints without supports. Must render non-empty.
include <../axes.scad>
intersection() {
    y_carriage();
    translate([yc_x0 - 3, yc_y0 + 5, yc_z0]) cube([2.5, yc_len - 10, 0.3]);
}
