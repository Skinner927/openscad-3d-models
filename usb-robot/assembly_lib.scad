// World-placement groups shared by assembly.scad and the full-machine
// collision test. Pinions are left out of these groups because they
// mesh with the racks by design.
include <plug_mount.scad>

module fixed_world() {
    for (i = [0, 1]) { port_tower_world(i); bulkhead_world(i); }
    color("Tan") x_base();
    x_servo_world();
}

module moving_world(x_pos, y_pos) {
    color("LightGreen") x_carriage_world(x_pos);
    y_servo_world(x_pos);
    color("Yellow") y_carriage_world(x_pos, y_pos);
    plug_mount_world(x_pos, y_pos);
}
