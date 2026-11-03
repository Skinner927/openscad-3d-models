// ============================================================
//  Tub Drain Strainer
//  Drop-in basket for a tub drain with no cover.
//  Print upright (floor on the bed, pin pointing up). No supports:
//  the flange underside and pin knob use 45-degree chamfers.
// ============================================================

/* [Drain] */
// Measured drain bore diameter
drain_dia      = 40.40;
// Radial gap between basket wall and drain bore (per side)
fit_clearance  = 0.30;

/* [Basket] */
// Depth of the basket below the tub surface
basket_depth   = 15.0;
// Basket side wall thickness
wall_t         = 1.6;
// Basket floor thickness
floor_t        = 1.6;

/* [Flange (rests on the tub)] */
// Width of the lip that sits on the tub surface, past the drain edge
flange_overhang = 5.0;
// Flange thickness
flange_t       = 1.6;

/* [Drain Holes] */
// Floor hole diameter
hole_dia       = 2.6;
// Center-to-center spacing between floor holes
hole_pitch     = 4.4;
// Side slot width
slot_w         = 2.0;
// Number of side slots around the wall
slot_count     = 24;

/* [Pull Pin] */
// Pin shaft diameter
pin_dia        = 5.0;
// How far the pin top sits above the flange top
pin_above_flange = 12.0;
// Knob diameter at the top of the pin
knob_dia       = 10.0;
// Knob straight-section height
knob_h         = 3.0;

$fn = 180;

// ============================================================
//  Derived values
// ============================================================
basket_od   = drain_dia - 2 * fit_clearance;
basket_id   = basket_od - 2 * wall_t;
flange_od   = drain_dia + 2 * flange_overhang;
total_h     = basket_depth + flange_t;          // floor bottom to flange top
pin_top_z   = total_h + pin_above_flange;
knob_chamf  = (knob_dia - pin_dia) / 2;         // 45-degree underside
flange_chamf = (flange_od - basket_od) / 2;     // 45-degree underside
// Keep floor holes clear of the wall and the pin
hole_r_min  = pin_dia / 2 + hole_dia / 2 + 1.2;
hole_r_max  = basket_id / 2 - hole_dia / 2 - 0.8;
// Side slots run from just above the floor to below the flange chamfer
slot_z0     = floor_t + 1.0;
slot_z1     = total_h - flange_t - min(flange_chamf, basket_depth / 2) - 1.0;

// ============================================================
//  Model
// ============================================================
tub_drain_strainer();

module tub_drain_strainer() {
    difference() {
        union() {
            basket_shell();
            flange();
        }
        floor_holes();
        side_slots();
    }
    pull_pin();
}

module basket_shell() {
    difference() {
        cylinder(d = basket_od, h = total_h);
        translate([0, 0, floor_t]) cylinder(d = basket_id, h = total_h);
    }
}

// Lip that rests on the tub; underside chamfered 45 deg for support-free printing
module flange() {
    ch = min(flange_chamf, basket_depth / 2);
    difference() {
        union() {
            translate([0, 0, total_h - flange_t])
                cylinder(d = flange_od, h = flange_t);
            translate([0, 0, total_h - flange_t - ch])
                cylinder(d1 = flange_od - 2 * ch, d2 = flange_od, h = ch);
        }
        translate([0, 0, -1]) cylinder(d = basket_id, h = total_h + 2);
    }
}

// Hex-packed grid of round holes in the floor
module floor_holes() {
    n = ceil(hole_r_max / hole_pitch) + 1;
    row_h = hole_pitch * sqrt(3) / 2;
    for (j = [-n * 2 : n * 2], i = [-n : n]) {
        x = i * hole_pitch + (abs(j) % 2) * hole_pitch / 2;
        y = j * row_h;
        r = sqrt(x * x + y * y);
        if (r >= hole_r_min && r <= hole_r_max)
            translate([x, y, -1]) cylinder(d = hole_dia, h = floor_t + 2, $fn = 24);
    }
}

// Vertical slots through the basket wall
module side_slots() {
    for (k = [0 : slot_count - 1])
        rotate([0, 0, k * 360 / slot_count])
            translate([basket_od / 2 - wall_t - 1, -slot_w / 2, slot_z0])
                cube([wall_t + 2, slot_w, slot_z1 - slot_z0]);
}

// Center pin with a grip knob to pull the strainer out
module pull_pin() {
    // Fillet cone at the floor for strength
    translate([0, 0, floor_t - 0.01])
        cylinder(d1 = pin_dia + 4, d2 = pin_dia, h = 2);
    cylinder(d = pin_dia, h = pin_top_z - knob_h);
    // Knob: 45-degree underside, then straight, then small top chamfer
    translate([0, 0, pin_top_z - knob_h - knob_chamf])
        cylinder(d1 = pin_dia, d2 = knob_dia, h = knob_chamf);
    translate([0, 0, pin_top_z - knob_h])
        cylinder(d = knob_dia, h = knob_h - 0.8);
    translate([0, 0, pin_top_z - 0.8])
        cylinder(d1 = knob_dia, d2 = knob_dia - 1.6, h = 0.8);
}
