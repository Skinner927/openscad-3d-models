// Pinion centre hole is a through-bore wide enough for the horn's centre
// screw head, so the screw sits directly on the horn hub (the stock screw
// is too short to also pass pinion material). Must render empty.
include <../lib.scad>
intersection() {
    pinion();
    translate([0, 0, -1]) cylinder(d = 6.8, h = gear_thick + 2);
}
