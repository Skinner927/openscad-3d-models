// ============================================================
//  Male plug mount: flexure (frame + 4 L-beams + floating island with
//  the clamp cradle built in), clamp cap, and two identical stop
//  straps (front + back) whose pins limit X/Z float to +/-flex_float
//  and whose 1 mm standoff limits Y float to +/-flex_stop_gap.
//  Local coords: origin at the stage payload face centre, +Y away from
//  the stage, Z relative to the payload centre.
// ============================================================
include <port_tower.scad>
include <axes.scad>

plug_dz = port_z - (yc_top + stage_payload_z); // plug centre above payload centre
blk_x = plug_bx / 2 + 0.1; // snug in X
blk_y0 = flex_t + clamp_wall; // block back face
blk_y1 = blk_y0 + plug_by; // block front face
blk_z0 = plug_dz + plug_drop; // block bottom
blk_z1 = blk_z0 + plug_block[2];
crad_x = blk_x + 5; // cradle half width
crad_y1 = blk_y1 - 0.4; // cradle stops short: cap clamps the block
cap_back_y = crad_y1;
crad_scr = blk_x + 2.5; // cradle screw X
lip_in = plug_bx / 2 - 0.45; // top lips overlap the block by 0.55 mm
relief_hole_d = 7; // through the lips, centred on the cable

isl_x = 19; // island half width
isl_z0 = blk_z0 - 1;
isl_z1 = isl_z0 + flex_isl_h;
flex_g = 6; // island-to-frame gap
in_x = isl_x + flex_g;
in_z0 = isl_z0 - flex_g;
in_z1 = isl_z1 + flex_g;
fr_bar = 5;
fr_x = in_x + fr_bar;
fr_z0 = -zs_h / 2;
fr_z1 = in_z1 + fr_bar;

pin_d = 4;
pin_z = isl_z1 - 4;
pin_hole = pin_d + 2 * flex_float;
strap_w = 8;
strap_t = 3;
strap_foot_w = 18;
strap_z0 = pin_z - 4;
strap_scr = [-5, 5]; // strap screw X (through the top bar)
strap_scr_z = (in_z1 + fr_z1) / 2;

// one L-beam: island bottom face -> down -> outward -> up -> frame side
leg = 3;
function beam_path(sx, sz) =
  let (
    zc = (isl_z0 + isl_z1) / 2,
    zi = sz < 0 ? isl_z0 : isl_z1,
    zh = zi + sz * leg,
    zv = zc + sz * (flex_g - 2 + 0.5),
    xv = sx * (isl_x + leg)
  ) [[sx * 10, zi], [sx * 10, zh], [xv, zh], [xv, zv], [sx * in_x, zv]];

module poly_beam(pts, w) {
  for (k = [0:len(pts) - 2])
    hull() {
      translate(pts[k]) square(w, center=true);
      translate(pts[k + 1]) square(w, center=true);
    }
}

// XZ outline helpers: 2D (x, z) extruded along +Y from y0, thickness t
module xz_extrude(y0, t, convexity=4) { translate([0, y0 + t, 0]) rotate([90, 0, 0]) linear_extrude(height=t, convexity=convexity) children(); }

module plug_flexure() {
  difference() {
    union() {
      xz_extrude(0, flex_t) {
        difference() {
          translate([-fr_x, fr_z0]) square([2 * fr_x, fr_z1 - fr_z0]);
          translate([-in_x, in_z0]) square([2 * in_x, in_z1 - in_z0]);
        }
        translate([-isl_x, isl_z0]) square([2 * isl_x, isl_z1 - isl_z0]);
        for (sx = [-1, 1], sz = [-1, 1]) poly_beam(beam_path(sx, sz), flex_beam_w);
      }
      // clamp cradle on the island front: back wall + side walls
      translate([-crad_x, flex_t - 0.01, blk_z0]) cube([2 * crad_x, clamp_wall + 0.01, plug_block[2]]);
      for (sx = [-1, 1])
        translate([sx > 0 ? blk_x : -crad_x, blk_y0 - 0.01, blk_z0])
          cube([crad_x - blk_x, crad_y1 - blk_y0 + 0.01, plug_block[2]]);
      // Z retention: lips over the block's top corners, leaving a slot for
      // the cable. Nothing under the block: the plug's bent body hangs below.
      for (sx = [-1, 1])
        translate([sx > 0 ? lip_in : -crad_x, blk_y0 - 0.01, blk_z1])
          cube([crad_x - lip_in, crad_y1 - blk_y0 + 0.01, 1.5]);
    }
    // hole through the top lips for the cable strain relief (the plug goes
    // in from below)
    translate([0, blk_y0 + plug_by / 2, blk_z1 - 0.01]) cylinder(d=relief_hole_d, h=1.5 + 0.02);
    // payload screws into the stage z-slider
    for (p = payload_pts) translate([p[0], -0.5, p[1]]) rotate([-90, 0, 0]) screw_hole(m3_d, flex_t + 1);
    // stop-pin hole (through) and strap screws (through the top bar)
    translate([0, -0.5, pin_z]) rotate([-90, 0, 0]) screw_hole(pin_hole, flex_t + 1);
    for (x = strap_scr) translate([x, -0.5, strap_scr_z]) rotate([-90, 0, 0]) screw_hole(m3_d, flex_t + 1);
    // cap screws, tapped into the cradle side walls
    for (sx = [-1, 1])
      translate([sx * crad_scr, crad_y1 + 0.01, (blk_z0 + blk_z1) / 2])
        rotate([90, 0, 0]) screw_hole(m3_tap, crad_y1 - flex_t + 1);
  }
}

// Clamp cap: 1.5 mm over the block, thicker over the screws.
module plug_clamp_cap() {
  // flat back at the cradle front: squeezes the block (it stands 0.4 proud)
  difference() {
    union() {
      translate([-crad_x, cap_back_y, blk_z0]) cube([2 * crad_x, blk_y1 - cap_back_y + clamp_lip_t, plug_block[2]]);
      for (sx = [-1, 1])
        translate([sx > 0 ? blk_x : -crad_x, cap_back_y, blk_z0])
          cube([crad_x - blk_x, 4, plug_block[2]]);
    }
    for (sx = [-1, 1])
      translate([sx * crad_scr, cap_back_y - 0.01, (blk_z0 + blk_z1) / 2])
        rotate([-90, 0, 0]) screw_hole(m3_d, 5);
  }
}

// Stop strap in its own frame: back face on y=0, pin toward -Y.
module plug_flex_stop() {
  difference() {
    union() {
      translate([-strap_w / 2, 0, strap_z0]) cube([strap_w, strap_t, fr_z1 - strap_z0]);
      translate([-strap_foot_w / 2, -flex_stop_gap, in_z1]) cube([strap_foot_w, strap_t + flex_stop_gap, fr_z1 - in_z1]);
      translate([0, 0.01, pin_z]) rotate([90, 0, 0]) cylinder(d=pin_d, h=flex_stop_gap + 2);
    }
    for (x = strap_scr)
      translate([x, -flex_stop_gap - 0.5, strap_scr_z]) rotate([-90, 0, 0])
          screw_hole(m3_d, strap_t + flex_stop_gap + 1);
  }
}

module plug_flex_stops_placed() {
  translate([0, flex_t + flex_stop_gap, 0]) plug_flex_stop(); // front
  translate([0, -flex_stop_gap, 0]) mirror([0, 1, 0]) plug_flex_stop(); // back
}

// The plug, as separate pieces so a slide-in path can be swept piecewise:
// each piece is hulled with a copy moved by the vector sweep.
module plug_body_pieces(sweep = [0, 0, 0], relief = true) {
  module sw() { hull() { children(); translate(sweep) children(); } }
  sw() translate([-plug_bx / 2, blk_y0, blk_z0]) cube([plug_bx, plug_by, plug_block[2]]);
  if (relief) sw() translate([0, blk_y0 + plug_by / 2, blk_z1]) cylinder(d=plug_cable_d, h=15); // cable strain relief
  sw() hull() {
    translate([-plug_bx / 2, blk_y0, plug_dz - 4]) cube([plug_bx, plug_by, blk_z0 - plug_dz + 4]);
    translate([0, blk_y1 + plug_head_proj - 1, plug_dz]) rotate([-90, 0, 0]) cylinder(d=8, h=1);
  }
}
module plug_body_local() { color("White") plug_body_pieces(); }

// Everything that moves with the plug carriage, minus the plug itself.
module plug_mount_world(x_pos, y_pos, dx = 0, dz = 0) {
  o = ms_origin(x_pos, y_pos);
  translate(o) {
    stage_assembly(dx, dz);
    stage_payload_origin(dx, dz) {
      color("Orange") plug_flexure();
      color("Gold") plug_clamp_cap();
      color("Khaki") plug_flex_stops_placed();
    }
  }
}
module plug_body_world(x_pos, y_pos, dx = 0, dz = 0) {
  o = ms_origin(x_pos, y_pos);
  translate(o) stage_payload_origin(dx, dz) plug_body_local();
}

// ---- checks ----
echo("CHECK", "clamp_lip_t", clamp_lip_t);
echo("CHECK", "clamp_preload", blk_y1 - cap_back_y);
echo("CHECK", "clamp_x_play", blk_x - plug_bx / 2);
echo("CHECK", "pillar_above_flex", pillar_top - (yc_top + stage_payload_z + fr_z1));
echo("CHECK", "clamp_bottom_above_plug", blk_z0 - plug_dz);
echo("CHECK", "clamp_lip_overlap", blk_x - lip_in);
// lip left over the block in front of / behind the relief hole (Y)
echo("CHECK", "lip_hold_y", (plug_by - relief_hole_d) / 2);
echo(
  "CHECK", "plug_insert_err",
  (ms_origin(0, y_travel)[1] + payload_face_y + blk_y1 + plug_head_proj) - bh_face_y
);
echo("CHECK", "flex_xz_stop", (pin_hole - pin_d) / 2);
// beam-to-island and beam-to-frame clearance must exceed the stop travel
echo("CHECK", "flex_beam_clear", leg - flex_beam_w / 2);
