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

// expose as it may be useful
bearing_shaft_connector_h_default = m2_head_diameter*1.5;
bearing_shaft_connector_d_default = bearing608_bore_d - bearing_fudge;

module bearing_shaft_connector(
  h=bearing_shaft_connector_h_default, d=bearing_shaft_connector_d_default,
  male=true, screw_d=1.4,
  screw_head_h=0.74, screw_head_d=2.7,
  sides=8, two_screws=false,
) {
  // Creates a male and female side of a connecting collar between two parts.
  // Uses a screw to set: M1.4 x 5
  male_d_adjust = max((screw_head_h * 2), 1);
  if (male) {
    difference() {
      cylinder(h=h, d=d - male_d_adjust, $fn=sides);

      // Screw hole goes all the way through for simplicity
      if (screw_d > 0) {
        translate([0, 0, h/2])
          rotate([0, 90, 180/sides])
          cylinder(h=d*2, d=screw_d, center=true);
      }
    }
  } else {
    difference() {
      cylinder(h=h, d=d);
      translate([0, 0, -0.5])
        bearing_shaft_connector(
          h=h+1, d=d, male=true, screw_d=0,
          screw_head_h=screw_head_h, screw_head_d=screw_head_d, sides=sides);

      if (screw_head_h > 0) {
        for(rot=(two_screws ? [0, 1] : [0])) {
          rotate([0, 0, 180 * rot])
            rotate([0, 0, 180/sides])
            translate([d/2 - screw_head_h/2 + 0.01, 0, h/2])
            rotate([0, 90, 0])
            union() {
              // Screw head
              cylinder(h=screw_head_h + 0.01, d=screw_head_d, center=true);

              // Screw threads
              translate([0, 0, d/-4 + screw_head_h/2])
                cylinder(h=d/2, d=screw_d + 0.02, center=true);
            }
        }
      }
    }
  }
}

// gear common
gear_bearing_floor_thickness = 1;
gear_mm_per_tooth = 5;
gear_teeth = 18; // seemed like the smallest even number that fit the bearing
gear_thickness = gear_bearing_floor_thickness + bearing608_width;

// load arm (holds all the gears)
load_arm_gap_height = 1.5;

// USB gear shaft
shaft_usb_pin_d = bearing608_bore_d - bearing_fudge;
shaft_usb_pin_slot_x = shaft_usb_pin_d;
shaft_usb_pin_slot_y = shaft_usb_pin_d / 2;
shaft_usb_length_from_bearing_top = gear_bearing_floor_thickness + bearing608_width + load_arm_gap_height;

// TODO: don't use this, use bearing_shaft_connector()
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
stepper_shaft_collar = stepper_body_to_shaft_tip - stepper_shaft_cut_length;
stepper_shaft_center_offset = 8;  // center of shaft is this far off body center
stepper_mount_distance = 35;  // distance between centers of mounting holes
stepper_body_height = 19;
stepper_body_d = 28;

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

gear_sun_thickness = gear_thickness + load_arm_gap_height;

sun_table_thickness = max(stepper_body_to_shaft_tip,
  (stepper_knurled_insert_length + stepper_knurled_insert_wall));
sun_table_leg_width = 8;
sun_table_leg_height = stepper_body_height + 4; // arbitrary +4
sun_table_width = (stepper_mount_distance + stepper_knurled_insert_od
  + (stepper_knurled_insert_wall*2) + 2);
sun_table_filet = 0.8;

shaft_sun_stepper2arm_d = bearing608_bore_d - bearing_fudge;
shaft_sun_stepper2arm_h = stepper_shaft_cut_length + bearing608_width
  + gear_bearing_floor_thickness + load_arm_gap_height;
