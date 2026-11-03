// The male stage's Z adjust screw must stay reachable from above with
// the flexure, straps and clamp fitted.
include <../plug_mount.scad>

o = ms_origin(0, 0);
intersection() {
    translate([o[0] + xs_xc + zs_screw_x, o[1] + zs_screw_y, o[2] + stage_top_z]) cylinder(d = 5, h = 120);
    plug_mount_world(0, 0);
}
