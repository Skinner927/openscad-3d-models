w = 25;
h = 228;
d = 16; // height of skadis mount

hole_d = 10;

$fn = 90;

difference() {
  translate([w/-2, -h, 0])
    cube([w, h, d]);

  translate([0, -11, 0])
    cylinder(d*3, d=hole_d, center=true);

  // translate([0, -11, 0])
  // for (i = [0:5]) {
  //   translate([0, (hole_d*-2) * i, 0])
  //     cylinder(d*3, d=hole_d, center=true);
  // }

  hull() {
    translate([0, -(11+hole_d*2), 0])
      cylinder(d*3, d=hole_d, center=true);

    translate([0, -(170-hole_d*2), 0])
      cylinder(d*3, d=hole_d, center=true);
  }

  translate([(21-(w/2)), -170, 0])
    cylinder(d*3, d=hole_d, center=true);


  hull() {
    translate([0, -(170+hole_d*2), 0])
      cylinder(d*3, d=hole_d, center=true);

    translate([0, -h +11, 0])
      cylinder(d*3, d=hole_d, center=true);
  }
}
