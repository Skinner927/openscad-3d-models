
outer = [100, 200, 210];
wall = 3;
inner = [outer.x - (2*wall), outer.y*2, outer.z - (2*wall)];

$fn = 90;

difference() {
  cube(outer, center=true);
  cube(inner, center=true);

  #translate([outer.x/-2 - wall, 0, 0])
  rotate([0, 90, 0])
    cylinder(d=4.25, h=wall*3);


  #translate([outer.x/2, 0, 0])
  rotate([0, 90, 0])
    cylinder(d=15, h=wall*3, center=true);
}
