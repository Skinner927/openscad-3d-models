$fa = 1;
$fs = 0.4;

fudge = 0.1;
wall = 3;


frame_screw_distance = 15;
frame_screw_hole_d = 4;
frame_width = 18;
frame_height = 30;

switch_screw_distance = 11;
switch_screw_hole_d = 4;
switch_width = 17;
switch_height = 30;
switch_depth = 18;

switch_carriage();


module switch_carriage() {
    
    bottom_block_depth = switch_depth - wall;
    bottom_block_height = switch_screw_hole_d*2;
    
    difference() {
        
        union() {
            // back plate
            translate([0, wall/2, 0])
            cube([switch_width, wall, switch_height], center=true);
            
            // bottom block
            translate([
                0,
                (bottom_block_depth/-2) + fudge,
                (switch_height/-2) + (bottom_block_height/2)
            ])
            cube([switch_width, bottom_block_depth, bottom_block_height], center=true);
    
        }
        
        // top screw holes
        translate([0, wall, switch_height/3])
            for (s = [-2:4:2]) {
                translate([switch_screw_distance/s, 0, 0])
                rotate([90, 0, 0])
                cylinder(wall*4, d=switch_screw_hole_d, center=true);
            }

    }
    
    
}


