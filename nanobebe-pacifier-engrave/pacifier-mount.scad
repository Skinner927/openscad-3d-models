$fn = 180;
fudge = 0.01;

from_center = 22/2;

base_w = 16;
base_d = from_center * 2 + 8;
base_h = 4;

nipple_d = 12+1;
nipple_r = nipple_d/2;
nipple_btm = 14;
nipple_base_w = nipple_d;
nipple_base_d = 6;
nipple_base_h = nipple_btm + nipple_r;

back_w = base_w;
back_d = 3; // arbitrary
back_h = 8;

// back
translate([0, -from_center, back_h/2 - fudge])
cube([base_w, 3, back_h], center=true);


// Debug - verify nipple base position
*color("purple", 0.8)
translate([0, from_center - 3, nipple_btm/2])
cube([nipple_base_w, nipple_base_d, nipple_btm], center=true);

// nipple
translate([0, from_center, (nipple_base_h/2) - fudge])
difference() {
    cube([nipple_base_w, nipple_base_d, nipple_base_h], center=true);
    
    // hole
    translate([0, 0, nipple_base_h/2])
        rotate([90, 0, 0])
        cylinder(nipple_base_d*2, d=nipple_d, center=true);
    
    // flatten hole
    color("green", 0.8)
        translate([0, 0, nipple_base_h-(nipple_r/2)])
        cube([nipple_base_w*2, nipple_base_d*2, nipple_base_h], center=true);
}

// base
color("grey", 1.0)
translate([0, 0, base_h/-2])
difference(){
    cube([base_w, base_d, base_h], center=true);
    
    // Hole to more easily get it off the build plate
    base_hole_d = 7;
    base_hole_hull_offset = base_hole_d/3;
    
    translate([0, -1, 0])
    hull() {
        translate([0, -base_hole_hull_offset, 0])
            cylinder(h=base_h*2, d=base_hole_d, center=true);
        translate([0, base_hole_hull_offset, 0])
            cylinder(h=base_h*2, d=base_hole_d, center=true);
    }
    
}


