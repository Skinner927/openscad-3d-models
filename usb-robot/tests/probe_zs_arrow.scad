// Up-arrow recessed in the z-slider's payload face: inside the arrow head
// (wide, above centre) and the stem (narrow, below) the face skin must be
// cut away. Must render empty.
include <../stage.scad>
intersection() {
    stage_z_slider();
    for (p = [[-3, 2], [3, 2], [0, -5]])
        translate([xs_xc + p[0] - 0.3, payload_face_y - 0.3, stage_payload_z + p[1] - 0.3]) cube([0.6, 0.31, 0.6]);
}
