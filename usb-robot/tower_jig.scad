// ============================================================
//  Tower placement jig: a flat plate laid on the plywood. Its front
//  strip butts against the X base's back edge (setting the 6 mm gap),
//  two arms hug the X base's back corners (setting X), and two pockets
//  hold the bare stage bases of port towers A and B. Screw the bases
//  down, lift the jig off, then build the stages on them.
//  World coords (same as assembly.scad).
// ============================================================
include <axes.scad>

jig_t     = 3;     // plate thickness (well under the 6 mm stage base)
jig_clr   = 0.4;   // per side, pockets and arms
jig_wall  = 6;     // material around each pocket
jig_arm_w = 6;     // arm width (X) beside the X base ends
jig_arm_l = 20;    // arm length (-Y) along the X base ends

function jig_pocket(i) = [tower_x(i) - stage_L / 2 - jig_clr, tower_y - stage_D / 2 - jig_clr,
                          stage_L + 2 * jig_clr, stage_D + 2 * jig_clr];   // x, y, w, d

module tower_jig_2d() {
    ax0 = xb_x0 - jig_clr - jig_arm_w;
    ax1 = xb_x1 + jig_clr + jig_arm_w;
    back = tower_y + stage_D / 2 + jig_clr + jig_wall;
    difference() {
        union() {
            // front strip (fills the gap to the towers) + band around the pockets
            translate([ax0, xb_y1]) square([ax1 - ax0, tower_y - stage_D / 2 - jig_clr - xb_y1]);
            for (i = [0, 1]) let (p = jig_pocket(i))
                translate([p[0] - jig_wall, xb_y1]) square([p[2] + 2 * jig_wall, back - xb_y1]);
            // corner arms along the X base's left and right ends
            for (x = [ax0, xb_x1 + jig_clr]) translate([x, xb_y1 - jig_arm_l]) square([jig_arm_w, jig_arm_l + 0.01]);
            // tie the arms to the strip at full width
            translate([ax0, xb_y1]) square([ax1 - ax0, jig_wall]);
        }
        for (i = [0, 1]) let (p = jig_pocket(i)) translate([p[0], p[1]]) square([p[2], p[3]]);
    }
}

module tower_jig_world() { linear_extrude(jig_t) tower_jig_2d(); }

// front strip width between the X base and the pockets
echo("CHECK", "jig_strip_w", tower_y - stage_D / 2 - jig_clr - xb_y1);
