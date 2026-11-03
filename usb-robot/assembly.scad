// ============================================================
//  USB Switcher Robot: full assembly preview (not for printing).
//  Plywood top = Z 0. Ports open toward -Y; the plug carriage sits in
//  front of them (toward -Y) and plugs in by moving +Y.
// ============================================================
include <assembly_lib.scad>

/* [Pose] */
// Which port the plug is at (0 = A, 1 = B)
show_port = 0;   // [0, 1]
// 0 = retracted, 20 = plugged in
y_pos = 20;      // [0:1:20]
show_plywood = true;

x_pos = port_x[show_port];

fixed_world();
x_pinion_world();
moving_world(x_pos, y_pos);
y_pinion_world(x_pos);
plug_body_world(x_pos, y_pos);
if (show_plywood) color("BurlyWood", 0.4) translate([-120, -200, -12]) cube([300, 280, 12]);
