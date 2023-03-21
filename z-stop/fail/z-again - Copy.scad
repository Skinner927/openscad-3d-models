$fa = 1;
$fs = 0.4;

fudge = 0.01;
wall = 3;


frame_screw_distance = 11;
frame_screw_hole_d = 4;
frame_width = max(17, frame_screw_hole_d + wall); // 2020 frame is 20mm wide
frame_height = frame_screw_distance + frame_screw_hole_d + wall;

switch_screw_distance = 11;
switch_screw_hole_d = 4;
switch_width = max(17, switch_screw_distance + switch_screw_hole_d + wall);
switch_height = 67; // total outside, screw guides will be smaller
switch_extra_width = wall*2; // for support
switch_screw_offset_bottom = wall;

switch_screw_guide_length = switch_height - wall - switch_screw_hole_d - switch_screw_offset_bottom;


union() {
    // frame
    translate([switch_width/2 + frame_width/2, 0, 0])
    difference() {
        cube([frame_width, wall, frame_height], center=true);
        
        screw_holes(frame_screw_distance, frame_screw_hole_d, vertical=true);
    }


    // vert
    translate([0, 0, switch_height/2 - frame_height/2])    
    difference() {
        cube([switch_width + switch_extra_width, wall, switch_height], center=true);
        
        for (v = [-1:2:1]) {
            translate([(switch_screw_distance / 2) * v, 0, switch_screw_offset_bottom/2])
            hull()
            screw_holes(switch_screw_guide_length, switch_screw_hole_d, vertical=true);
        }
    }
    
}

module screw_holes(distance, diameter, vertical=true) {
    //translate([0, 0, (switch_height/2) - (switch_screw_hole_d/2) - (wall/2)])
    rotate(vertical ? 90 : 0, [0, 1, 0])
    for (s = [-2:4:2]) {
        translate([distance/s, 0, 0])
        rotate([90, 0, 0])
        cylinder(wall*4, d=diameter, center=true);
    }
}
