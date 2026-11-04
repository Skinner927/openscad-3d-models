// Tower jig locating probe: tower bases 1 mm toward the X base (-Y) must hit the jig. Must render non-empty.
include <../assembly_lib.scad>
include <../tower_jig.scad>
intersection() { tower_jig_world(); for (i = [0, 1]) translate([0, -1, 0]) port_tower_world(i); }
