// Printability: the Z column overhangs the x-slider block by
// (col_w - xs_len) / 2 on each X side. A 45 deg support must fill under
// the overhang: material just below the column, near its outer edge, on
// the +X side. Must render non-empty.
include <../stage.scad>
intersection() {
    stage_x_slider();
    translate([xs_xc + (1) * (col_w / 2 - 0.55) - 0.15, (col_y0 + col_y1) / 2 - 1, xs_top - 0.4]) cube([0.3, 2, 0.3]);
}
