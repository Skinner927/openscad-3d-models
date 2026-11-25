// Y carriage must clear the X carriage and the Y servo at both ends of
// Y travel, at both ends of X travel.
include <../axes.scad>

for (xp = [x_pos_min, x_pos_max], yp = [0, y_travel])
    intersection() {
        y_carriage_world(xp, yp);
        union() { x_carriage_world(xp); y_servo_world(xp); x_servo_world(); x_base(); }
    }
