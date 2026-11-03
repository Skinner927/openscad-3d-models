// All stage parts must stay disjoint at every corner of fine travel.
include <../stage.scad>

for (dx = [-stage_travel, stage_travel], dz = [-stage_travel, stage_travel]) {
    intersection() { stage_base();              stage_x_slider_placed(dx); }
    intersection() { stage_base();              stage_z_slider_placed(dx, dz); }
    intersection() { stage_x_slider_placed(dx); stage_z_slider_placed(dx, dz); }
    intersection() { stage_z_cap_placed(dx);    stage_z_slider_placed(dx, dz); }
}
