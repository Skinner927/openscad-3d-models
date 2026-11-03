// Inverted MG995 holder. Qty 2 (X servo on the X base, Y servo on the
// X carriage). Print with the ear plate on the bed, walls up.
// Servo ears: 4x M3x12 self-tapping. Holder to floor: 3x M3x16
// self-tapping from underneath the base / carriage.
include <../lib.scad>
translate([0, 0, -servo_ear_top]) mg995_holder();
