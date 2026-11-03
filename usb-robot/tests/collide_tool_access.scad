// Screwdriver access: a 5 mm shaft must reach every adjust screw of both
// towers with both bulkheads installed.
//   Z screws: straight down onto the cap.  X screws: straight in along X.
include <../port_tower.scad>

function to_world(i, p) = let(x = i == 1 ? -p[0] : p[0])
    [tower_x(i) - x, tower_y - p[1], p[2]];

module drivers(i) {
    z = to_world(i, [xs_xc + zs_screw_x, zs_screw_y, stage_top_z]);
    translate(z) cylinder(d = 5, h = 120);
    x = to_world(i, [stage_L / 2, 0, stage_base_h + xs_screw_z]);
    out = i == 0 ? -1 : 1;     // tab faces outward in world X
    translate(x) rotate([0, out * 90, 0]) cylinder(d = 5, h = 120);
    // Z lock screw: horizontal along stage-local X from the z-slider side
    lx = zl_side * (zs_w / 2);
    l = to_world(i, [xs_xc + lx, col_y1 + 2, zs_z0 + zs_h - 5]);
    lout = (i == 0 ? -1 : 1) * zl_side;
    translate(l) rotate([0, lout * 90, 0]) cylinder(d = 5, h = 120);
}

intersection() {
    union() { drivers(0); drivers(1); }
    union() {
        for (i = [0, 1]) { port_tower_world(i); bulkhead_world(i); }
    }
}
