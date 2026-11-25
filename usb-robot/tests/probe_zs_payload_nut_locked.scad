// The payload nuts (port bracket / flexure bolts) must not spin: a real M3
// nut (5.4 AF, measured) turned 8 deg in each payload nut slot, swept down
// through the slot's open bottom, must hit the slot walls.
// Must render NON-empty.
include <../stage.scad>
af = 5.4;
module swept(p) hull() for (dz = [0, -zs_h])
  translate([xs_xc + p[0], payload_face_y - 4, stage_payload_z + p[1] + dz]) rotate([90, 0, 0]) rotate([0, 0, 90 + 8])
    cylinder(d = af / cos(30), h = 2.4, center = true, $fn = 6);
// both slots must grip: intersect slot A's hits with slot B's hits moved onto A
intersection() {
  intersection() { stage_z_slider(); swept(payload_pts[0]); }
  translate([payload_pts[0][0] - payload_pts[1][0], 0, payload_pts[0][1] - payload_pts[1][1]])
    intersection() { stage_z_slider(); swept(payload_pts[1]); }
}
