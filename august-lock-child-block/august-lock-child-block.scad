include <BOSL2/std.scad>

$fn = $preview ? 32 : 90;
$slop = 0.35;
ff = 0.01;

guard_len = 61+6+2;
wall = 3;

insert_d = 4.8;
insert_h = 4.1;

od = 67 + wall + 2;
back = 2;
arm_hole_offset = 2;
extension = od/2 + arm_hole_offset;

outside_edges = [BACK+RIGHT, BACK+LEFT, FRONT+RIGHT, FRONT+LEFT];


function cover(cd, rr=2) = union(circle(d=cd), rect([cd, cd/2], anchor=FRONT, rounding=[rr, rr, 0, 0]));

part_top = false; // true/false

diff() {
  linear_sweep(cover(od), guard_len+back) {
    tag("remove")
      attach(BOT, BOT, align=BACK, inside=true, overlap=-back, shiftout=ff)
        linear_sweep(cover(od - 2*wall, rr=0), guard_len-wall);

    // square hole for deadbolt screws and such
    tag("remove")
      attach(BOT, BOT, inside=true, shiftout=ff)
      cuboid([45, 54-20, back+1], rounding=3, edges=outside_edges);

    // window in front for deadbolt screws
    *tag("remove")
      attach(TOP, BOT, overlap=wall+1)
      cuboid([45, 20, wall+2], rounding=3, edges=outside_edges);

    // hole for arms for lock to latch to deadbolt plate
    tag("remove")
      move([0, 1, back])
      attach(BOT, BOT, align=BACK, inside=true)
      cuboid([od+4, od/2 + arm_hole_offset + 1, 8], rounding=1, edges=outside_edges);


    // Mount/Bolt holes
    attach([LEFT+FRONT, RIGHT+FRONT], RIGHT, align=BOT)
    tag_diff("mount", "adios")
      cuboid([insert_d+2, insert_d+2, 12.25], rounding=3, edges=[BACK+LEFT, FRONT+LEFT, TOP]) {
        tag("round")
          attach(LEFT, LEFT, inside=true, overlap=1)
          cyl(d=22, h=$parent_size.z, rounding2=1);

        tag("adios")
          attach(TOP, TOP, inside=true, overlap=0.5)
          cyl(d=insert_d, h=$parent_size.z+1);
      }

    // Split the part in 2 depending on part_top
    tag("remove")
      up(part_top ? ($parent_size.z*-1.5)+insert_h : $parent_size.z/2+insert_h)
      cuboid($parent_size * 2);
  }
}
