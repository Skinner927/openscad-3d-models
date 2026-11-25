// The nut spanner must reach both adjust nylocks without hitting the stage.
// Stage-local, mid travel. Must render EMPTY.
//   X nylock (inside the base tab): 15 deg end from above, stage fully
//   assembled with the port bracket on.
//   Z nylock (under the cap): on the bench before the bracket goes on,
//   15 deg end from the front (+Y) or 90 deg end from the -X side.

include <../port_tower.scad>
use <../spanner.scad>

xn = [stage_L / 2 - stage_tab_t - locknut_t / 2, 0, stage_base_h + xs_screw_z];
zn = [xs_xc + zs_screw_x, zs_screw_y, col_top - locknut_t / 2];

module x_spanner() for (m = [0, 1]) translate(xn) mirror([0, m, 0])
    rotate([0, 0, 90]) rotate([-90, 0, 0]) spanner_at(0);
module z_spanners() translate(zn) {
    for (m = [0, 1]) mirror([m, 0, 0]) rotate([0, 0, 180]) spanner_at(0);
    rotate([0, 0, 180]) spanner_at(1);
}

intersection() {
  union() { stage_assembly(); stage_payload_origin() port_bracket(); }
  x_spanner();
}
intersection() { stage_assembly(); z_spanners(); }
