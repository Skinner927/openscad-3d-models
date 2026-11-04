// Tower jig locating probe: X base 1 mm toward the towers (+Y) must hit the jig. Must render non-empty.
include <../assembly_lib.scad>
include <../tower_jig.scad>
intersection() { tower_jig_world(); translate([0, 1, 0]) x_base(); }
