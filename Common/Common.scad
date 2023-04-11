
include <./Model_ssd.scad>

ScrewMount=ScrewDiameter+ScrewOffset;
Inner = [BodyInnerLength, BodyInnerWidth + (ScrewDiameter==0 ? 1.7*Radius : 2*ScrewMount), BodyInnerDepth+Emboss];
Thick = [BodyThickness, BodyThickness, BodyThickness+0.2];
Outer = EN_GetOuterSize (Inner, Thick);
Screws = [ScrewDiameter, ScrewType, ScrewOffset];

module SSD_Model()
{
	if(ShowSSDModel)
	{
		if(SSDType=="ssd25")
			translate([SSD_POS.x, SSD_POS.y, -SSD_MOUNT_HEIGHT])
				SSD_25_Model();
		if(SSDType=="ssdm2")
			translate([SSD_POS.x, SSD_POS.y, -SSD_MOUNT_HEIGHT])
				rotate([0, 0, SSD_ROTATION])
		 			M2_Model(M2_SIZE);
		if(SSDType=="ssdm2_asymetric")
			translate([-M2_SIZE.x/2-3, M2_SIZE.y/2-20, 0])		// FIXME: dirt 3 and 20
				translate(M2_Offset)
					M2_Model(M2_SIZE);
	}
}

module RawBody()
{
	EN_RawBody(inner=Inner, thick=Thick, tolerance=GapTolerance, radius=Radius, screws=Screws, screwmount=ScrewMount, under_print=UnderPrint);
}

module RawCover()
{
	translate([0,0,Thick.z/2])
		EN_Cover(inner=Inner, thick=Thick, tolerance=GapTolerance, radius=Radius, screws=Screws, extra_sink=0.4, opening_slit=true);
}

module CableHoles()
{
	dept=BodyInnerLength/2;
	translate([0, BodyInnerLength/2, BodyInnerDepth/2-5])
		rotate([0, 90, 90])
			SlottedHole(d=CableHoleDia, h=dept, length=BodyInnerDepth);
}

module SSD_Holes()
{
}

module SSD_Mounts(dept)
{
	l=3.3+3+3;
	t=2.5;
	h=SSD_25_SCREWS.z+dept+3;
	distance_x=SSD_25_SIZE.x+t;
	distance_y=SSD_25_SCREWS.y;
	pos=[distance_x, distance_y];

	// holders for 2.5" ssd
	for (y=[-pos[1]/2, pos[1]/2])
	{
		difference()
		{
			for (x=[-pos[0]/2, pos[0]/2])
			{
				translate([x, y, -h/2])
					cube(size=[t, l, h], center=true);
			}
			translate([0, y, -(SSD_25_SCREWS.z+dept)])
				rotate([0,90,0])
					cylinder(d=3.5, h=2*distance_y, center=true);
		}
	}
	// distance holder for m.2 housings
	for (y=[-pos[1]/2+8, pos[1]/2])
	{
		for (x=[-7.3, 7.3])
		{
			translate([x, y, -dept/2])
				cube(size=[t, l, dept], center=true);
		}
	}
}

module SSD_Mounts_Diagonal()
{
	t=2;
	air=Tolerance;
	h=M2_SIZE.z+t+air+UnderPrint;
	distance_x=M2_SIZE.x+t+air;
	distance_y=M2_SIZE.y;
	pos=[distance_x, 0.5*distance_y];
	l=0.6*distance_y;
	holder_width=7;
	// holders for M2 ssd
	translate([M2_Offset.x,M2_Offset.y,0])
	{
		for (y=[-pos[1]/2, pos[1]/2])
		{
			for (x=[-pos[0]/2, pos[0]/2])
			{
				translate([x, y, -h/2])
					cube(size=[t, holder_width, h], center=true);

				translate([0, y, -h+t/2])
					cube(size=[distance_x+t, holder_width, t], center=true);
			}
		}
	}
}

module CoverStrainRelieves()
{
	len=16;

	pos=BodyInnerLength;
	for (x=[-30, 0, 30])
	{
		translate([x, -BodyInnerWidth/2-2, 0])
			rotate([180, 0, 0])
				EN_CableMount(len, 4);
	}
	if(SSDType=="ssdm2")
	{
		translate([0, -BodyInnerWidth/4-15, 0])
			rotate([180, 0, 90])
				EN_CableMount(len, 4);
	}
}

module AirHolesCover()
{
	slot=AirSlotWith;
	grid=AirSlotBar;

	w = HoleForHeatSink ? 0.50*BodyInnerWidth-HeatSinkHole.x : 0.45*BodyInnerWidth;
	offset_w = HoleForHeatSink ? -0.42*BodyInnerWidth : -0.27*BodyInnerWidth+1;
	translate([0, offset_w, 0])
		rotate([0,180,90])	
			EN_SlottedAirHoles(0.95*BodyInnerLength, w, slot, grid, BodyThickness/2);

	difference()
	{
		translate([0, 0.27*BodyInnerWidth-1, 0])
			rotate([0,180,90])	
				EN_SlottedAirHoles(0.95*BodyInnerLength, 0.45*BodyInnerWidth, slot, grid, BodyThickness/2);
		translate([M2_Offset.x-M2_SIZE.x/2, M2_Offset.y+BodyInnerWidth/4, BodyThickness])
			cube([M2_SIZE.x+slot, M2_SIZE.y, 3*BodyThickness], center=true);
	}
}

module Cover()
{
	h=13;
	difference()
	{
		union()
		{
			RawCover();

			translate([0, Outer.y/2-BodyThickness/2, -h/2+Thick.z])
				cube(size=[CableHoleDia-2*Tolerance, BodyThickness, h], center=true);

			if(SSDType=="ssdm2_asymetric")
			{
				translate(SSD_POS+M2_Offset)
					SSD_Mounts_Diagonal();
			}
			else
			{
				translate(SSD_POS)
					SSD_Mounts(dept=SSD_MOUNT_HEIGHT);
			}
		}
		translate(SSD_POS)
			SSD_Holes();

		AirHolesCover();

		// A partial cover for the cable opening
		translate([0, BodyInnerWidth/2+3*BodyThickness, -h/1.3])
			rotate([90,0,0])
				cylinder(d=CableHoleDia+Epsilon, h=3*BodyThickness, center=true);

		if(HoleForHeatSink)
		{
			translate([BOARD_POSITION.x+HeatSinkOffset.y, BOARD_POSITION.y+HeatSinkOffset.y, 0])
				cube(size=[HeatSinkHole.x, HeatSinkHole.y, h], center=true);
		}
	}

	CoverStrainRelieves();

	if (ShowSSDModel && (SSDType=="ssdm2"))
		translate(SSD_POS)
			Mount_M2();

	SSD_Model();

	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		color("black")
		{
			translate([1*Fontsize, 4, 0])
				WriteRevision(rev=SVN_RevisionStr, fontsize=Fontsize, halign="right", oneline=true, mirror=true, lib=false);
			translate([1*Fontsize, 4, 0])
				WriteRevision(rev="", fontsize=Fontsize, halign="left", oneline=true, mirror=true);
		}
	}
}

module Body()
{
	difference()
	{
		union()
		{
			RawBody();
			translate(BOARD_POSITION)
			{
				PcbMountScrews();
			}
		}

		translate(BOARD_POSITION)
		{
			BodyHolesForBoard();
		}

		BodyHoles();
		AirHolesBody();
		CableHoles();
		VesaHoles();
	}

	StrainRelieves();

	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		color("black")
			translate([0, 3, -BodyInnerDepth/2 ])
				WriteRevision(rev=SVN_RevisionStr, fontsize=Fontsize, halign="center", oneline=true, rot=[0,0,180]);
	}

	translate(BOARD_POSITION)
	{
		Board_Model();
	}
}

module MountVesa()
{
	translate([0, -VesaMountHoleOffset/2, Outer.z/2 + VesaTotalHeight])
		Body();

	rotate([0,0,90])
		Vesa100();

	// check vertical (if wall mounted) symmetry for body
	color("magenta", 0.5)
		translate([0, Outer.y, 0])
			cube(Outer, center=true);

	// check vertical (if wall mounted) symmetry for vesa
	color("magenta", 0.2)
		cube([100,100, 10], center=true);
}

// M2_SIZE
// SSD_25_SIZE
// SSD_MOUNT_HEIGHT=2;

module SSD_M2_Holder()
{
	screw_dept=15;
	screw_dia=2.4;
	wall=1.0;
	l=3.3+3+3;
	h=M2_SIZE.z+SSD_MOUNT_HEIGHT+wall;
	h2=SSD_25_SCREWS.z+SSD_MOUNT_HEIGHT+screw_dia;
	rotate([180,0,0])
		difference()
		{
			translate([0, 0, h/2])
				cube(size=[SSD_25_SIZE.x, l, h], center=true);

			translate([0, 0, SSD_MOUNT_HEIGHT+3])
				rotate([0,90,0])
					cylinder(d=screw_dia, h=2*SSD_25_SIZE.x, center=true);

			rotate([90,0,0])
				cube(size=[M2_SIZE.x, 2*(M2_SIZE.z+SSD_MOUNT_HEIGHT), 2*l ], center=true);

			a=(SSD_25_SIZE.x-M2_SIZE.x)/2-wall;
			for (x=[-1, 1])
			{
				translate([x*(a/2-SSD_25_SIZE.x/2), 0, h/2+h2])
					cube(size=[a+Epsilon, 2*l, h], center=true);
				translate([x*(a/2-SSD_25_SIZE.x/2+2*wall), -wall, h/2+wall])
					cube(size=[a-4*wall, l, h], center=true);
			}
		}
}

module Print_SSD_M2_Holder()
{
	for (y=[-1, 1])
	{
		translate([0, y*M2_SIZE.z, 0])
			rotate([90,0,0])
				SSD_M2_Holder();
	}
}

// Helpers to make holes
module HoleCube(size, dept=5)
{
	translate([-size[0], dept/4, size[2]])
		cube(size=[size[1], dept, size[3]], center=true);
}

module HoleCubeRound(size, dept=5, r=1)
{
	translate([-size[0], dept/2, size[2]])
		rotate([90,0,0])
			RoundCornersCube(size=[size[1], size[3], dept], center=true, r=r);
}


module HoleCylinder(size, dept=5)
{
	translate([-size[0], dept/4, size[2]])
		rotate([90,0,0])
			cylinder(d=size[1], h=dept, center=true);
}

module HoleHexagon(size, dept=5)
{
	translate([-size[0], dept/4, size[2]])
		rotate([90,90,0])
			cylinder(d=size[1], h=dept, center=true, $fn=6);
}


// Helpers for "mounting" views
module Mount_M2()
{
	l=3.3+3+3;
	pos=SSD_25_SCREWS.y;
	for (y=[-pos/2, pos/2])
	{
		translate([0, y, 0])
			SSD_M2_Holder();
	}
}

module Mount()
{
	Body();

	translate([0,0, BodyInnerDepth/2])
		Cover();
}
