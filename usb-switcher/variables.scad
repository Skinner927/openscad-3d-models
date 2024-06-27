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

// stepper datasheet for dimensions
// https://components101.com/sites/default/files/component_datasheet/28byj48-step-motor-datasheet.pdf
stepper_sun_shaft_pin_x = 3;
stepper_sun_shaft_pin_y = 5;
stepper_sun_shaft_pin_z = 6+2;
stepper_sun_shaft_to_body = 10;  // from tip of shaft to mounting tangs
stepper_sun_riser_z = 5; // how far off the plane to mount. Shaft has a collar.
stepper_sun_mount_distance = 35;
stepper_sun_shaft_offset_center = 8;
stepper_sun_height = 20;

// Using M4 x 5mm thread with a M4 x 4mm(l) x 6(od) knurled insert
// for motor mount.
stepper_knurled_insert_od = 6;
stepper_knurled_insert_length = 6;  // actually 4 but screw is 5 and +1 for melted plastic
stepper_knurled_insert_wall = 1;

gear_sun_thickness = gear_thickness + load_shaft_arm_gap_height;
sun_table_thickness = max(stepper_sun_shaft_to_body,
  (stepper_knurled_insert_length + stepper_knurled_insert_wall));
sun_table_leg_width = 8;
sun_table_width = (stepper_sun_mount_distance +
  (stepper_knurled_insert_od) + (stepper_knurled_insert_wall*2));
sun_table_filet = 0.4;

module stepper_sun_shaft_pin_tool(h=stepper_sun_shaft_pin_z, center=false) {
  tz = center ? 0 : h/2;
  translate([0, 0, tz])
  rotate([0, 0, 90])
  intersection() {
    cylinder(h = h, d=stepper_sun_shaft_pin_y, center=true);
    cube([shaft_usb_pin_slot_x, shaft_usb_pin_slot_y, h], center=true);
  }
}

/// ----------

load_shaft_arm_height = gear_thickness;

shaft_sun_od = bearing608_bore_d - bearing_fudge;
