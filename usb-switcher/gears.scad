include <lib/BOSL/constants.scad>
use <lib/BOSL/involute_gears.scad>
use <lib/BOSL/shapes.scad>
use <lib/BOSL/transforms.scad>
use <lib/bearing.scad>
include <variables.scad>

// All models are oriented that +Y is "North" towards the USB devices.
// This is because the gears are oriented that way.

model = "sun";

// toggle manually
detailed_debug = $preview && false;

if ("usb" == model) {
  gear_usb();
} else if ("planet" == model) {
  gear_planet();
} else if ("sun" == model) {
  gear_sun(with_legs=true);

  if (detailed_debug) {
    // just a placeholder bearing
    bearing(pos=[0, 0, load_arm_gap_height], model=608);
  }
} else {
  assert(false, "Invalid 'model' variable");
}


module gear_standard(with_bearing=false, h=gear_thickness) {
  difference() {
    translate([0, 0, h/2])
      gear(mm_per_tooth=gear_mm_per_tooth, number_of_teeth=gear_teeth, thickness=h, hole_diameter=0);
    if (with_bearing) {
      // Create bearing recess only from top of bearing in case extra height is given
      translate([0, 0, h - bearing608_width])
        cylinder(h = h, d = bearing608_outside_d + bearing_fudge, center=false);
    }
  }

}
// outer radius includes teeth
gear_standard_outer_radius = outer_radius(mm_per_tooth=gear_mm_per_tooth, number_of_teeth=gear_teeth);
// root radius is without teeth
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

module gear_sun(with_legs = true) {
  // How far off center to shift the gear for stepper alignment
  table_shift = ((sun_table_width - (gear_standard_outer_radius*2))/-2) + 0.1;

  leg_x = (sun_table_width - sun_table_leg_width) / 2;
  leg_y = (sun_table_width - sun_table_leg_width) / 2;
  leg_z = (sun_table_thickness / -2) + 0.01;

  union() {
    // Build table and gear
    difference() {
      union() {
        // This gear is a little taller than normal so there's space between where
        // the teeth mesh and the "table top". Originally I had a spacer, but
        // making a longer gear means no need for supports.
        gear_standard(with_bearing=true, h=gear_sun_thickness);

        // Table top
        translate([table_shift, 0, sun_table_thickness/-2])
        cuboid([sun_table_width, sun_table_width,  sun_table_thickness],
                fillet=sun_table_filet, align=V_CENTER, edges=EDGES_ALL);
      }

      // Hole through gear center and table
      translate([0, 0, 0])
        cylinder(d=bearing608_outside_ridge_d, h=(gear_sun_thickness+sun_table_thickness)*3, center=true);

      // Servo mounts (threaded inserts)
      translate([-stepper_shaft_center_offset, 0, -sun_table_thickness - 0.01])
      for (i=[0,1]) {
        insert_true_od = stepper_knurled_insert_od + (stepper_knurled_insert_wall*2);
        insert_true_h = stepper_knurled_insert_length + stepper_knurled_insert_wall;

        rotate([0, 0, i * 180])
          translate([0, stepper_mount_distance/2, 0])
          cylinder(d=stepper_knurled_insert_od, h=stepper_knurled_insert_length);
      }

      if (!with_legs) {
        // Screw holes for legs
        translate([table_shift, 0, 0])
        for (i = [0:3]) {
          xm = i>1 ? 1 : -1;
          ym = i%2 ? 1 : -1;

          translate([xm*leg_x, ym*leg_y, -sun_table_thickness - m2_head_depth + 0.5])
          union() {
            // screw hole
            translate([0, 0, -1])
              cylinder(h=sun_table_thickness+2, d=2);

            // screw head
            translate([0, 0, sun_table_thickness])
              cylinder(h=m2_head_depth+1, d=m2_head_diameter);

            // square for attaching legs
            stlb = sun_table_leg_block * 1.1; // fudge
            translate([0, 0, (sun_table_leg_block/2) - 1])
              cube([stlb, stlb, sun_table_leg_block+2], center=true);
          }
        }
      }
    }

    // Add legs to table
    if (with_legs) {
      translate([table_shift, 0, sun_table_thickness/-2])
      for (i = [0:3]) {
        xm = i>1 ? 1 : -1;
        ym = i%2 ? 1 : -1;
        foot_rot = i>1 ? 0: 180;

        translate([xm*leg_x, ym*leg_y, leg_z])
          rotate([0, 0, foot_rot])
          gear_sun_table_leg();
      }
    }
  }
}

module gear_sun_table_leg(
  width=sun_table_leg_width, height=sun_table_leg_height,
  fillet=sun_table_filet, screw_hole_d=3.3, screw_edge=2, screw_head_d=5.3,
  screw_head_tapered=true, screw_head_depth=1, screw_min_offset=4
) {
  // Makes a single leg for the sun gear's "table".
  // Screw is #4 x 1/2" with a tapered head

  union() {
    // leg (+1 to overlap filets from table top)
    translate([0, 0, 1])
      cuboid([width, width, height + 1], fillet=fillet, align=V_BOTTOM, edges=EDGES_ALL - EDGES_BOTTOM - EDGES_TOP);

    // foot
    foot_height = screw_min_offset + screw_head_depth;
    foot_length = (screw_edge*2) + max(screw_hole_d, screw_head_d);
    translate([0, 0, -height + foot_height])
      difference() {
        // full foot
        hull() {
          cuboid([width, width, foot_height], fillet=fillet, align=V_BOTTOM, edges=EDGES_ALL - EDGES_BOTTOM - EDGES_RIGHT);
          translate([(width + foot_length)/2, 0, 0])
            cuboid([foot_length, foot_length, foot_height], fillet=fillet, align=V_BOTTOM, edges=EDGES_ALL - EDGES_BOTTOM - EDGES_LEFT);
        }

        trans_x_to_center_foot = (width + foot_length)/2;
        // Bore for screw threads
        translate([trans_x_to_center_foot, 0, foot_height/-2])
          cylinder(d=screw_hole_d, h=foot_height*2, center=true);

        // Bore for recessed screw head
        translate([trans_x_to_center_foot, 0, -screw_head_depth])
          cylinder(
            d2=screw_head_d,
            d1=screw_head_tapered ? screw_hole_d : screw_head_d,
            h=screw_head_depth + 0.01, center=false
          );
      }
  }
}
