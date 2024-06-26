include <lib/BOSL/constants.scad>
use <lib/BOSL/involute_gears.scad>
include <variables.scad>

$fn = 90;

shaft_d = bearing608_outside_d;
teeth = 18;
mm_per_tooth=5;
bearing_floor_thickness = 1;
gear_thickness = bearing608_width + bearing_floor_thickness;


union() {
  translate([0, 0, gear_thickness/2])
    gear(mm_per_tooth=mm_per_tooth, number_of_teeth=teeth, thickness=gear_thickness, hole_diameter=shaft_d);

  difference() {
    cylinder(h = bearing_floor_thickness, d = bearing608_outside_d + 0.5, center=false);
    cylinder(h = bearing_floor_thickness*3, d = bearing608_outside_d - 3, center=true);
  }
}
