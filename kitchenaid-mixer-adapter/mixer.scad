base_d = 16+6+6+6;
base_h = 20;

shaft_d = 13.3;

peg_d = 6.41 + 0.8;
peg_l = 14.32; // from 0,0 not edge of shaft



difference() {
    // Mount body
    translate([0, 0, -base_h]) {                
        // mount outer cylinder
        cylinder(h=base_h, d=base_d);
        
        // hook's shaft
        mid_cyl_h = 20;
        translate([0, 0, -mid_cyl_h]) {
            cylinder(d=shaft_d + 8, h=mid_cyl_h + 0.1);
            cyl_cap_h = 5;
            translate([0, 0, -cyl_cap_h]) {
            cylinder(d=base_d, h=cyl_cap_h + 0.1);
            }
        }
    }
    // shaft
    shaft_h = 30;
    translate([0, 0, -shaft_h])
        cylinder(h=shaft_h+1, d=shaft_d);
    
    // peg vert slot
    pvs = 16.45;
    translate([0, peg_d/-2, -pvs])
        cube([peg_l, peg_d, pvs+1]);
    
    // peg rotate window
    pls_o = 4;
    pls = pvs - pls_o;
    translate([0, peg_l*-2, -pvs])
        cube([peg_l, peg_l*2, peg_d+1]);
    
    // peg lock slot
    translate([peg_d/-2, peg_l*-2, -pvs])
        cube([peg_d, peg_l*2, pvs-pls_o]);
}
