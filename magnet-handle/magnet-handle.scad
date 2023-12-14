diameter = 26;
outer_d = diameter + 3;
ff = 0.01;
$fn = 90;

hull() {
    translate([0, 0, -ff])
        resize(newsize=[outer_d, outer_d, 0]) sphere(r=3);
    
    bh=16;
    translate([0, 0, (bh/-2)-ff])
        cylinder(h=bh, d1=diameter, d2=outer_d, center=true);
}
