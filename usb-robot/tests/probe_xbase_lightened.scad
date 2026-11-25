// The X base's dead areas (rear corners beside the servo holder, and
// between the two rails) must be cut away: nothing of the base inside
// these sample boxes. Must render empty.
include <../axes.scad>
intersection() {
    x_base();
    for (p = [[-45, -140], [70, -140], [-40, -60], [13, -60], [70, -60]])
        translate([p[0] - 5, p[1] - 5, -1]) cube([10, 10, xb_t + 2]);
}
