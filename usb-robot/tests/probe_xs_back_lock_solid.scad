// The back X lock nut must sit in a closed pocket, not a slot through the
// slider's end face: the -X end around the nut's Y and height must be
// solid (the symmetry check covers +X). Must render NON-empty.
include <../stage.scad>
z = stage_base_h + xs_lock_z;
intersection() {
  stage_x_slider();
  translate([xs_xc - xs_len / 2 - 0.1, xs_back_nut_y - 1.5, z - 1.5]) cube([3, 3, 3]);
}
