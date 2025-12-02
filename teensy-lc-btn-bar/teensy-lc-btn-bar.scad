btn_w = 13;
btn_h = 11;
btn_pad = 7;
btn_end_pad = btn_pad/2;
btn_count = 3;

teensy = [36, 18, 4];
teensy_wall = 2;
teensy_outer = teensy + [teensy_wall*2, teensy_wall*2, 0];

panel_w = (btn_w * btn_count) + (btn_pad * (btn_count-1)) + btn_end_pad*2;
panel_d = btn_h + btn_pad;
wall = 1;

base_h = 17+3;

zip = [5.5, 0, 2.5];

usb = [wall*3, 12, 10];
usb_leg = 1.2;  // triangle leg of top bevel

need_usb_if_panel_w_lt = 80;

ff = 0.01;
slop = 0.25;

/**** computed variables **/

// gap after rotating panel 45deg
panel_btm_gap = wall / sqrt(2);
panel_side_leg = panel_d / sqrt(2);

panel_y = panel_btm_gap + panel_side_leg;

echo(panel_w=panel_w, panel_d=panel_d, teensy_outer_y=teensy_outer.y);

/*!*!*!*!*!*!*!*!*!*!*\
|      Assembly       |
\*!*!*!*!*!*!*!*!*!*!*/
difference() {
  union() {
    panel();
    base();

    // USB brace
    if(panel_w < need_usb_if_panel_w_lt)
      translate([panel_w/2 - wall, panel_side_leg, -base_h])
      rotate(90, [0, 0, 1])
      rotate(90, [1, 0, 0])
      linear_extrude(wall)
      polygon([
        [0, 0],
        [0, base_h],
        [teensy_outer.y-panel_side_leg, base_h-panel_side_leg],
        [teensy_outer.y-panel_side_leg, 0]
      ]);
  }

  // USB hole
  if(panel_w < need_usb_if_panel_w_lt)
    translate([panel_w/2, teensy_outer.y/2, -base_h + wall/2 + ff*2])
    // center xy on origin, btm on z(0)
    translate([usb.x/-2, usb.y/-2, 0])
    rotate(90, [0, 0, 1])
    rotate(90, [1, 0, 0])
    linear_extrude(usb.x)
    polygon([
      [0, 0], [0, usb.z - usb_leg], [usb_leg, usb.z],
      [usb.y - usb_leg, usb.z], [usb.y, usb.z - usb_leg],
      [usb.y, 0]
    ]);

}


module base() {
  translate([0, panel_y/2, (base_h/-2)+ff])  {
    // 3 vertical walls
    difference() {
      base_v = [panel_w, panel_y, base_h];
      cube(base_v, center=true);

      translate([0, wall, 0])
        cube(base_v - [wall*2, 0, -base_h], center=true);

      // zip tie holes
      tie_count = 4;
      tie_pad = (base_v.x - (zip.x * tie_count)) / tie_count;
      tie_reset = base_v.x/-2 + zip.x/2;
      for (i = [0:tie_count-1])
        translate([
          tie_reset + tie_pad/2 + ((tie_pad + zip.x) * i),
          base_v.y/-2,
          base_v.z/-2 + zip.z/2 + teensy_outer.z
        ])
          cube(zip + [0, base_v.y, 0], center=true);
    }

    translate([0, teensy_outer.y/2 - panel_y/2, ff + base_h/-2]) {
      // floor
      cube([panel_w, teensy_outer.y, wall], center=true);

      // teensy mount
      translate([(panel_w - teensy_outer.x)/-2, 0, teensy_outer.z/2 - ff])
      difference() {
        // outer box
        cube(teensy_outer, center=true);
        // box cutout
        cube(teensy + [slop, slop, 10], center=true);
        // usb cutout
        translate([teensy.x/2, 0, 0])
          cube([teensy.x, 10, 10], center=true);
      }
    }
  }
}

module panel() {
  translate([0, panel_btm_gap, 0])
  union() {
    rotate(45, [1, 0, 0])
      translate([panel_w/-2, panel_d/2, 0])
      difference() {
        translate([0, panel_d/-2, 0])
          cube([panel_w, panel_d, wall]);

        // button cutouts
        for (i = [0:btn_count-1]) {
          x = (btn_w + btn_pad) * i;
          translate([x + btn_end_pad,  btn_h/-2, -wall])
            cube([btn_w, btn_h, wall*3]);
        }
      }
    // fill gap at bottom of panel
    translate([panel_w/-2, -panel_btm_gap, 0])
      cube([panel_w, panel_btm_gap, panel_btm_gap]);

    // triangle sides
    for (i = [1, -1])
    translate([(panel_w/2 + wall/-2)*i, 0, 0])
      translate([wall/2, panel_side_leg, 0])
      rotate(-90, [0, 1, 0])
      linear_extrude(wall)
        polygon([[0,0], [0, -panel_side_leg], [panel_side_leg, 0]]);
  }
}
