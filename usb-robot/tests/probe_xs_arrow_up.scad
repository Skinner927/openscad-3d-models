// The Z-rail arrow must point UP (+Z): beside the stem (below centre) there
// is rail material. A down-arrow (its head would be here) or a plain
// rectangle cuts it away. Must render non-empty.
include <../stage.scad>
intersection() {
    stage_x_slider();
    for (p = [[-3, -5], [3, -5]])
        translate([xs_xc + p[0] - 0.3, col_y1 + dt_h - 0.3, xs_top + col_h / 2 + p[1] - 0.3]) cube([0.6, 0.31, 0.6]);
}
