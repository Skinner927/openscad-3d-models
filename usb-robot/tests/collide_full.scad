// Whole machine: everything riding the carriage must clear both port
// towers, both bulkheads and the fixed X axis, retracted across the full
// X sweep and plugged in at each port.
include <../assembly_lib.scad>

poses = concat([for (x = [x_pos_min, 0, port_spacing / 2, port_spacing, x_pos_max]) [x, 0]],
               [[port_x[0], y_travel], [port_x[1], y_travel]]);
for (p = poses)
    intersection() {
        moving_world(p[0], p[1]);
        fixed_world();
    }
