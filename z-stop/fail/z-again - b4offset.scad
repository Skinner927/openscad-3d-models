/* Begin suggested config */
total_height = 70; // total screw travel. Outer actual will be a little bigger.
depth = 5; // want to be kinda thick so it doesn't move

// If false, remainder is a small segment on top
// If true, top segment is stretched to fill space.
remainder_fill = true; 

screw_distance = 11;
screw_hole_d = 4.2;

track_length = 18;
track_spacing = 2;
frame_width = 19; // 2020 frame is 20mm wide

offshoot=true;
offshoot_track=11;
offshoot_padding = 3;
offshoot_z_offset = track_length/2 - track_spacing;
offshoot_x_offset = 0;

/* end config */


$fa = 1;
$fs = 0.4;
fudge = 0.001;


panel_segment_height = (track_length + track_spacing);
// -track_spacing because we always put a block of 1 track_spacing at the bottom
normal_panel_count = floor((total_height - track_spacing) / panel_segment_height);
// panel_remainder does not have track_spacing included.
panel_remainder = (total_height - track_spacing) - (normal_panel_count * panel_segment_height) - track_spacing;
min_panel_height = (track_spacing + screw_hole_d) + 0.1;
echo("normal_panel_count", normal_panel_count);
echo("remainder", panel_remainder);
echo("min_panel_height", min_panel_height);

// If there's not enough space for an independent remainder section, we forcefully fill it.
do_remainder_fill = (panel_remainder > min_panel_height) ? remainder_fill : true;
if (do_remainder_fill != remainder_fill) {
    echo("WARNING: Not enough space, forcing remainder_fill = true");
}

/* BEGIN */


union(){
    
    
    
        all_panels();
    
    if (offshoot) {
        #translate([
            ((frame_width/2)+((offshoot_track + offshoot_padding)/2)) + offshoot_x_offset,
            0,
            ((screw_hole_d + offshoot_padding)/2) + offshoot_z_offset
        ]){
            difference() {
                cube([offshoot_track + offshoot_padding, depth, screw_hole_d + offshoot_padding], center=true);
                hull()
                    screw_holes(offshoot_track - screw_hole_d, screw_hole_d, depth, vertical=false);
            }
        }
    }
    
}

module all_panels() {
    // Align btm of all_panels to Z=0
    translate([0, 0, (panel_segment_height/2) + track_spacing])
    union() {
        for(i = [0 : (normal_panel_count - (do_remainder_fill ? 1 : 0))]) {
            translate([0, 0, (panel_segment_height*i)])
                panel();
        }
        if (do_remainder_fill) {
            btm_align = panel_remainder/2 + track_spacing/2;
            remainder_offset = btm_align + (panel_segment_height*normal_panel_count);
            // need to include track_spacing because there would be an extra spacer here
            translate([0, 0, remainder_offset])
                panel(panel_segment_height + panel_remainder);
        }
        else {
            btm_align = -((panel_segment_height/2)-(panel_remainder/2 + track_spacing/2));
            remainder_offset = btm_align + (panel_segment_height*(normal_panel_count+1));
            translate([0, 0, remainder_offset])
                panel(panel_remainder);
        }
        // little extra piece at the bottom
        translate([0, 0, (panel_segment_height/-2) + (track_spacing/-2)])
            cube([frame_width, depth, track_spacing], center=true);
    }
    
}

module panel(want_track_length = track_length) {
    
    new_track_len = want_track_length - screw_hole_d;
    // new_height should be == panel_segment_height with defaults
    new_height = want_track_length + track_spacing;
    mv_down = track_spacing/-2;
    
    difference() {
        cube([frame_width, depth, new_height], center=true);
        
        translate([screw_distance/-2, 0, mv_down])
            hull()
            screw_holes(new_track_len, screw_hole_d, depth, vertical=true);
        translate([screw_distance/2, 0, mv_down])
            hull()
            screw_holes(new_track_len, screw_hole_d, depth, vertical=true);
        
    }
}

module screw_holes(distance, diameter, wall, vertical=true) {
    //translate([0, 0, (switch_height/2) - (switch_screw_hole_d/2) - (wall/2)])
    rotate(vertical ? 90 : 0, [0, 1, 0])
    for (s = [-2:4:2]) {
        translate([distance/s, 0, 0])
        rotate([90, 0, 0])
        cylinder(wall*4, d=diameter, center=true);
    }
}

/*

wall = 3;


frame_screw_distance = 11;
frame_screw_hole_d = 4.2;
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
*/
