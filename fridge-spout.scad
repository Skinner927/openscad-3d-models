$fa=0.5; // default minimum facet angle is now 0.5
$fs=0.5; // default minimum facet size is now 0.5 mm

ff = 0.02;

cw = 17;
cd = 14;
ch = cd + 4;

ext = 1.5;
taper = 2;

barb_h = 14;
barb_od = 15;
barb_ring_offset = 10;
barb_ring_h = 1.5;

difference() {
  outside(true);

  ss = barb_od/(barb_od+ext);
  scale([ss, ss, ss])
    outside(false);

  translate([0, 0, ch/2])
  scale([ss, ss, ss])
    outside(false);

  translate([0, 0, ch/-2])
  scale([ss, ss, ss])
    outside(false, false);
}


module outside(include_barb_ring = true, include_cube = true) {

  cube_end = (ch+ext)/-2;
  barb_start = cube_end+(barb_h/-2)+ff;
  ring_start = cube_end+(barb_ring_h/-2)+(barb_ring_h/2)-barb_ring_offset+ff;

  union() {
    if (include_cube) {
      hull() {
        cube([cw+ext, cd+ext, ch+ext], center=true);

        translate([0, 0, cube_end - taper])
          cylinder(h=ff, d=barb_od, center=true);
      }
    }

    translate([0, 0, barb_start])
      cylinder(h=barb_h, d=barb_od, center=true);

    if (include_barb_ring) {
      barb_size = barb_od+barb_ring_h;
      translate([0, 0, ring_start])
        resize(newsize=[barb_size, barb_size, barb_ring_h])
        sphere(d=barb_size);
    }
  }
}
