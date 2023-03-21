$fa = 1;
$fs = 0.4;

fudge = 0.01;
wall = 3;


frame_screw_distance = 11;
frame_screw_hole_d = 4;
frame_width = frame_screw_hole_d + wall;
frame_height = 17;

switch_screw_distance = 16; // 11
switch_screw_hull = true;
switch_screw_hole_d = 4;
switch_width = switch_screw_distance + switch_screw_hole_d + wall;
switch_height = frame_height + switch_screw_hole_d + wall;
switch_offset = 18;
switch_padding = 0;

union() {
    switch();
    frame();
}


module frame() {
    
    translate([(frame_width/2) + wall - fudge, wall/-2, frame_height/2])
    
    difference() {    
        // backing
        cube([frame_width, wall, frame_height], center=true);
        // screw holes
        translate([0, 0, (frame_height/2) - (frame_screw_hole_d/2) - (wall/2)])
        !rotate([0, 90, 0])
        for (s = [-2:4:2]) {
            translate([frame_screw_distance/s, 0, 0])
            rotate([90, 0, 0])
            cylinder(wall*4, d=frame_screw_hole_d, center=true);
        }
    }
}

module switch_screws() {
    translate([0, 0, (switch_height/2) - (switch_screw_hole_d/2) - (wall/2)])
    for (s = [-2:4:2]) {
        translate([switch_screw_distance/s, 0, 0])
        rotate([90, 0, 0])
        cylinder(wall*4, d=switch_screw_hole_d, center=true);
    }
}

module switch() {
    translate([0, 0, switch_height/2])
    union() {
        translate([wall/2, (switch_width/-2) - switch_padding + fudge, 0])
        rotate([0, 0, 90])
        difference() {
            // backing
            cube([switch_width, wall, switch_height], center=true);

            // screw holes
            if (switch_screw_hull) {
                hull()
                switch_screws();
            } else {
                switch_screws();
            }
        }

        // padding
        translate([wall/2, switch_padding/-2, 0])
            cube([wall, switch_padding, switch_height], center=true);
    }
}



