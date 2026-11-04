// ============================================================
//  USB Switcher Robot: shared parameters
//  Axes: X along the port row, ports open toward -Y, plug in = +Y,
//        Z up from the plywood (Z = 0).
// ============================================================

$fn = 64;

/* [Fit] */
clr = 0.3; // sliding / fit clearance

/* [Hardware] */
m3_d = 3.4; // M3 clearance
m3_tap = 2.9; // M3 self-tapping / snug hole
m3_nut_af = 5.7; // M3 nut across flats (+fit)
m3_nut_t = 2.6;
m3_head_d = 6.2;
m4_d = 4.5; // M4 clearance (also wood screws to the plywood)
m4_nut_af = 7.2;
m4_nut_t = 3.4;
m4_head_d = 8.2;

/* [Layout] */
port_spacing = 60; // X distance between the two ports
x_travel = port_spacing + 10; // required X stroke
y_travel = 20; // plug in/out stroke

/* [Female bulkhead] */
bh_thread_d = 15;
bh_thread_len = 14; // front face to back-stop flange
bh_flat = 6.5; // flat on thread, distance from centre
bh_flat_clr = 0.1;
bh_hole_d = 15;
bh_flange_d = 20;
bh_nut_af = 19.92;
bh_nut_t = 3; // not measured: adjust to your nut
bh_rear_clear = 45; // clear zone behind plate for body + strain relief
plate_t = 4;

/* [Male plug] */
plug_block = [11, 6, 12]; // clamp block X, Y, Z
plug_drop = 13; // block bottom to magnetic face centre
plug_head_proj = 5; // head protrudes +Y past block +Y face
plug_cable_d = 6.7; // cable strain relief leaving the block top
// 0: the bend turns toward the 6 mm side (block 11 wide in X).
// 90: the bend turns toward the 11 mm side (block 6 wide in X, 11 deep in Y).
plug_rot = 90; // [0, 90]
plug_bx = plug_rot == 90 ? plug_block[1] : plug_block[0]; // block size across (X)
plug_by = plug_rot == 90 ? plug_block[0] : plug_block[1]; // block size toward the port (Y)

/* [Dovetail] */
dt_w = 12; // rail top (widest) width
dt_h = 4; // rail height
dt_angle = 60; // flank angle from horizontal (60 prints well)
dt_neck = dt_w - 2 * dt_h / tan(dt_angle);
dt_chamfer = 0.6; // 45 deg chamfer at slot openings (elephant's foot relief)

/* [MG995 servo] */
servo_body = [40.7, 19.7, 42.9]; // L, W, H (H excludes shaft boss)
servo_ear_len = 54; // overall length across ears
servo_ear_t = 2.5;
servo_ear_z = 29.5; // body bottom to underside of ears
servo_hole_spacing = 49.5; // ear hole c-c along L
servo_hole_gap = 10; // ear hole c-c across W
servo_shaft_off = 10.0; // shaft centre from body end (along L)
servo_top_z = 42.9 + 4; // body bottom to top of output spline
servo_brace_w = 1; // triangle brace on each ear, centred, shaft side
servo_brace_h = 4; // brace height at the body (not measured; tapers to 0 at the ear tip)
servo_brace_slit = 1.5; // slit in the holder's ear plate that clears it
horn_d = 21; // stock round horn disc
horn_t = 2.2;
horn_hole_r = 7.5; // horn screw-hole circle radius
horn_hole_n = 4;
horn_hole_d = 1.8; // M2 / horn self-tappers

/* [Positioning stage] */
stage_travel = 5; // fine travel each way, per axis
stage_L = 56; // base length (X)
stage_D = 50; // base width (Y)
stage_base_h = 6;
stage_tab_t = 6; // +X adjust-screw tab
xs_len = 30; // x-slider length (X)
xs_w = 28; // x-slider width (Y)
xs_h = 12;
col_t = 10; // column thickness (Y)
col_w = 34; // column width (X)
zs_w = 34; // z-slider width (X)
zs_t = 12; // z-slider thickness (Y), slot side included
zs_h = 22;
stage_gap_z = 6; // z-slider bottom above x-slider top, mid travel
cap_gap = 10; // cap underside above z-slider top, mid travel
cap_t = 6;
locknut_t = 4; // M3 nylock thickness
x_adj_len = 30; // X adjust screw length (README BOM)
z_adj_len = 30; // Z adjust screw length (README BOM)
xs_adj_hole = xs_len; // X adjust hole: through the x-slider
zs_adj_hole = zs_h; // Z adjust hole: through the z-slider
zl_pocket_w = m3_nut_af + clr; // Z lock nut pocket width (Y)
zl_side = 1; // Z lock screw enters from this stage-local X side

// ---- derived stage values (stage-local coords: base centred on x=y=0) ----
xs_xc = -stage_tab_t / 2; // x-slider centre X at mid
xs_top = stage_base_h + xs_h;
col_y0 = -xs_w / 2;
col_y1 = col_y0 + col_t; // column rail face
zs_z0 = xs_top + stage_gap_z; // z-slider bottom at mid
col_h = stage_gap_z + zs_h + cap_gap;
col_top = xs_top + col_h;
stage_top_z = col_top + cap_t;
payload_face_y = col_y1 + zs_t;
stage_payload_z = zs_z0 + zs_h / 2;
payload_pts = [[-8, -2], [8, -2]]; // (x, z) on payload face
stage_mount_pts = [
  for (sx = [-1, 1], sy = [-1, 1]) [sx * (stage_L / 2 - 5), sy * (stage_D / 2 - 6)],
];
xs_screw_z = 8; // in x-slider coords
zs_screw_y = col_y1 + 3; // Z adjust screw Y (clear of payload nut slots)
zs_screw_x = -12; // Z adjust screw X offset: keeps it clear of the bulkhead body
payload_hole_depth = 9.5; // M3 holes into the z-slider payload face
bracket_screw_len = 12; // port bracket -> z-slider screw (README BOM)
zs_arrow_depth = 0.4; // up-arrows recessed in the z-slider payload face and the Z rail

/* [World layout] */
port_z = 80; // port centre height above plywood
port_x = [0, port_spacing]; // port A, port B
port_face_y = 0; // front face of the port plates
// port tower origin: stage rotated 180 deg about Z under each plate
tower_y = port_face_y + plate_t + payload_face_y;
// tower B is a mirrored stage so both X adjust screws face outward
function tower_x(i) = port_x[i] + (i == 0 ? xs_xc : -xs_xc);
bh_face_y = port_face_y - (bh_thread_len - plate_t); // connector face

assert(port_z >= stage_top_z + 15, "port_z too low: bulkhead body would hit the stage");

/* [Rack and pinion] */
gear_mod = 1.5;
pinion_teeth = 30; // 45 mm pitch dia -> 70.7 mm per 180 deg
gear_thick = 8;
gear_pa = 20; // pressure angle
gear_backlash = 0.15; // removed from each rack tooth flank
pinion_pd = gear_mod * pinion_teeth;
function travel_for_deg(a) = PI * pinion_pd * a / 360;
function deg_for_travel(t) = t * 360 / (PI * pinion_pd);

/* [Plug mount (flexure + clamp)] */
flex_t = 5; // flexure plate thickness (Y)
flex_beam_w = 1.2; // flexure beam width: 1.2 PLA/PETG, ~2 for TPU
flex_float = 1.5; // X/Z float before the stop pins bottom out
flex_stop_gap = 1; // Y float before the island hits a stop strap
clamp_wall = 5; // cradle wall behind (-Y of) the plug block
clamp_lip_t = 1.5; // clamp cap thickness in front of the block
plug_reach = payload_face_y + flex_t + clamp_wall + plug_by + plug_head_proj; // stage origin -> plug face (Y)

/* [Machine stack] */
flex_isl_h = 22; // flexure island height
xb_t = 5; // X base plate
xc_h = 12; // X carriage body
yc_h = 10; // Y carriage body
xc_z0 = xb_t;
xc_top = xc_z0 + xc_h;
yc_z0 = xc_top;
yc_top = yc_z0 + yc_h; // male stage base sits here
servo_ear_to_pinion = 14; // ear (shaft-side face) to pinion top face
rack_base = 4;
m4_stage_bolt_len = 12; // male stage base -> Y carriage (README BOM)

// Male stage origin (stage-local 0,0 at yc_top) for carriage position
// x_pos (plug X, = port_x[i] at a port) and y_pos (0 = retracted,
// y_travel = plugged in).
ms_y_in = bh_face_y - plug_reach;
function ms_origin(x_pos, y_pos) = [x_pos - xs_xc, ms_y_in - (y_travel - y_pos), yc_top];

// Y carriage footprint relative to the male stage origin
yc_x0 = -stage_L / 2;
yc_x1 = stage_L / 2;
yc_pillar_d = 12;
yc_y0 = -stage_D / 2 - yc_pillar_d;
yc_y1 = stage_D / 2;
yc_len = yc_y1 - yc_y0;

// X carriage footprint relative to plug X (x) and world Y (y)
xc_x0 = yc_x0 - xs_xc - 42; // room for the Y servo on -X side
xc_x1 = yc_x1 - xs_xc + 2;
xc_y0 = ms_y_in - y_travel + yc_y0; // world Y, rear
xc_y1 = ms_y_in + yc_y1; // world Y, front
xc_len = xc_x1 - xc_x0;
x_pos_min = -5;
x_pos_max = port_spacing + 5;

// X rack (on X carriage -Y face, teeth toward -Y), X servo fixed on base
x_pitch_y = xc_y0 - rack_pitch_y(rack_base);
x_shaft_y = x_pitch_y - pinion_pd / 2;
x_shaft_x = (x_pos_max + xc_x0 + x_pos_min + xc_x1) / 2;
x_rail_x0 = x_pos_min + xc_x0;
x_rail_len = x_pos_max + xc_x1 - x_rail_x0;
x_rail_y = [xc_y0 + 18, xc_y1 - 18]; // two rails (front one is dovetail)
x_rack_z0 = xc_z0 + 1;
x_pinion_z0 = xb_t + 1;

// Y rack (on Y carriage -X face, teeth toward -X), Y servo on X carriage
y_pitch_x_rel = yc_x0 - rack_pitch_y(rack_base); // rel. stage origin
y_shaft_x_rel = y_pitch_x_rel - pinion_pd / 2 - xs_xc; // rel. plug X
y_shaft_y = ms_y_in - y_travel / 2 + (yc_y0 + yc_y1) / 2;
y_rack_z0 = yc_z0 + 1;
y_pinion_z0 = xc_top + 1;
