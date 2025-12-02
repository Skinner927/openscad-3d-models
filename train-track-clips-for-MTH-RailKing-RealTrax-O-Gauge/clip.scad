// Crenels are the cubes near each corner. Use this to modify their width, depth, and height.
crenel_wdh = [4.4, 6.17, 7];

// Distance between crenels across the Y-axis (left to right)
y_distance_between_crenels = 10.5;

// Distance between crenels across the X-axis (face to face)
x_distance_between_crenels = 6;

// Size of the gap between the crenel and the bridge that connects the opposite pairs of crenels
crenel_to_bridge_gap = 1.4;

bridge_thickness = 2.2;

// height of the wall on top of the bridge between the crenels
wall_height = 1.98;

back_shelf_depth = 2;
back_shelf_height = 2.7;


module __Customizer_Limit__ () {}  // Hide following assignments from Customizer.

gap_x = y_distance_between_crenels;
sliver_x = crenel_to_bridge_gap;
gap_y = x_distance_between_crenels;

bridge_wdh = [
  gap_x - (2*sliver_x),
  (2*crenel_wdh.y)+gap_y,
  bridge_thickness
];

assembly();

module assembly() {
  // bridge
  translate([0, 0, bridge_wdh.z/2])
    cube(bridge_wdh, center=true);

  ridge_wdh = [gap_x + (2*crenel_wdh.x), 1, bridge_wdh.z + wall_height];
  for (y = [1, -1]) {
    // ridges mesh into bridge and crenels butt up against ridges
    ridge_trans_y = y*(bridge_wdh.y/2 - ridge_wdh.y/2);
    translate([0, ridge_trans_y, ridge_wdh.z/2])
      cube(ridge_wdh, center=true);

    // shelf in the back
    shelf_wdh = [ridge_wdh.x, back_shelf_depth, back_shelf_height];
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
