// The Y servo holder's side-wall floor screw must go through X carriage
// material: a screw-head-sized disc under it, inside the carriage, has to
// hit the carriage. Must render non-empty.
include <../axes.scad>
p = holder_floor_pts[2];
intersection() {
    x_carriage();
    at_inverted_servo(y_shaft_x_rel, y_shaft_y, y_pinion_z0, 90)
        translate([p[0], p[1], holder_floor_up]) cylinder(d = m3_head_d + 2, h = xc_h);
}
