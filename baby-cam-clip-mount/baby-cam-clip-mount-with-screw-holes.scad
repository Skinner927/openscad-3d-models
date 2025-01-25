pin_width = 11.5;  // shaft's x
pin_height = 30;   // shaft's z
pin_wall = 2;

screw_hole_d = 2;
screw_hole_l = 7.5;
screw_offset = 10;
mount_d = 20;
mount_h = screw_hole_l + 0.5;

$fn = $preview ? 64 : 128;

union() {
    // Top mount
    translate([0, 0, mount_h - 0.02])
    color("red", 1.0)
    difference() {
      translate([0, 0, mount_h/-2])
      //cube([pin_width + pin_wall, pin_width + pin_wall, mount_h], center=true);
      //cylinder(h=mount_h, d=mount_d, center=true);
      hull() {
        translate([0, 0, mount_h/-2])
          cube([pin_width + pin_wall, pin_width + pin_wall, 0.01], center=true);

        translate([0, 0, mount_h/2])
          cylinder(h=0.01, d=mount_d, center=true);
      }

      for(i = [2, -2]) {
        translate([screw_offset/i, 0, -screw_hole_l])
          cylinder(h=screw_hole_l + 1, d=screw_hole_d);
      }
    }


    // Tunnel for clip handle
    //-(pin_wall + base_wall - 0.01)
    translate([0, 0, pin_height/-2])
    difference() {
        // shaft
        cube([pin_width + pin_wall, pin_width + pin_wall, pin_height], center=true);
        // shaft extrusion (subtrusion?)
        translate([0, 0, -pin_wall])
        cube([pin_width, pin_width, pin_height], center=true);
    }
}
