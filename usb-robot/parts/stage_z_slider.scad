// Positioning stage z-slider. Printed lying on its payload face. Qty 3 (one with mirrored = true, for port tower B).
include <../stage.scad>
/* [Options] */
// true for port tower B (mirror image, X adjust screw faces outward)
mirrored = false;

stage_hand(mirrored) rotate([-90, 0, 0]) translate([-xs_xc, -payload_face_y, -stage_payload_z]) stage_z_slider();
