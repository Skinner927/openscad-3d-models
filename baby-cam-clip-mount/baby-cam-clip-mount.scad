

pin_width = 11.5;
pin_height = 10.5;
pin_length = 30;
pin_wall = 2;

base = 70;
base_wall = 2;

intersection(){

difference() {
    union() {
        cube([base, base, base_wall], center=true);
        
        translate([0, 0, -(pin_height + pin_wall + base_wall - 0.01)])
        difference() {
            cube([pin_width + pin_wall, pin_height + pin_wall, pin_length], center=true);
            translate([0, 0, -pin_wall])
            cube([pin_width, pin_height, pin_length], center=true);
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

