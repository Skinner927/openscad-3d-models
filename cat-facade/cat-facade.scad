$fn = $preview ? 90 : 180;

actual_inner_w = 254;  // 10"
actual_inner_h = 280;  // 11"

inset = 7; // 1/4" overhang over cabinet hole
inner_w = 254 - inset;
lower_facade_h = 89;  // 3.5"
inner_h = 191 + lower_facade_h - inset;
upper_arch_h = 127; // 5"

upper_circle_r = 40;
lower_circle_r = 30;

outer_gap = 38; // ~1.5"
outer_circle_top_r = upper_circle_r;
outer_circle_btm_r = lower_circle_r;

title_offset_h = upper_circle_r;
title_h = 30;
// guess and check. It's supposed to be pt = height / 0.254 but it's not
title_pt = 35;
title_d = 70;

if ($preview) {
  // hole in cabinet for reference
  % color("red", 0.25)
  translate([inset/-2, 0, 0])
  square([actual_inner_w, actual_inner_h]);
}


// Use ! to isolate layers for SVG export

// base-layer.svg
% color("lightgrey", 0.8) base_layer();
// fence-layer.svg
color("green", 1.0) fence_layer();
if(1) {
  // cat-circle-with-engraving.svg
  color("blue", 0.6)
  difference() {
      cat_circle_layer();
      cat_etch_layer();
  }
} else {
  // cat-circle.svg
  color("blue", 0.6) cat_circle_layer();
  // cat-etching.svg
  color("yellow", 1) cat_etch_layer();
}




module cat_etch_layer() {
  translate([inner_w/2, inner_h + title_offset_h - 4, 0])
  /* Using the literal emoji works but OpenSCAD extension panics. */
  /* print("<literal emoji>".encode("ascii", "backslashreplace").decode("utf-8")) */
  text(text="\U01f431", size=title_pt, font="Segoe UI Emoji:style=Regular", halign="center", valign="center");
}

module cat_circle_layer() {
  translate([inner_w/2, inner_h + title_offset_h, 0])
  circle(d=title_d);
}

module fence_layer() {
  fence_w = inner_w + 1 + outer_gap*2;
  intersection() {
    translate([-outer_gap, 0, 0])
    picket_fence(w=fence_w, h=lower_facade_h * 0.8, align=false, center=false);

    base_layer();
  }

}

module base_layer() {
  difference() {
    outer_edge();
    center_cutout();
  }
}

module center_cutout() {
  union() {
    translate([0, lower_facade_h + lower_circle_r, 0])
    square([inner_w, inner_h - upper_circle_r - lower_facade_h - lower_circle_r]);

    // upper round
    translate([0, inner_h - upper_circle_r, 0])
    hull() {
      // left circle
      translate([upper_circle_r, 0, 0])
      circle(upper_circle_r);

      // right circle
      translate([inner_w - upper_circle_r, 0, 0])
      circle(upper_circle_r);
    }


    // lower round
    translate([0, lower_facade_h + lower_circle_r, 0])
    hull() {
      // left circle
      translate([lower_circle_r, 0, 0])
      circle(lower_circle_r);

      // right circle
      translate([inner_w - lower_circle_r, 0, 0])
      circle(lower_circle_r);
    }
  }
}

module outer_edge() {
  hull() {
    // bottom left circle
    translate([-(outer_gap - outer_circle_btm_r), outer_circle_btm_r, 0])
    circle(outer_circle_btm_r);

    // top left circle
    translate([-(outer_gap - outer_circle_top_r), inner_h, 0])
    circle(outer_circle_top_r);

    // bottom right circle
    translate([inner_w + (outer_gap - outer_circle_btm_r), outer_circle_btm_r, 0])
    circle(outer_circle_btm_r);

    // top right circle
    translate([inner_w + (outer_gap - outer_circle_top_r), inner_h, 0])
    circle(outer_circle_top_r);

    // top center circle
    translate([inner_w/2, inner_h + title_offset_h, 0])
    circle(outer_circle_top_r);
  }
}

module picket_fence(w=200, h=50, align=false, center=false) {
  fw = h * 0.10;
  ft = fw/2;
  fh = h - ft;

  ff = 0.01; // fudge

  segment_w = fw * 3;
  brace_h = h / 8;

  // Align will put the first picket centered on the origin
  bump = align ? segment_w/2 : 0;

  translate([center ? w/-2 : 0, 0, 0])
  for (i = [0 : segment_w : w + bump]) {
    translate([i - bump, 0, 0])
    union() {
      // bottom brace
      translate([0, brace_h, 0])
      square([segment_w + ff*2, brace_h]);

      // top brace
      translate([0, h - ft - brace_h*2, 0])
      square([segment_w + ff*2, brace_h]);

      // picket
      translate([segment_w/2 - fw/2, h - ft, 0])
      //   1
      // 0   2
      //
      // 4   3
      polygon(points=[
        // triangle
        //   1
        // 0   2
        [0,0], [fw/2, ft], [fw, 0],
        // plank/body
        // 4   3
        [fw, -fh], [0, -fh]
        ]);
    }
  }
}

/*
  %
    translate([inner_w/2, inner_h - (upper_arch_h/4), 0])
    resize([inner_w, upper_arch_d, 0])
    circle(inner_w/2);



    // box (delete I think!)
    translate([upper_circle_r, inner_h - upper_circle_d, 0])
    square([inner_w - upper_circle_d, upper_circle_d]);
    */
