include <BOSL2/std.scad>

$fn = $preview ? 32 : 90;
$slop = 0.35;
ff = 0.01;

guard_len = 61+6;
wall = 3;

diff()
cyl(h=1, d=67+wall, anchor=TOP) {
  tag_diff("tube", "yeet") {
    tag("tube")
      attach(BOT, BOT, inside=true)
      tube(h=guard_len, id=$parent_size.x-wall, od=$parent_size.x);
    tag("yeet")
      back(20)
      cube([$parent_size.x + wall, $parent_size.y + wall, guard_len], anchor=CENTER+BOT);
  }

  tag("remove")
    cuboid([45, 54-20, $parent_size.z+1], rounding=3,
      edges=[BACK+RIGHT, BACK+LEFT, FRONT+RIGHT, FRONT+LEFT]);
}
