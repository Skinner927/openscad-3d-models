// Positioning stage x-slider + column. Print upright as shown. Qty 3.
// Symmetric about its centre, so the same part serves both towers: the X
// adjust nut goes in the slot at the end facing the base's screw tab.
include <../stage.scad>

translate([-xs_xc, 0, -stage_base_h]) stage_x_slider();
