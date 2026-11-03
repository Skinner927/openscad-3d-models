// Fit probes built only from the port position and the measured part
// sizes (not from the bracket / clamp variables), so they test the real
// geometry rather than restating its formulas.
include <../assembly_lib.scad>

// Bulkhead thread cross-section (15 mm, flat 6.5 mm from centre, on top)
// pushed through port i's plate, offset by d = [dx, dz].
module probe_port_thread(i, d) {
    translate([port_x[i] + d[0], port_face_y + plate_t + 1, port_z + d[1]]) rotate([90, 0, 0])
        linear_extrude(plate_t + 2) intersection() {
            circle(d = bh_thread_d, $fn = 96);
            translate([-bh_thread_d, -bh_thread_d]) square([2 * bh_thread_d, bh_thread_d + bh_flat]);
        }
}
module probe_port_hole(d) {
    for (i = [0, 1]) intersection() { port_tower_world(i); probe_port_thread(i, d); }
}

// Plug clamp block where it must sit for the magnetic face to meet port
// i's face: face centre at (port_x, bh_face_y, port_z).
module probe_block(i, d) {
    translate([port_x[i] - plug_bx / 2 + d[0],
               bh_face_y - plug_head_proj - plug_by + d[1],
               port_z + plug_drop + d[2]])
        cube([plug_bx, plug_by, plug_block[2]]);
}
// Seat = flexure cradle only (the cap squeezes the block on purpose).
module probe_plug_seat(d) {
    for (i = [0, 1]) intersection() {
        translate(ms_origin(port_x[i], y_travel)) stage_payload_origin() plug_flexure();
        probe_block(i, d);
    }
}
