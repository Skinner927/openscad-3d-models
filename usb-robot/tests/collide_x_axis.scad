// X carriage must clear the X base, the X servo and its holder at both
// ends of travel (pinions excluded: they mesh with the racks by design).
include <../axes.scad>

for (xp = [x_pos_min, x_pos_max])
    intersection() {
        x_carriage_world(xp);
        union() { x_base(); x_servo_world(); }
    }
