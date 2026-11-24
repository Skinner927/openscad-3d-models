// The male stage's base (plate, dovetail rail, X adjust tab) is built into
// the Y carriage: no separate base, no bolts. Everything a solid stage base
// would fill on top of the carriage, and the carriage body where the old
// bolt holes went, must be solid Y carriage. Must render empty.
include <../axes.scad>
difference() {
  union() {
    translate([0, 0, yc_top]) stage_base(mount_holes = false);
    for (p = stage_mount_pts) translate([p[0], p[1], yc_z0 + 0.5]) cylinder(d = 3, h = yc_h - 1);
  }
  y_carriage();
}
