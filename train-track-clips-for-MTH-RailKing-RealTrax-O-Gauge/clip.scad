crenel_wdh = [4.4, 6.17, 7];

gap_x = 10.5; // distance between crenels
sliver_x = 1.4; // gap between crenel and bridge
gap_y = 6; // most critical; distance between crenels

bridge_wdh = [
  gap_x - (2*sliver_x),
  (2*crenel_wdh.y)+gap_y,
  2.45 - 0.25
];

assembly();

module assembly() {
  // bridge
  translate([0, 0, bridge_wdh.z/2])
    cube(bridge_wdh, center=true);

  ridge_wdh = [gap_x + (2*crenel_wdh.x), 1, bridge_wdh.z + 1.98];
  for (y = [1, -1]) {
    // ridges mesh into bridge and crenels butt up against ridges
    ridge_trans_y = y*(bridge_wdh.y/2 - ridge_wdh.y/2);
    translate([0, ridge_trans_y, ridge_wdh.z/2])
      cube(ridge_wdh, center=true);

    // shelf in the back
    shelf_wdh = [ridge_wdh.x, 2, 2.7];
    tri_chamf_h = ridge_wdh.z - shelf_wdh.z - 0.25;
    translate([
      0,
      y*((shelf_wdh.y/2) + (bridge_wdh.y/2)),
      shelf_wdh.z/2
    ])
      rotate([0, 0, y > 0 ? 0 : 180])
      union() {
        translate([(shelf_wdh.x/2), shelf_wdh.y/-2, shelf_wdh.z/2])
        rotate([0, -90, 0])
          linear_extrude(height = shelf_wdh.x)
          polygon([
            [0,0], [0,shelf_wdh.y], [tri_chamf_h, 0]
          ]);

        cube(shelf_wdh, center=true);
      }

    // crenels
    for (x = [1, -1]) {
      translate([
        x*(ridge_wdh.x/2 - crenel_wdh.x/2),
        (ridge_trans_y+ridge_wdh.y/(y*2))+(crenel_wdh.y*-y),
        0
      ])
        crenel(y);
    }

  }

}

// side can be 1 or -1
module crenel(side=1) {
  rotate([0, 0, side < 1 ? 180 : 0])
  difference() {
    translate([crenel_wdh.x/-2, 0, 0])
      cube(crenel_wdh);

    // chamfer
    chamf = [crenel_wdh.x + 2, 1.5, 1.5];
    translate([0, 0, crenel_wdh.z])
      rotate([45, 0, 0])
      cube(chamf, center=true);
  }

}
