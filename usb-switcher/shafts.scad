include <lib/BOSL/constants.scad>
use <lib/BOSL/involute_gears.scad>
use <lib/BOSL/shapes.scad>
use <lib/BOSL/transforms.scad>
use <lib/bearing.scad>
include <variables.scad>

// note for later about gear spacing:
// :  two gears should have their centers separated by the sum of their pitch_radius.

model = "sun_stepper2arm";
preview_bearings = $preview && false;

if ("sun_stepper2arm" == model) {
  // rotate 180 for better
  rotate([0, $preview ? 0 : 180, 0])
    shaft_sun_stepper2arm();

  if (preview_bearings) {
    bz = shaft_sun_stepper2arm_h - bearing608_width - load_arm_gap_height;
    bearing(pos=[0, 0, bz]);
  }
} else if ("main_arm" == model) {
  main_arm();

} else {
  assert(false, "Invalid 'model' variable");
}


module shaft_sun_stepper2arm() {
  d = shaft_sun_stepper2arm_d;
  h = shaft_sun_stepper2arm_h;

  difference() {
    union() {
      cylinder(d=d, h=h);

      // Collar against bearing
      collar_h = load_arm_gap_height;
      translate([0, 0, h - collar_h])
        cylinder(d=bearing608_bore_flange_d + 2, h=collar_h);

      // Pin for mounting
      translate([0, 0, h - 0.001])
        bearing_shaft_connector(male=true);
    }

    // Slot for stepper's shaft
    translate([0, 0, -0.01])
      // Some extra depth for clearance
      stepper_shaft_tool(h=stepper_shaft_cut_length + 3);
  }
}

module main_arm() {

  union() {
    // connector
    translate([0, 0, -0.002])
      rotate([0, 0, 140])
      bearing_shaft_connector(male=false);

    // arm body
    arm_h = 4;
    arm_w = bearing608_outside_d + 4;
    arm_len = 30;
    translate([0, 0, -0.001])
    hull() {
      for (tx=[0, arm_len]) {
        translate([tx, 0, 0])
          cylinder(h=arm_h, d=arm_w);
      }
    }

  }

}
