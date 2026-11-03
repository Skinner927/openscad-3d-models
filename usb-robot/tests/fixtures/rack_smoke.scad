// Rack + pinion in mesh, for render / manifold check.
include <../../lib.scad>
rack(60);
// phase so a pinion tooth (pointing -Y) sits in the rack gap at x = 6p
translate([6 * PI * gear_mod, rack_pitch_y() + pinion_pd / 2, 0]) rotate(-90) pinion();
