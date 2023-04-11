SSD_25_SIZE=[69.85, 100.45, 7];
SSD_25_SCREWS=[61.72, 76.6, 3];
// Holes are asymetric to ssd body.
// I keep the holes symetric to zero, so the body is asymetric.
// Thats easier in usage.
SSD_25_SCREEW_OFFSET=-2.3;	

module SSD_25_Model_Holes()
{
	pos=SSD_25_SCREWS;
	for (y=[-pos[1]/2, pos[1]/2])
	{
		for (x=[-pos[0]/2, pos[0]/2])
		{
			translate([x, y, -2])
				cylinder(d=3, h=SSD_25_SIZE.z, center=true);
		}
		translate([0, y, -3])
			rotate([0,90,0])
				cylinder(d=3, h=2*SSD_25_SIZE.x, center=true);
	}
}

module ySSD_25_Model()
{
	color("SlateGray", 0.8)
		difference()
		{
			translate([0, 0, -SSD_25_SIZE.z/2])
			{
				cube(size=SSD_25_SIZE, center=true);
				color("Black", 0.6)
					translate([-5, Epsilon+7/2-SSD_25_SIZE.y/2, -Epsilon])
						cube(size=[46, 7, SSD_25_SIZE.z], center=true);
			}
			translate([-5, 7/2-SSD_25_SIZE.y/2, -5/2])
				cube(size=[46, 7+Epsilon, 5+Epsilon], center=true);
			SSD_25_Model_Holes();
		}
}

module SSD_25_Model()
{
	color("SlateGray", 0.8)
		difference()
		{
			translate([0, SSD_25_SCREEW_OFFSET, -SSD_25_SIZE.z/2])
			{
				cube(size=SSD_25_SIZE, center=true);
				color("Black", 0.6)
					translate([-5, Epsilon+7/2-SSD_25_SIZE.y/2, -Epsilon])
						cube(size=[46, 7, SSD_25_SIZE.z], center=true);
			}
			translate([-5, SSD_25_SCREEW_OFFSET+7/2-SSD_25_SIZE.y/2, -5/2])
				cube(size=[46, 7+Epsilon, 5+Epsilon], center=true);
			SSD_25_Model_Holes();
		}
}

// M.2 Housings
// Unfortunatly their sizes differ much.

module M2_Model(size)
{
	color("SlateGray", 0.8)
		translate([0,0,-size.z/2])
			cube(size=size, center=true);
}
