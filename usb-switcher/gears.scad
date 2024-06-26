include <lib/BOSL/constants.scad>
use <lib/BOSL/involute_gears.scad>
use <lib/BOSL/shapes.scad>
use <lib/BOSL/transforms.scad>
include <variables.scad>

// note for later about gear spacing:
// :  two gears should have their centers separated by the sum of their pitch_radius.

// All models are oriented that +Y is "North" towards the USB devices.
// This is because the gears are oriented that way.

model="sun";

if ("usb" == model) {
  gear_usb();
} else if ("planet" == model) {
  gear_planet();
} else if ("sun" == model) {
  gear_sun();
} else {
  assert(false, "Invalid 'model' variable");
}


module gear_standard(with_bearing=false, h=gear_thickness) {
  difference() {
    translate([0, 0, h/2])
      gear(mm_per_tooth=gear_mm_per_tooth, number_of_teeth=gear_teeth, thickness=h, hole_diameter=0);
    if (with_bearing) {
      translate([0, 0, gear_bearing_floor_thickness])
        cylinder(h = h, d = bearing608_outside_d + bearing_fudge, center=false);
    }
  }

}
gear_standard_outer_radius = outer_radius(mm_per_tooth=gear_mm_per_tooth, number_of_teeth=gear_teeth);
gear_standard_root_radius = root_radius(mm_per_tooth=gear_mm_per_tooth, number_of_teeth=gear_teeth);

module gear_usb() {
  screw_length = 10;
  screw_head_depth = m2_head_depth;
  screw_head_diameter = m2_head_diameter;

  // Ensure screw head does not poke out of gear and interfere with teeth
  assert((screw_length + screw_head_depth) < (2*gear_standard_root_radius),
    "Screw head will interfere with gear teeth");

  difference() {
    gear_standard();

    // Set screw (regular m2 machine screw)
    // Set so it will bottom out at 0,0
    translate([0, 0, gear_thickness/2])
      rotate([0, 90, 0])
      union() {
          cylinder(h = screw_length + 0.01, d=2);
          translate([0, 0, screw_length])
            // Use outer radius to clear through gear
            cylinder(h=gear_standard_outer_radius, d=screw_head_diameter);
      }

    shaft_usb_pin_tool(h=gear_thickness*3, center=true);

    // temporary cut through whole gear
    //cylinder(h = gear_thickness*1.5, r=gear_standard_root_radius, center=true);
  }
}

module gear_planet() {
  difference() {
    gear_standard(with_bearing=true);
    // ledge for bearing
    cylinder(h = gear_thickness, d = bearing608_outside_ridge_d, center=true);
  }
}


module servo_screw_insert(d=6, h=6, edge=1, align_top=true) {
  _single_servo_screw_insert(d=d, h=h, edge=edge, align_top=align_top);
  rotate([0, 0, 180])
    _single_servo_screw_insert(d=d, h=h, edge=edge, align_top=align_top);
}

module _single_servo_screw_insert(d=6, h=6, edge=1, align_top=true) {
  translate([0, stepper_sun_mount_distance/2, align_top ? -(h+edge) : 0])
    difference() {
      cylinder(d=d+(edge*2), h=h+edge, center=false);
      translate([0, 0, -0.01])
        cylinder(d=d, h=h+0.02, center=false);
    }
}

module gear_sun() {
  box_xy = stepper_sun_mount_distance + 4;
  box_h = 3;
  box_filet = 0.4;

  difference() {
    union() {
      // This gear is a little taller than normal so there's space between where
      // the teeth mesh and the "table top". Originally I had a spacer, but
      // I think making a longer gear will make for an easier print?
      translate([0, 0, -load_shaft_arm_gap_height]) {
        gear_standard(with_bearing=true, h=gear_thickness + load_shaft_arm_gap_height);
        // Threaded insert mount for servo. M4 x 5mm. 4mm knurled insert.
        servo_screw_insert();
      }

      // flat surface for servo to mount to
      translate([0, 0, -(load_shaft_arm_gap_height + (box_h/2))])
        union() {
          // flat surface
          cuboid([box_xy, box_xy,  box_h],
            fillet=box_filet, align=V_CENTER, edges=EDGES_ALL);

          leg_size = 5;
          leg_x = box_xy/2 - (leg_size/2);
          leg_y = box_xy/2 - (leg_size/2);
          leg_z = (box_h/-2)+0.01;
          leg_height = stepper_sun_height + 5; // +5 for screw mounts

          foot_screw_d = 4;
          foot_screw_head_d = 9;
          foot_screw_head_depth = 5;
          foot_screw_padding = 1;
          foot_screw_height = foot_screw_head_depth+2;
          foot_screw_width = foot_screw_head_d +(foot_screw_padding*2);
          foot_long_side = foot_screw_width + leg_size + foot_screw_padding;

          for (i = [0:3]){
            xm = i>1 ? 1 : -1;
            ym = i%2 ? 1 : -1;
            foot_rot = i>1 ? 0: 180;

            translate([xm*leg_x, ym*leg_y, leg_z])
            rotate([0, 0, foot_rot])
            union() {
              // leg (+1 to overlap filets from table top)
              translate([0, 0, 1])
                cuboid([leg_size, leg_size, leg_height], fillet=box_filet, align=V_BOTTOM, edges=EDGES_ALL - EDGES_BOTTOM - EDGES_TOP);

              // completed foot
              translate([(foot_long_side/2)-(leg_size/2), 0, -(leg_height)-0.01])
              difference() {
                // foot
                rounded_prismoid(size1=[foot_long_side,foot_screw_width], size2=[leg_size,leg_size], h=foot_screw_height, shift=[-((foot_long_side/2)-(leg_size/2)),0], r=box_filet);

                // Hole for screw
                translate([0, 0, 3])
                rotate([0, 30, 0])
                union() {
                  cylinder(h=foot_screw_head_depth, d=foot_screw_head_d, center=false);
                  cylinder(h=foot_screw_height*2, d=foot_screw_d, center=true);
                }
              }
            }
          }
        }


      // translate([0, 0, -(load_shaft_arm_gap_height + ((box_h + stepper_sun_height)/2))])
      // difference() {
      //   cuboid([box_xy, box_xy,  box_h + stepper_sun_height],
      //     fillet=0.4, align=V_CENTER, edges=EDGES_ALL - EDGES_BOTTOM);

      //   cube([box_xy*2, 2, stepper_sun_height], center=true);
      // }
    }
    // Hole for load shaft through bearing. +2 for extra clearance.
    cylinder(h = gear_thickness*3, d = bearing608_bore_flange_d + 2, center=true);
  }
}
