// Tower jig locating probe: X base 1 mm toward +X must hit the jig. Must render non-empty.
include <../assembly_lib.scad>
include <../tower_jig.scad>
intersection() { tower_jig_world(); translate([1, 0, 0]) x_base(); }
