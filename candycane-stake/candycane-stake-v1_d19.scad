$fn = 180;
ff = 0.001;  // fudge

stake_l = 105;
wing_t = 3;
insert_l = 30;  // includes collar
insert_d = 19;
collar_d = insert_d + 4;
collar_h = 2;

full_l = stake_l + insert_l;

union() {

  // stake
  intersection() {
    // wings
    union() {
      translate([ 0, 0, full_l / 2 ]) {
        rotate(90, [ 0, 0, 1 ])
          cube([ wing_t, insert_d, full_l ], center = true);
        cube([ wing_t, insert_d, full_l ], center = true);
      }
    }

    // cone
    union() {
      translate([ 0, 0, stake_l - ff ])
        cylinder(h = insert_l, d = insert_d);
      cylinder(h = stake_l, d1 = 0, d2 = insert_d, center = false);
    }
  }

  // collar
  translate([ 0, 0, full_l - insert_l ]) {
    collar_wedge();

    rotate(180, [ 0, 0, 1 ])
      collar_wedge();
  }
}

module collar_wedge() {
  jj = (wing_t / 2) - ff;
  difference() {
    cylinder(h = collar_h, d = collar_d, center = true);
    translate([ jj, -collar_d, -collar_d ])
      cube(collar_d * 2, center = false);
    translate([ -collar_d, jj, -collar_d ])
      cube(collar_d * 2, center = false);
  }
}
