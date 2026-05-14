// ============================================================
//  Sliding Door Track Lock
//  Initial design by Claude, refined by a human.
// ============================================================

/* [Main Dimensions] */
// Along the track
body_length    = 50.8;
// Overall front-to-back
body_width     = 24.0;
// Height of upper block (above channel legs)
body_height    = 12.7;

/* [U-Channel] */
// channel opening width
slot_width     = 6.0;
// channel depth (leg height)
slot_depth     = 10.0;

/* [Wall thicknesses — asymmetric] */
// screw side ~ back_wall_t is derived: body_width - slot_width - front_wall_t
front_wall_t   = 7.0;
// back_wall_t is derived: body_width - slot_width - front_wall_t = 11mm

// M3 hex nut: 5.5mm across-flats, 2.4mm thick
/* [Bolt + Nut sizing] */
// clearance hole M3=3.4 M4=4.8
bolt_dia       = 3.4;    // mm — M3 clearance hole (slightly oversized)
// across flats M3=5.5 M4=7.0
nut_af         = 5.5;    // mm — across flats
// recess depth M3=3.0 M4=4.0
nut_depth      = 3.0;    // mm — recess depth (slightly over nut thickness for easy seating)

/* [Bolt Positioning] */
bolt_count     = 2;
// center-to-center along length
bolt_spacing   = 22.0;
// Move bolts up or down
bolt_vert_offset = 4;
bolt_height    = slot_depth / 2 + bolt_vert_offset;  // mm — vertical center in the channel leg
// degrees — tilt from horizontal, head-end downward
bolt_angle     = 25;

/* [Chamfer] */
c = 1.2;

// ============================================================
//  Derived values
// ============================================================
back_wall_t  = body_width - slot_width - front_wall_t;  // = 11mm

bolt_x_start = (body_length - bolt_spacing) / 2;

// ============================================================
//  MODULE: hex_recess
//  Hexagonal nut pocket, oriented for a flat-to-flat insertion.
//  Placed on the INNER face of the front channel wall so the
//  nut can be pressed/melted in with a soldering iron.
// ============================================================
module hex_recess(depth) {
    // 6-sided polygon extruded — flat side up/down for best print orientation
    rotate([0, 0, 0])   // orient flat face toward channel opening
        cylinder(d = nut_af / cos(30), h = depth, $fn = 6);
}

// ============================================================
//  MODULE: main_body
//  Solid upper block with chamfered top edges
// ============================================================
module main_body() {
    hull() {
        // Bottom of body (full footprint at channel top)
        translate([0, 0, slot_depth])
            cube([body_length, body_width, 0.01]);
        // Top, chamfered inward
        translate([c, c, slot_depth + body_height - c])
            cube([body_length - 2*c, body_width - 2*c, c]);
        // Sides, chamfered only at top
        translate([0, 0, slot_depth])
            cube([body_length, body_width, body_height - c]);
    }
}

// ============================================================
//  MODULE: channel_walls
//  The two legs of the inverted U-channel
// ============================================================
module channel_walls() {
    // Front wall — screw side, 7mm thick
    cube([body_length, front_wall_t, slot_depth]);
    // Back wall — solid, 11mm thick (extra material since channel narrowed)
    translate([0, body_width - back_wall_t, 0])
        cube([body_length, back_wall_t, slot_depth]);
}

// ============================================================
//  MODULE: bolt_holes_and_nut_recesses
//  Subtracted from the assembly:
//    - Clearance bore through the front wall at bolt_angle
//      (head-end tilted downward for overhead installation)
//    - Hex nut recess at the inner face, aligned to bolt axis
//
//  Geometry: origin is placed at the outer face of the front
//  wall. rotate([-90 + bolt_angle, 0, 0]) tilts the bore so
//  the entry (head) end is lower and the nut end is higher —
//  natural driving angle when the part is above your head.
//
//  Bore length along axis = front_wall_t / cos(bolt_angle)
//  Nut Z-rise through wall = front_wall_t * tan(bolt_angle)
// ============================================================
module bolt_holes_and_nut_recesses() {
    // Length along the angled axis to fully traverse the front wall
    bore_len = front_wall_t / cos(-bolt_angle) + 2;  // +2 for clean boolean overrun

    for (i = [0 : bolt_count - 1]) {
        x = bolt_x_start + i * bolt_spacing;

        translate([x, 0, bolt_height])
            rotate([-90 + -bolt_angle, 0, 0]) {
                // Clearance bore — starts 1mm before outer face, exits inner face
                translate([0, 0, -2])
                    cylinder(d = bolt_dia, h = bore_len + 1, $fn = 32);

                // Hex nut recess — pocket from inner face back into wall
                translate([0, 0, front_wall_t / cos(-bolt_angle) - nut_depth])
                    hex_recess(nut_depth + 2); // +2 for clean boolean overrun
            }
    }
}

// ============================================================
//  ASSEMBLY
// ============================================================
rotate([180, 0, 0])
difference() {
    union() {
        main_body();
        channel_walls();
    }
    bolt_holes_and_nut_recesses();
}
