h = 35;
d = 5;

o1= 29.5;
o2 = 26.3;


for(i = [2, -2]) {
  translate([o1/i, 0, 0]) cylinder(h=h, d=d, center=true);
}

translate([0, 19, 0])
  for(i = [2, -2]) {
    translate([o2/i, 0, 0]) cylinder(h=h, d=d, center=true);
  }

translate([0, 9.5, h/-2 - 1])
cube([35, 25, 3], center=true);
