// Smoke test: every lib.scad core module renders, side by side.
include <../../lib.scad>

dovetail_rail(30);
translate([0, 25, 0]) difference() {
    translate([0, -10, 0]) cube([30, 20, 8]);
    translate([0, 0, 8 - dt_h]) dovetail_slot(30);
}
translate([40, 0, 0]) m3_nut_trap(3);
translate([55, 0, 0]) screw_hole(m3_d, 10);
translate([80, 0, 0]) d_hole(t = plate_t);
translate([100, 0, 0]) difference() {
    cube([30, 30, 4]);
    wood_screw_holes([[8, 8], [22, 22]], 4);
}

echo("CHECK", "d_hole_flat", bh_flat + bh_flat_clr);
echo("CHECK", "d_hole_flat_gap", bh_flat_clr);
