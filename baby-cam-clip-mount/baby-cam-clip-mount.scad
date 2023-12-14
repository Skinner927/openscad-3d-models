

pin_width = 11.5;  // shaft's x
pin_depth = 11.5;  // shaft's y
pin_height = 30;   // shaft's z
pin_wall = 2;

base = 70;
base_wall = 2;

intersection(){

difference() {
    union() {
        // deck
        cube([base, base, base_wall], center=true);
        
        //-(pin_wall + base_wall - 0.01)
        translate([0, 0, pin_height/-2])
        difference() {
            // shaft
            cube([pin_width + pin_wall, pin_depth + pin_wall, pin_height], center=true);
            // shaft extrusion (subtrusion?)
            translate([0, 0, -pin_wall])
            cube([pin_width, pin_depth, pin_height], center=true);
        }
    }
    translate([0, (base/2) - 4, 0])
    strip();
    
    translate([0, -((base/2) - 4), 0])
    strip();
    
    translate([(base/2) - 4, 0, 0])
    rotate([0, 0, 90])
    strip();
    
    translate([-((base/2) - 4), 0, 0])
    rotate([0, 0, 90])
    strip();
}
cylinder(h=900, d=base+9, center=true);
}


module strip() {
    cube([(base / 2) - 3, 3, base_wall *2], center=true);
}

