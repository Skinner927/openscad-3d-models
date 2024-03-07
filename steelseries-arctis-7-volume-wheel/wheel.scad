$fn = $preview ? 32 : 180;
ff = 0.001; // global fudge

// Diagram of pot mounting pin
// https://www.aliexpress.us/item/3256803001774180.html
// https://www.mouser.com/datasheet/2/15/RK08H-1371008.pdf
pin_ff = 0.4;  // fudge to embiggen the shaft for easier fitting
pin_d = pin_ff + 2.5;
pin_cut_w = pin_ff + 1.9;
pin_screw_d = 1.4 + 0.1; // M1.4 screw
pin_h = 1;

/* This is what the wheel essentially looks like (lol)

         |~~~~~~~~~~~~~~~| -- l3_d  // layer3 diameter
           |~~~~~~~~~~~| ---- l2_d  // layer2 diameter
              |~~~~~| ------- l1_d  // layer1 diameter
                 .---------- screw
                 v
              #######    <--- l1_h  // layer1 height
   .---+   ############# <-----------------------------+- l2_h  // layer2 height
   |---^ ################# <- l3_h  // layer3 height   |
   |       ############# <-----------------------------/
   |
l3_offset // layer3 offset, from bottom of layer1 to top of layer

      Cross-section view.
      Dots mark what is hollow.

              ###.### <-----+- distance between bottom of layer1 and top of void
           #####...##### <--+    should be pin height (pin_h).
         ###...........###       void_offset = pin_h;
           #...........#
          |~|                             .
           \ wall_t = 1.5  // wall thickness
                                     .
            |~~~~~~~~~~| <- void_w // should be (l2_d - (wall_t*2))
*/
l3_d = 14.5;  // maybe 14.25?
l2_d = 13;
l1_d = 8;

l1_h = 0.5;
l2_h = 3.2;
l3_h = 1;

l3_offset = 1;
wall_t = 1.5;

void_h = l2_d;
void_offset = pin_h;


difference() {
  // DEBUG !!!!!!!!!!!!!!!!!!!!!!!!
  // Add a % to the front of union() to see the insides :D
  union() {
    // layer1's bottom will be at Z=0
    color("lime", 0.8)
    translate([0, 0, (l1_h/2) - 0.25])
    cylinder(h=l1_h + 0.5, d=l1_d, center=true);

    // layer2's top is at Z=0
    color("coral", 0.4)
    translate([0, 0, (l2_h + ff)/-2])
    cylinder(h=l2_h + ff, d=l2_d, center=true);

    // layer3
    color("DeepSkyBlue")
    translate([0, 0, (l3_h/-2) - l3_offset])
    cylinder(h=l3_h, d=l3_d, center=true);
  }

  // If I don't first union these, the transparent rendering doesn't work
  // correctly.
  union() {
    // void
    color("Indigo")
    translate([0, 0, -l2_h - void_offset])
    cylinder(h=l2_h*2, d=l2_d - wall_t, center=true);

    // pin
    color("Red")
    translate([0, 0, -ff])
    pin();
  }
}


module pin() {
  union() {
    // potentiometer shaft
    translate([0, 0, pin_h/-2])
    intersection() {
      cylinder(h=pin_h, d=pin_d, center=true);
      cube([pin_cut_w, pin_d, pin_h + ff + ff], center=true);
    }
    // Screw hole (arbitrary height)
    translate([0, 0, 1 - ff])
    cylinder(h=2, d=pin_screw_d, center=true);
  }
}
