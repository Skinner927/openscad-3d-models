eye_w = 3;
eye_h = 5;
wall = 1.5;

tip = 10;
width = eye_w + (wall*2);
height = 80;
depth = 2.5;


$fn = 64;

difference() {
  union() {
    // body
    translate([width/-2, 0, depth/-2])
    cube([width, height - tip, depth]);

    // tip
    translate([0, height - tip - 0.01, 0])
      linear_extrude(height = depth, center=true)
      projection()
      intersection() {
        translate([0, 0, 0])
          rotate([-90, 0, 0])
          cylinder(h=tip, d1=width + 1, d2=0.25);

        translate([width/-2, 0, depth/-2])
          cube([width, height, depth]);
      }
  }

  // eye
  translate([0, (eye_h/2) + wall, 0])
    cube([eye_w, eye_h, depth*2], center=true);
}
