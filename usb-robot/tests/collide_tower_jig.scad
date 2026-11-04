// The tower jig, laid on the plywood in place, must not overlap the X base
// or the two port towers. Must render empty.
include <../assembly_lib.scad>
include <../tower_jig.scad>
intersection() {
    tower_jig_world();
    union() { x_base(); for (i = [0, 1]) port_tower_world(i); }
}
