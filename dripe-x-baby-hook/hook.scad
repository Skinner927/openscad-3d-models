id = 26;
ir = id/2;
id_cut = 22; // where to cut circle in half measuring from the top, NOT origin.
y_cut = (id_cut - ir);
height = 36;
thic = 6;
// Nice round end at end of clip
ball_cyl_r = thic/4;
// Increase r because we have to deal with thic
ball_r = ir + ball_cyl_r;
// this should prob use radians but whatever, it works, it'll never change
ball_y_slide = thic/8;

arm_length = 19; // Starts from end of cut

$fn = 90;

union() {
  clip();

  translate([(circle_x(r=ball_r, y=y_cut)*2) + ball_cyl_r, arm_length+ir+thic, 0])
    rotate([0, 0, 180])
    clip();
}



function circle_x(r, y) = sqrt( (r^2) - (y^2));

module clip() {
  od = id+thic;

  union() {
    difference() {
      cylinder(h = height, r = od/2, center=true);
      cylinder(h = height*1.5, r = ir, center=true);

      // Slice the circle to make a clip
      cut_od = od * 1.5;
      cut_h = height * 1.5;
      translate([cut_od/-2, y_cut - ball_y_slide, cut_h/-2])
        cube([cut_od, cut_od, cut_h], center=false);
    }


    // Add 2 cylinders for smooth ends where we slice the circle
    /*
    We need to get the coords of where the circle ends after the cut so we
    can put a cylinder on there to smooth it.

    Given a circle at 0,0 with diameter = `id`, we cut at `id_cut` which is
    from the edge of the circle down.

    Formula:
    x^2 + y^2 = r^2

    ir = r = id/2
    y = id_cut - ir

    We need to solve for x:
    x^2 = r^2 - y^2

    x^2 = sqrt( (ir^2) - (abs(ir - id_cut)^2) )
    */
    // Do both sides of the circle
    for (side = [1, -1]) {
      // Hull 2 circles along the circle's path to clip sharp edges
      color("green", 0.4)
      hull() {
        for (cy_o = [(ball_y_slide * -2), 0]) {
          c_y = y_cut + cy_o;
          c_x = circle_x(r=ball_r, y=c_y);
          translate([side * c_x, c_y, 0])
            cylinder(h = height, r = ball_cyl_r, center=true);
        }
      }
    }

    // Arm
    difference() {
      arm_xtra = thic;
      translate([circle_x(r=ball_r, y=y_cut) - (ball_cyl_r/2), y_cut - arm_xtra, height/-2])
        cube([ball_cyl_r*2, arm_length + arm_xtra, height], center=false);

      // Trim by ID
      cylinder(h = height*1.5, r = ir, center=true);
    }
  }
}
