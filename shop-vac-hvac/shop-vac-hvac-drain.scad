$fn=360;
fudge = 0.1;

wall = 6;
pipe_height = 63; // 2.5" = ~63mm

hose_max = 48; // OD 1 7/8" to mm
hose_min = 43; // 1 3/4"
pvc_max = 28;
pvc_min = 25; // OD pvc 3/4" is 1.05" to mm


pvc_side_connector_length = 38;  // ~1.5"

union() {
    // PVC side
    color("orange", 1.0)
    translate([0, fudge, 0])
    rotate([90, 0, 0])
    difference() {
        cylinder(h=pvc_side_connector_length, d=hose_max+wall);
        translate([0, 0, -fudge])
            cylinder(h=pvc_side_connector_length+fudge+fudge, d1=pvc_min, d2=pvc_max);
    }
    
    translate([-(hose_max+wall), 0, 0])
    union() {
        // Elbow
        color("blue", 0.75)
        rotate_extrude(angle=45)
        translate([hose_max+wall, 0]) 
        difference(){
            circle(d=hose_max+wall);
            circle(d=hose_min);
        }
        
        // Regular tube
        color("green", 1.0)
        rotate([0, 0, 45])
        translate([hose_max+wall, -fudge, 0])
        rotate([-90, 0, 0])
        difference() {
            cylinder(h=pipe_height, d=hose_max+wall);
            translate([0, 0, -fudge])
                cylinder(h=pipe_height+fudge+fudge, d1=hose_min, d2=hose_max);
        }
    }
}
