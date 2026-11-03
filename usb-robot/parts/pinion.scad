// Pinion for an MG995 round horn. Qty 2 (X and Y axes).
// Print flat, horn recess down. Screw it to the horn with the horn's
// small screws, then fit horn + pinion on the servo spline.
include <../lib.scad>
pinion();

echo("CHECK", "x_travel", x_travel);
echo("CHECK", "x_travel_180", travel_for_deg(180));
echo("CHECK", "x_travel_120", travel_for_deg(120));
echo("CHECK", "y_travel_deg", deg_for_travel(y_travel));
