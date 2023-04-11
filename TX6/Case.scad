// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print and view] */
// Select a part to print
PrintThis = "body"; // ["body", "cover", "m2holder", "boardtest", "mount", "cut", "cutmount", "cutmounty", "cutboard", "cutvesa", "mountvesa400", "model", "model_ssd", "heatsink"]

// Moderate speed penalty
ShowBoardModel=false;
// Moderate speed penalty
ShowSSDModel=false;
ShowModules=false;

/* [Sizes] */
BoardType = "TX6"; // ["TX6", "TX3" ]
SSDType = "ssd25"; // ["ssd25", "ssdm2", "ssdm2_asymetric"]

M2_SIZE=[26, 102, 10];
// Used for asymetric mounting of M2 SSD
M2_Offset=[-16,0,0];

HoleForHeatSink=true;
HeatSinkHole=[58, 29];
HeatSinkOffset=[-4, 4];

BodyInnerLength = 95.7;
BodyInnerWidth = 165;
BodyInnerDepth = 30;
BodyThickness = 2.4;		//	[1.8:0.2:4]

PcbMountHeight=5;

ScrewType="Sink_SelfTab"; // ["Sink_SelfTab", "Sink_M_ManualTab", "Sink_Din7500"]
ScrewDiameter = 2.5;	  // [0,2,2.5,3]
PcbScrewDiameter = 2.0;

// Place screws towards the unside
ScrewOffset = 4.5;	//	[2:0.1:7]
// round the body
Radius=6;	//	[0:1:8]
// Gap between cover and body
GapTolerance=0.09;

// For revision text (0 turns off)
Fontsize=7;	//	[0:1:10]
// For revision text
Emboss=0.3;

CableDoorWidth=20;

CableHoleDia=12;

VesaBodyHoles = [85, 85];
VesaHoleDiameter = 6.5;

/* [Printer] */
// Some printers do not print height enough
UnderPrint = 0.25;	// [0:0.05:0.4]
Tolerance = 0.2;	// [0:0.05:0.4]

/* [Hidden] */

module __Customizer_Limit__ () {}
	shown_by_customizer = false;

png=false;
$fa = png ? 0.25 : $preview ? 2 : 0.25;
$fs = png ? 0.25 : $preview ? 1 : 0.25;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

use <../dfLibscad/Revision.scad>
use <../dfLibscad/Screws.scad>
use <../dfLibscad/RoundCornersCube.scad>
use <../dfLibscad/Enclosure.scad>
use <../dfLibscad/SlottedHole.scad>
include <../svn_rev.scad>

TOL=1;
include <../Vesa/VesaMount.scad>
include <../Common/Common.scad>
include <./Tanix.scad>
include <./Model.scad>
include <./HeatsinkHolder.scad>

ShowHeatsink=ShowModules;

AirSlotWith=3.6;
AirSlotBar=3.6;
AirSlotDistance=AirSlotWith+AirSlotBar;

BOARD_POSITION =[0, BoardSize()[1]/2-Inner[1]/2 +2.2, PcbMountHeight-BodyInnerDepth/2];
SSD_POS=[0, Inner.y/2-SSD_25_SCREEW_OFFSET-SSD_25_SIZE.y/2-0.5, 0];
SSD_POS_ASYMETRIC=[-Inner.x/2+M2_SIZE.x, Inner.y/2-SSD_25_SCREEW_OFFSET-SSD_25_SIZE.y/2-Radius, 0];
SSD_MOUNT_HEIGHT=2;
SSD_ROTATION=0;

module StrainRelieves()
{
	len=20;

	translate([(0), BodyInnerWidth/2-BodyThickness/2, -BodyInnerDepth/2-BodyThickness/4])
		rotate([0, 0, 90])
			EN_CableMount(len, 4);

	// Close the airhole at this position
	translate([0, Outer.y/4, -BodyInnerDepth/2-BodyThickness/2-Emboss])
		cube(size=[2*AirSlotWith, 0.5*BodyInnerWidth, BodyThickness], center=true);
}

module AirHolesSdCardSide()
{
	difference()
	{
		translate([0, -Outer.y/2+BodyThickness, -3])
			rotate([0,90,90])	
				EN_SlottedAirHoles(0.9*BodyInnerLength, 0.7*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);

		// SD
		translate([-BoardSize().x/2+TX_SD[0]-1.5*AirSlotWith, -Inner.y/2, 0])
		{
			cube(size=[TX_SD[1]+AirSlotDistance, 3*BodyThickness, BodyInnerDepth], center=true);
		}
		// Antenna
		translate([-BoardSize().x/2-TX_ANTENNA[0], -Inner.y/2, 0])
		{
			cube(size=[2*TX_ANTENNA[1], 3*BodyThickness, BodyInnerDepth], center=true);
		}
	}

	translate([0, -Outer.y/2+BodyThickness, PcbMountHeight])
		rotate([0,90,90])	
			EN_SlottedAirHoles(0.9*BodyInnerLength, 0.7*BodyInnerDepth-PcbMountHeight, AirSlotWith, AirSlotBar, BodyThickness/2);
}

module AirHolesBody()
{
	// below board
	translate([BOARD_POSITION.x, -0.28*BodyInnerWidth, -BodyInnerDepth/2])
		rotate([0,0,90])	
			EN_SlottedAirHoles(0.9*TX_PcbScrews, 0.5*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2, thinner=true);

	// cable room floor
	translate([0, 0.3*BodyInnerWidth, -BodyInnerDepth/2])
		rotate([0,0,90])	
			EN_SlottedAirHoles(0.85*BodyInnerLength, 0.45*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2);
	
	for (n=[-1,1])
	{
		// side wall "lower side" left/right
		translate([n*BodyInnerLength/4, Outer.y/2-BodyThickness, 0])
			rotate([0,-90,90])	
				EN_SlottedAirHoles(0.35*BodyInnerLength, 0.8*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);
	}

	// side wall at SD-Card
	AirHolesSdCardSide();

	// side wall eth side
	translate([-Outer.x/2+BodyThickness, BodyInnerWidth/4+AirSlotWith, 0])
		rotate([0,-90,180])	
			EN_SlottedAirHoles(0.45*BodyInnerWidth, 0.8*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);

	// side wall display side
	translate([Outer.x/2-BodyThickness, BodyInnerWidth/4-AirSlotDistance, 0])
		rotate([0,-90, 0])	
			EN_SlottedAirHoles(0.6*BodyInnerWidth, 0.8*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);
}

module PcbMountScrews()
{
	TX_PcbMountScrews(Inner, pcb_screw_dia=PcbScrewDiameter, pcb_mount_height=PcbMountHeight);
}

module TX_PcbMountScrews(Inner, pcb_screw_dia, pcb_mount_height)
{
	outer_dia = 5.5;
	height=pcb_mount_height+Emboss;
	for(y=[-1,1])
	{
		translate([0, y*TX_PcbScrews/2, -height/2])
		{
			for(x=[-1,1])
			{
				translate([x*TX_PcbScrews/2, 0, 0])
					EN_MountingPost(outer_dia, pcb_screw_dia, height+Epsilon);
			}
		}
	}
}

module Cut()
{
	difference()
	{
		Mount();

		translate([0,-60,0])
			cube([130,150,65], center=true);
	}
}

module CutBoard()
{
	difference()
	{
		Mount();

		translate([0,-70,0])
			cube([100,70,65], center=true);
	}
}

module CutMountY()
{
	difference()
	{
		Mount();

		translate([50,0,0])
			cube([70,180,65], center=true);

		translate([-50,0,0])
			cube([30,180,65], center=true);

		translate([0,-75,0])
			cube([20,20,65], center=true);
	}
}

module CutMount()
{
	difference()
	{
		Mount();

		translate([0,-93,0])
			cube([130,35,65], center=true);

		translate([40,-88,-12])
			cube([30,35,25], center=true);

		translate([0,-10,19.5])
			cube([100,30,10], center=true);

		translate([Inner.x/2+BodyThickness-Epsilon,-10,0])
			cube([2*BodyThickness,30,40], center=true);

		translate([-(Inner.x/2+BodyThickness-Epsilon),-10,0])
			cube([2*BodyThickness,30,40], center=true);
	}
}

module CutVesa()
{
	difference()
	{
		MountVesa();

		translate([0,-120, Inner.z/2+5])
			cube([130,150, Inner.z], center=true);

		translate([-VesaBodyHoles[0], 50/2+10, Inner.z/2])
			cube([VesaBodyHoles[0], 50, Inner.z], center=true);
	}
}

// For a quick test print whether the board fits well enough
module BoardTest()
{
	difference()
	{
		union()
		{
			Body();

		}
		// make base plate thinner
		translate([0,0, -Outer.z/2-BodyThickness/4])
			cube([2*Outer.x, 2*Outer.y, BodyThickness], center=true);

		// above connectors
		translate([-45,-30,MaxConnectorHeight()-4])
			cube([20,100,20], center=true);

		// upper limit at display side
		translate([10,0,15])
			cube([110,200,21], center=true);

		// cable room
		translate([2,102,0])
			cube([110,200,40], center=true);
		
		// upper limt at sd-card side
		translate([0,-Inner.y+15,14.5])
			cube([Outer.x+Epsilon,Inner.y,Outer.z], center=true);

		// remove inner floor 1
		translate([0,-Inner.y/4+2,-BodyInnerDepth/2-BodyThickness])
			cube([94,60,5], center=true);

		// remove inner floor 2
		translate([0,-Inner.y/4,-BodyInnerDepth/2-BodyThickness])
			cube([55,86,5], center=true);

		// remove rev text (only some rests)
		translate([-2,10,2-BodyInnerDepth/2])
			cube([60,25,5], center=true);

		// between sd-cad and antenna
		translate([14,-Inner.y/2,-4.5])
			cube([34,20,22], center=true);
		// corner at antenna
		translate([54.8,-Inner.y/2,-4.5])
			cube([28,40,22], center=true);
		// corner sd-card/audio
		translate([-39,-Inner.y/2-2.5,-4.5])
			cube([30,20,22], center=true);

		// close of display
		translate([55,0,-4.5])
			cube([28,37,22], center=true);
	}
}

print_part(part=PrintThis);

module print_part(part)
{
// 	echo("part=", part);
	
	if(part == "cutvesa")
	{
		CutVesa();
	}

	else if(part == "cutmount")
	{
		CutMount();
	}

	else if(part == "cutmounty")
	{
		CutMountY();
	}

	else if(part == "cutboard")
	{
		CutBoard();
	}

	else if(part == "cut")
	{
		Cut();
	}

	else if(part == "boardtest")
	{
		BoardTest();
	}

	else if(part == "mount")
	{
		Mount();
	}

	else if(part == "body")
	{
		Body();
	}

	else if(part == "cover")
	{
		rotate([0,180,0])
			Cover();
	}

	else if(part == "m2holder")
	{
		Print_SSD_M2_Holder();
	}
	else if(part == "model")
	{
		Board_Model();
	}
	else if(part == "model_ssd")
	{
		SSD_Model();
	}
	else if(part== "heatsink")
	{
		HeatsinkHolder();
	}
}


