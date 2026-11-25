// The payload-face arrow must point UP (+Z): beside the stem (below centre)
// there is face material. A down-arrow (its head would be here) or a plain
// rectangle cuts it away. Must render non-empty.
include <../stage.scad>
intersection() {
    stage_z_slider();
    for (p = [[-3, -5], [3, -5]])
        translate([xs_xc + p[0] - 0.3, payload_face_y - 0.3, stage_payload_z + p[1] - 0.3]) cube([0.6, 0.31, 0.6]);
}
