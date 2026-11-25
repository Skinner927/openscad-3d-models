// Up-arrow recessed in the front face of the x-slider's Z rail: inside the
// arrow head (wide, above centre) and the stem (narrow, below) the rail
// face skin must be cut away. Must render empty.
include <../stage.scad>
intersection() {
    stage_x_slider();
    for (p = [[-3, 2], [3, 2], [0, -5]])
        translate([xs_xc + p[0] - 0.3, col_y1 + dt_h - 0.3, xs_top + col_h / 2 + p[1] - 0.3]) cube([0.6, 0.31, 0.6]);
}
