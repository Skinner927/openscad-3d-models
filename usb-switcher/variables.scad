include <lib/BOSL/constants.scad>
use <lib/BOSL/involute_gears.scad>
$fn = 90;

// m2 machine screw
m2_head_depth = 1.5;  // more than actual
m2_head_diameter = 4; // more than actual

// Standard 608 skateboard bearing
bearing608_bore_d = 8;  // inside
bearing608_bore_flange_d = 11; // edge of inside
bearing608_outside_d = 22;
bearing608_outside_ridge_d = bearing608_outside_d - 3;
bearing608_width = 7;
bearing_fudge = 0.25; // 0.01 -> 0.5 -> 0.25

// gear common
gear_bearing_floor_thickness = 1;
gear_mm_per_tooth = 5;
gear_teeth = 18; // seemed like the smallest even number that fit the bearing
gear_thickness = gear_bearing_floor_thickness + bearing608_width;

// load shaft (holds all the gears)
load_shaft_arm_gap_height = 1.5;

// USB gear shaft
shaft_usb_pin_d = bearing608_bore_d - bearing_fudge;
shaft_usb_pin_slot_x = shaft_usb_pin_d;
shaft_usb_pin_slot_y = shaft_usb_pin_d / 2;
shaft_usb_length_from_bearing_top = gear_bearing_floor_thickness + bearing608_width + load_shaft_arm_gap_height;

module shaft_usb_pin_tool(h=gear_thickness, center=false) {
  tz = center ? 0 : h/2;
  translate([0, 0, tz])
  rotate([0, 0, 90])
  intersection() {
    cylinder(h = h, d=shaft_usb_pin_slot_x, center=true);
    cube([shaft_usb_pin_slot_x, shaft_usb_pin_slot_y, h], center=true);
  }
}

// stepper 28BYJ-48 datasheet for dimensions
// https://components101.com/sites/default/files/component_datasheet/28byj48-step-motor-datasheet.pdf
stepper_shaft_diameter = 5;
stepper_shaft_width = 3;
stepper_shaft_cut_length = 6;
stepper_body_to_shaft_tip = 10;
stepper_shaft_center_offset = 8;  // center of shaft is this far off body center
stepper_mount_distance = 35;  // distance between centers of mounting holes
stepper_body_height = 20;

module stepper_shaft_tool(h=stepper_shaft_cut_length, multiplier=1, center=false) {
  h = h * multiplier;
  tz = center ? 0 : h/2;
  translate([0, 0, tz])
  intersection() {
    cylinder(h = h, d=stepper_shaft_diameter, center=true);
    cube([stepper_shaft_diameter, stepper_shaft_width, h], center=true);
  }
}

// Using M4 x 5mm thread with a M4 x 4mm(l) x 6(od) knurled insert
// for motor mount.
stepper_knurled_insert_od = 6;
stepper_knurled_insert_length = 6;  // actually 4 but screw is 5 and +1 for melted plastic
stepper_knurled_insert_wall = 1;

gear_sun_thickness = gear_thickness + load_shaft_arm_gap_height;

sun_table_thickness = max(stepper_body_to_shaft_tip,
  (stepper_knurled_insert_length + stepper_knurled_insert_wall));
sun_table_leg_width = 8;
sun_table_leg_height = stepper_body_height + 3; // arbitrary +3
sun_table_width = (stepper_mount_distance + stepper_knurled_insert_od
  + (stepper_knurled_insert_wall*2) + 2);
sun_table_filet = 0.8;
