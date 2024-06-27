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
  shaft_sun_stepper2arm();

  if (preview_bearings) {
    bz = shaft_sun_stepper2arm_h - bearing608_width - gear_bearing_floor_thickness - load_arm_gap_height;
    bearing(pos=[0, 0, bz]);
  }
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
      collar_h = stepper_shaft_cut_length/2;
      translate([0, 0, -collar_h + stepper_shaft_cut_length])
        cylinder(d1=d, d2=bearing608_bore_flange_d + 2, h=collar_h);

      // Pin for mounting
      translate([0, 0, h - 0.001])
        bearing_shaft_connector(male=true);
    }

    // Some extra for tolerances
    translate([0, 0, -0.01])
    stepper_shaft_tool(h=stepper_shaft_cut_length*1.2);
  }


}