use <roundedcube.scad>

$fs = $preview ? 0.3 : 0.1;
$fa = $preview ? 0.3 : 0.1;

ff = 0.001;  // Universal fudge

banister_x = 76;  // Banister width (x)
banister_y = 76;  // Banister depth (y)
felt = 2;         // padding thickness

bracket_t = 7;   // How thick the bracket is
bracket_h = 27;  // Bracket height (z)

// going to use a #8-32 x 1.5" bolt
bolt_head_d = 8.4;     // Diameter of the bolt head pocket (should be slightly larger than actual)
bolt_hole_d = 4.5;     // Diameter of the Bolt's screw (+ wiggle)
bolt_nut_d = 9.7;      // Nut's max diameter (go close to accurate)
bolt_nut_depth = 4.5;  // How deep should the pocket be? Used for head side too.
bolt_nut_nsides = 6;   // Number of sides for the nut

// - done config -

// With felt
banister_xf = banister_x + felt;
banister_yf = banister_y + felt;

difference() {
  // bracket base
  color("green", 1.0)
    roundedcube([ banister_xf + bracket_t, banister_yf + bracket_t, bracket_h ], center = true);

  // banister
  color("BurlyWood", 0.2)
    cube([ banister_xf, banister_yf, bracket_h * 6 ], center = true);
}  // difference()
// nut
// cylinder(h=bolt_nut_depth, d=bolt_nut_d, center=true, $fn=bolt_nut_nsides);

module cylinder_outer(height, radius, fn) {
  // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
  fudge = 1 / cos(180 / fn);
  cylinder(h = height, r = radius * fudge, $fn = fn);
}
