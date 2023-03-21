$fa = 1;
$fs = 0.4;

fudge = 0.001;

wall = 2;
padding = 1;
spacerHeight = 30;
lowerRingOD = 93;
lowerRingHeight = 8;
lipWidth = 6;

cutoutWidth = 28;
cutoutHeight = wall + 1;
cutoutDepth = wall*4;

upperReceiverOD = lowerRingOD + wall + padding;


// Render
rotate([($preview ? 0 : 180), 0, 0])
spacer();

// Remove the "0 &&" for preview and animation
if (0 && $preview) {
    color("purple", 0.5)
        translate([0, 0, spacerHeight + lowerRingHeight + wall + easeInOut(30)])
        spacer();
}

// I'm bad at math
function easeInOut(x) = ((x*2) - ((x*2) * ($t > 0.5 ? $t : (1 - $t))));

module spacer() {
    // tapered spacer
    difference() {
        union(){
            // tapered spacer body
            cylinder(
                h=spacerHeight,
                d1=lowerRingOD, // bottom
                d2=lowerRingOD + wall + padding, // top
                center=false);
            
            // Upper receiver
            color("green", 1.0)
            translate([0, 0, spacerHeight - fudge])
            difference() {
                union() {
                    // top flange
                    translate([0, 0, lowerRingHeight + padding - fudge])
                        cylinder(h=wall, d=upperReceiverOD + lipWidth, center=false);
                    // top receiver
                    ring(
                        h=lowerRingHeight + padding,
                        id=upperReceiverOD - wall,
                        od=upperReceiverOD,
                        center=false);
                }
                // cut out center hole in top
                cylinder(
                    h=lowerRingHeight*3,
                    d=lowerRingOD + padding,
                    center=true);
            }
                
            // bottom flange
            union() {
                cylinder(h=wall, d=lowerRingOD + lipWidth, center=false);
                // chamfer
                translate([0, 0, wall - fudge])
                rotate_extrude()
                    translate([(lowerRingOD/2) - fudge, 0, 0])
                    polygon([
                        [0,0],
                        [lipWidth/2, 0],
                        [0, lipWidth]
                    ]);
            }

            // bottom ring
            color("orange", 1.0)
            translate([0, 0, (-lowerRingHeight) + fudge])
            ring(
                h=lowerRingHeight,
                id=lowerRingOD - wall,
                od=lowerRingOD,
                center=false);
            
        }
        // cut out tapered center through spacer body
        translate([0, 0, -fudge])
            cylinder(
                h=spacerHeight + (fudge*2),
                d1=lowerRingOD - wall, // bottom
                d2=lowerRingOD + padding, // top
                center=false);
        
        // cut out for basket handle        
        translate([(lowerRingOD/2) - (wall*2), 0, 0])
            translate([0, 0, (-spacerHeight) + cutoutHeight])
            linear_extrude(height=spacerHeight, center=false)
            polygon([
                [0, cutoutWidth/-2],
                [cutoutDepth, (cutoutWidth/-2)*1.2],
                [cutoutDepth, (cutoutWidth/2)*1.2],
                [0, cutoutWidth/2]
            ]);
        
    }
}



// height, outer diameter, inner diameter
module ring(h, od, id, center=true) {
    translate([0, 0, center ? 0 : h/2])
    difference() {
        cylinder(h=h, r=od/2, center=true);
        cylinder(h=h*3, r=id/2, center=true);
    }
}
