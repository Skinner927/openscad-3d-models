// Original https://www.thingiverse.com/thing:468917

width = 165;
length = 140;
height = 40 + 3; // +3 for 6 mount depth - wall_thick
wall_thickness = 3;
//ensure that the edge roundness is greater than the wall thickness
edge_roundness = 4;
tolerance = 0.3;

mount_w = 143;
mount_h = 74;
mount_trans = [(2*(length - mount_h))/3, (width - mount_w)/2, 0];

$fn = 20;

/* [Hidden] */

//ignore!
inner_box_dimentions = [length,width,height];

print_box = true;

if(print_box)
difference(){
union(){
difference ()
{
	hull()
	{
		addOutterCorners(0,0);
		addOutterCorners(1,0);
		addOutterCorners(0,1);
		addOutterCorners(1,1);
	}
	
	translate([0,0,wall_thickness])
	hull()
	{
		addInnerCorners(0,0);
		addInnerCorners(1,0);
		addInnerCorners(0,1);
		addInnerCorners(1,1);
	}

	translate([0,0,inner_box_dimentions[2]+0.1])
	hull()
	{
		addLidCorners(0,0);
		addLidCorners(1,0);
		addLidCorners(0,1);
		addLidCorners(1,1);
	}

	translate([inner_box_dimentions[0]-wall_thickness,0,inner_box_dimentions[2]+0.1])
	cube([wall_thickness,inner_box_dimentions[1],wall_thickness]);
}

    // mount risers
    for (y = [0, mount_w, 0, mount_w]) {
        for (x = [0, 0, mount_h, mount_h]) {
            translate(mount_trans)
                translate([x, y, 0])
                cylinder(h=6, d=8);
           
        }
    }
    
} // /union

    // holes for mount risers
    for (y = [0, mount_w, 0, mount_w]) {
        for (x = [0, 0, mount_h, mount_h]) {
            translate(mount_trans) {
                union() {
                    // Holes
                    translate([x, y, -wall_thickness])
                        cylinder(h=wall_thickness*6, d=2.75);
                    // Nuts
                    translate([x, y, -0.1])
                        cylinder(h=2.5, d=5.9, $fn=6);                    
                }
            }
        }
    }
    
    // holes for mounting whole box
    #translate([20, width/2, -1]) {
        cylinder(h=wall_thickness*3, d=5.75);
        translate([77, 0, 0])
            cylinder(h=wall_thickness*3, d=5.75);
    }
    
} // /difference

if(!print_box)
difference ()
{
	translate([0,inner_box_dimentions[1]+2,0])
	hull()
	{
		Lid(0,0);
		Lid(1,0);
		Lid(0,1);
		Lid(1,1);
	}

	//translate([20,inner_box_dimentions[1]*1.5+2,0])
	//rotate([0,90,0]);

	
}



module addOutterCorners(x = 0, y = 0)
{
	translate([(inner_box_dimentions[0] - edge_roundness*2 + 0.1)*x,(inner_box_dimentions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(inner_box_dimentions[2]+wall_thickness,edge_roundness,edge_roundness);
	
	echo((inner_box_dimentions[0] - edge_roundness)*x);
	echo((inner_box_dimentions[1] - edge_roundness)*y);
}

module addInnerCorners(x = 0, y = 0)
{
	translate([(inner_box_dimentions[0] - edge_roundness*2 + 0.1)*x,(inner_box_dimentions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(inner_box_dimentions[2],edge_roundness-wall_thickness,edge_roundness-wall_thickness);
	
	echo((inner_box_dimentions[0] - edge_roundness)*x);
	echo((inner_box_dimentions[1] - edge_roundness)*y);
}

module addLidCorners(x = 0, y = 0)
{
	translate([(inner_box_dimentions[0] - edge_roundness*2 - 0.1 +wall_thickness)*x,(inner_box_dimentions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(wall_thickness,edge_roundness-wall_thickness+1.5,edge_roundness-wall_thickness+0.5);
	
	echo((inner_box_dimentions[0] - edge_roundness)*x);
	echo((inner_box_dimentions[1] - edge_roundness)*y);
}

module Lid(x = 0, y = 0)
{
	translate([(inner_box_dimentions[0] - edge_roundness*2 - 0.1 +wall_thickness-2)*x,(inner_box_dimentions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(wall_thickness,edge_roundness-wall_thickness+1.5-tolerance,edge_roundness-wall_thickness+0.5-tolerance);
	
	echo((inner_box_dimentions[0] - edge_roundness)*x);
	echo((inner_box_dimentions[1] - edge_roundness)*y);
}
