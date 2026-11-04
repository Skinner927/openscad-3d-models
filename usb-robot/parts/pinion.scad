// Pinion for an MG995 round horn. Qty 2 (X and Y axes).
// Exported horn recess UP: prints with no supports (only the small screw
// counterbores bridge). Screw it to the horn with the horn's small screws,
// then fit horn + pinion on the servo spline.
include <../lib.scad>
module pinion_print() { translate([0, 0, gear_thick]) rotate([180, 0, 0]) pinion(); }
pinion_print();

echo("CHECK", "x_travel", x_travel);
echo("CHECK", "x_travel_180", travel_for_deg(180));
echo("CHECK", "x_travel_120", travel_for_deg(120));
echo("CHECK", "y_travel_deg", deg_for_travel(y_travel));
