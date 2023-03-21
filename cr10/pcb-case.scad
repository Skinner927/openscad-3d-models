screw = 4.2;

$fn= $preview ? 32 : 64;

difference() {
    import("orig-pcb-case.stl");
    
    translate([-250, -250, 12])
    cube(500, center=false);
    
    
    translate([0, -20, 0]){
        translate([-50, 0, 0])
        cylinder(h=10, d=screw, center=true);
        
        translate([50, 0, 0])
        cylinder(h=10, d=screw, center=true);
    }
    
}


