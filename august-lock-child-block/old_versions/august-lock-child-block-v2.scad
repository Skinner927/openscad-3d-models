include <BOSL2/std.scad>

$fn = $preview ? 32 : 90;
$slop = 0.35;
ff = 0.01;

guard_len = 61+6;
wall = 3;

od = 67 + wall;
back = 2;
arm_hole_offset = 2;
extension = od/2 + arm_hole_offset;

function cover(cd, rr=2) = union(circle(d=cd), rect([cd, cd/2], anchor=FRONT, rounding=[rr, rr, 0, 0]));

diff() {
  linear_sweep(cover(od), guard_len+back) {
    tag("remove")
      attach(BOT, BOT, align=BACK, inside=true, overlap=-back, shiftout=ff)
        linear_sweep(cover(od - 2*wall, rr=0), guard_len-wall);

    // square hole for deadbolt screws and such
    tag("remove")
      attach(BOT, BOT, inside=true, shiftout=ff)
      cuboid([45, 54-20, back+1], rounding=3,
        edges=[BACK+RIGHT, BACK+LEFT, FRONT+RIGHT, FRONT+LEFT]);

    // window in front for deadbolt screws
    tag("remove")
      attach(TOP, BOT, overlap=wall+1)
      cuboid([45, 20, wall+2], rounding=3, edges=[BACK+RIGHT, BACK+LEFT, FRONT+RIGHT, FRONT+LEFT]);

    // hole for arms for lock to latch to deadbolt plate
    tag("remove")
      move([0, -arm_hole_offset, back])
      attach(BOT, BOT, align=BACK, inside=true)
      cuboid([od+4, od/2, 8], rounding=1);
  }
}
