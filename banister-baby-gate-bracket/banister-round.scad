$fn = $preview ? 90 : 180;

id1 = 40;
id2 = 41; // 41
wall = 10;

block_h = 34;
block_w = 41;
block_o = 63; // offset from center of id2
bs_distance = 24.8; // spacing betwix 2 inserts
bs_d = 6; // Diameter of the insert
bs_ho = 8.66; // insert distance from top


cut_w = 10;

bolt_d = 4.5;
bolt_head_d = 7.5;
bolt_head_h = 3;

insert_d = 6;
insert_len = 10;

render_left = false;

difference() {
  union() {
    ear(true);
    ear(false);
    cylinder(h=block_h, d1=id2+wall, d2=id1+wall, center=true);
    translate([0, (block_o/2), 0])
      cube([block_w, block_o, block_h], center=true);
  }
  // banister
  cylinder(h=block_h+0.02, d1=id2, d2=id1, center=true);
  // cutout
  cube([id2+wall+wall+6, cut_w, block_h+6], center=true);

  #bs_insert(true);
  #bs_insert(false);

  // Speed hole (purpose is to actually add more walls so block is stronger)
  translate([0, 0.5+block_o, -5])
  rotate(90, [1, 0, 0])
  cylinder(h = block_o, d = 15, center=false);


  if (!$preview) {
    rm_render_d = block_o + 10;
    translate([0, rm_render_d / (render_left ? 2 : -2), 0])
      cube([id2+wall+wall+6, rm_render_d, block_h+6], center=true);
  }
}



module bs_insert(left=true) {
  translate([(bs_distance/(left ? 2: -2)), 0.5+block_o, block_h/2 - bs_ho])
  rotate(90, [1, 0, 0])
  // Needs extra cavity for melted plastic to go somewhere
  cylinder(h = block_o, d = bs_d, center=false);
}

module ear(left=true) {
  insert_space = 1.5;
  bolt_space = 4;
  main_h = cut_w + insert_len + insert_space + bolt_head_h + bolt_space;
  rim = 3;
  main_d = bolt_head_d + rim;
  xlate = (id2/2)+(wall/2)+(rim/2)+0.5;
  ylate = (main_h/2) - bolt_head_h - bolt_space - (cut_w/2);

  translate([xlate * (left ? 1 : -1), ylate, 0])
  rotate(90, [1, 0, 0])
  difference() {
    union() {
      cylinder(h = main_h, d = main_d, center=true);
      translate([main_d * (left ? -1 : 1), 0, 0])
        cube([main_d*2, main_d, main_h], center=true);
    }

    // bolt head recess
    translate([0, 0, main_h/2])
      cylinder(h=bolt_head_h, d1=bolt_d, d2=bolt_head_d, center=true);

    // bolt shaft
    cylinder(h=main_h+6, d=bolt_d, center=true);

    // insert
    translate([0, 0, (main_h/-2)+(insert_len/2)])
      cylinder(h = insert_len+0.2, d=insert_d, center=true);

    // Enable the bottom 2 in debug only
    if ($preview && left) {
      // slices cylinder in half to mark where insert needs to start
      #translate([0, 0, (main_h/-2)+(insert_len)+0.5+insert_space])
        cube([bolt_head_d*2, bolt_head_d*2, 1], center=true);

      // slices cylinder in half where bolt can end
      #translate([0, 0, (main_h/2)-0.5-bolt_space-bolt_head_h])
        cube([bolt_head_d*2, bolt_head_d*2, 1], center=true);
    }
  }





}
