// The exported pinion must be printable without supports: horn recess
// facing up (open), so a thin disc just under its top face, inside the
// recess, must contain no material. Must render empty.
use <../parts/pinion.scad>
include <../lib.scad>
intersection() {
    pinion_print();
    translate([0, 0, gear_thick - horn_t + 0.5]) cylinder(d = horn_d - 1, h = 0.5);
}
