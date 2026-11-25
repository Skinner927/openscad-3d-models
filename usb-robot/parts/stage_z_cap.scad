// Column cap holding the Z adjust screw. Print flat. Qty 3, all identical:
// port tower B's cap is this one flipped upside down, which puts the Z adjust
// hole on the other side (tests/check_stage_z_cap_flip.scad).
include <../stage.scad>

translate([-xs_xc, 0, -col_top]) stage_z_cap();
