// Total screw travel. Actual outer height will be larger because I dumb.
total_height = 70; 
// Want to be kinda thick so it doesn't move.
depth = 5; 

// false = small segment on top; true = top segment stretched to fill.
remainder_fill = true; 

// distance between centers of screws for z-stop pcb.
screw_distance = 11;
// diameter of pcb screws.
screw_hole_d = 4.2;

// Length of the screw tracks for each segment.
track_length = 18;
// Vertical spacing between segments.
track_spacing = 2;
// 2020 frame is 20mm wide.
frame_width = 19; 

/*[offshoot 1]*/
offshoot1=true;
offshoot1_color="green";
offshoot1_track=13;
offshoot1_padding = 3;
offshoot1_flare = 4;
offshoot1_z_offset = 10;
offshoot1_x_offset = 0;

/*[offshoot 2]*/
offshoot2=true;
offshoot2_color="blue";
offshoot2_track=8;
offshoot2_padding = 3;
offshoot2_flare = 4;
offshoot2_z_offset = 40;
offshoot2_x_offset = 5;

/* end config */
module _end_config_() { echo(""); }

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

/* MODEL */

union(){
    all_panels();
    
    if (offshoot1) {
        color(offshoot1_color, 1.0)
            offshoot(offshoot1_track, offshoot1_padding, offshoot1_flare, offshoot1_z_offset, offshoot1_x_offset);
    }
    if (offshoot2) {
        color(offshoot2_color, 1.0)
            offshoot(offshoot2_track, offshoot2_padding, offshoot2_flare, offshoot2_z_offset, offshoot2_x_offset);
    }
}


/* MODULES */

module offshoot(track, padding, flare, z_offset, x_offset) {
    bounding_width = track + screw_hole_d + padding + x_offset;
    bounding_height = screw_hole_d + padding;
    
    trans_x = (bounding_width/2) + (frame_width/2);
    translate([trans_x, 0, z_offset])
    difference() {
        hull() {
            hull()
                screw_holes(track, screw_hole_d + padding, depth, vertical=false, wall_multiplier=1);
            
            flare_fudge = 0.1;
            translate([(bounding_width/-2) - 0.5 - flare_fudge, 0, 0])
                cube([1, depth, bounding_height+flare], center=true);
        }
        
        hull()
            screw_holes(track, screw_hole_d, depth, vertical=false);
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

module screw_holes(distance, diameter, wall, vertical=true, wall_multiplier=4) {
    //translate([0, 0, (switch_height/2) - (switch_screw_hole_d/2) - (wall/2)])
    rotate(vertical ? 90 : 0, [0, 1, 0])
    for (s = [-2:4:2]) {
        translate([distance/s, 0, 0])
        rotate([90, 0, 0])
        cylinder(wall*wall_multiplier, d=diameter, center=true);
    }
}
