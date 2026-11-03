// ============================================================
//  Toy Car Wheel Drill Adapter
//  Initial design by Claude, refined by a human.
//
//  5 pins slot into the gaps between a 5-spoke toy car wheel.
//  Pins are joined to a central hub by arms (wagon-wheel style),
//  and a single shaft off the hub goes into a drill chuck.
// ============================================================

/* [Pins] */
pin_count    = 5;
// Pin diameter
pin_dia      = 3.0;
// Pin length (below the arms)
pin_length   = 4.0;
// Pin center to hub center
pin_radius   = 6.0;

/* [Hub + Arms] */
// Central hub diameter
hub_dia      = 11;
// Arm width
arm_width    = 3.0;
// Thickness of the hub/arm layer
arm_thick    = 3.0;

/* [Shaft] */
// Shaft diameter (goes in the drill chuck)
shaft_dia    = 8.0;
// Shaft length (above the hub)
shaft_length = 15.0;
// Fillet cone where the shaft meets the hub
shaft_fillet = 1.5;

/* [Hidden] */
$fn = 64;

// ============================================================
//  MODULE: arms
//  Hub disc plus one arm out to each pin, rounded at the pin end
// ============================================================
module arms() {
    cylinder(d = hub_dia, h = arm_thick);
    for (i = [0 : pin_count - 1])
        rotate([0, 0, i * 360 / pin_count])
            hull() {
                cylinder(d = arm_width, h = arm_thick);
                translate([pin_radius, 0, 0])
                    cylinder(d = max(arm_width, pin_dia), h = arm_thick);
            }
}

// ============================================================
//  MODULE: pins
//  Hang down from the arms into the gaps between the spokes
// ============================================================
module pins() {
    for (i = [0 : pin_count - 1])
        rotate([0, 0, i * 360 / pin_count])
            translate([pin_radius, 0, -pin_length])
                cylinder(d = pin_dia, h = pin_length + 0.01);
}

// ============================================================
//  MODULE: shaft
//  Drill chuck shaft with a small fillet into the hub
// ============================================================
module shaft() {
    translate([0, 0, arm_thick - 0.01]) {
        cylinder(d = shaft_dia, h = shaft_length + 0.01);
        cylinder(d1 = shaft_dia + 2 * shaft_fillet, d2 = shaft_dia, h = shaft_fillet);
    }
}

// ============================================================
//  ASSEMBLY
// ============================================================
union() {
    arms();
    pins();
    shaft();
}
