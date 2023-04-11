// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print and view] */
// Select a part to print
PrintThis = "body"; // ["body", "cover", "button", "boardtest", "mount", "cut", "cutmount", "cutmounty", "cutboard", "cutvesa", "mountvesa400"]

// Currently a dummy
// WhatToPrint = "print"; //  ["print", "view"]

// Currenly only BananaPro is supported
BoardType = "BananaPro"; // ["BananaPro" ]

/* [Sizes] */
BodyInnerLength = 94;
BodyInnerWidth = 144;
BodyInnerDepth = 30;
BodyThickness = 2.4;		//	[1.8:0.2:4]

PcbMountHeight=8;

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

/* [Misc] */
// Slows down a lot
ShowBoardModel=false;
// Moderate speed penalty
ShowSSDModel=false;

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
include <./BoardAdapter.scad>
include <../Vesa/VesaMount.scad>
include <../Vesa/Vesa400.scad>
include <../Common/Common.scad>

AirSlotWith=3.6;
AirSlotBar=3.6;
AirSlotDistance=AirSlotWith+AirSlotBar;

BOARD_POSITION =[0.7, BoardSize()[1]/2-Inner[1]/2 +8, PcbMountHeight+BodyThickness/2-Inner[2]/2];
SSD_POS=[AirSlotDistance, Inner[1]/2-SSD_25_SCREEW_OFFSET-SSD_25_SIZE[1]/2-0.5-8, 0];
SSD_MOUNT_HEIGHT=2;
SSD_ROTATION=0;
SSDType = "ssd25";

module StrainRelieves()
{
	len=20;

	translate([(0), BodyInnerWidth/2-BodyThickness/2, -BodyInnerDepth/2-BodyThickness/4])
		rotate([0, 0, 90])
			EN_CableMount(len, 4);

	// Close the airhole at this position
	translate([0, Outer.y/4, -BodyInnerDepth/2-BodyThickness/2-Emboss])
		cube(size=[2*AirSlotWith, 0.5*BodyInnerWidth, BodyThickness], center=true);
		
	translate([-(BodyInnerLength/2-len/2) +14, 0, -BodyInnerDepth/2-BodyThickness/4])
		EN_CableMount(20, 13);

	translate([-BodyInnerLength/2+AirHoleLimit()+7, -BodyInnerWidth/2-8.5, -BodyThickness/2])
		rotate([-90,90,0])
			EN_CableMount(BodyInnerDepth+BodyThickness, 5);
}

module AirHolesBody()
{
	// below board
	translate([0, -0.3*BodyInnerWidth, -BodyInnerDepth/2])
		rotate([0,0,90])	
			EN_SlottedAirHoles(0.85*BodyInnerLength, 0.45*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2, thinner=true);

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

	// side wall close to 40 pin
	translate([AirHoleLimit()/2, -Outer.y/2+BodyThickness, 0])
		rotate([0,90,90])	
			EN_SlottedAirHoles(0.6*BodyInnerLength, 0.8*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);

	// side wall eth side
	translate([-Outer.x/2+BodyThickness, 28, 0])
		rotate([0,-90,180])	
			EN_SlottedAirHoles(0.6*BodyInnerWidth, 0.8*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);

	// side wall buttons side
	translate([Outer.x/2-BodyThickness, 28, 0])
		rotate([0,-90, 0])	
			EN_SlottedAirHoles(0.6*BodyInnerWidth, 0.8*BodyInnerDepth, AirSlotWith, AirSlotBar, BodyThickness/2);

	// more room for screw heads of ssd
	l=3.3+3+3;
	h=SSD_25_SCREWS.z+SSD_MOUNT_HEIGHT+3;	
	pos=SSD_25_SCREWS.y;
	for (y=[-pos/2, pos/2])
	{
		translate([Outer.x/2-BodyThickness-0.5, y+SSD_POS.y, Inner.z/2-h/2+Emboss])
			cube(size=[BodyThickness, h, h], center=true);
	}
}

module OLD_AirHolesCover()
{
	translate([10.5, -0.27*BodyInnerWidth, 0])
		rotate([0,180,90])	
			EN_SlottedAirHoles(0.6*BodyInnerLength, 0.45*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2);

	translate([10.5, 0.27*BodyInnerWidth, 0])
		rotate([0,180,90])	
			EN_SlottedAirHoles(0.6*BodyInnerLength, 0.45*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2);

	translate([-33, -0.27*BodyInnerWidth, 0])
		rotate([0,180,90])	
			EN_SlottedAirHoles(0.2*BodyInnerLength, 0.45*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2);

	translate([-33, 0.27*BodyInnerWidth, 0])
		rotate([0,180,90])	
			EN_SlottedAirHoles(0.2*BodyInnerLength, 0.45*BodyInnerWidth, AirSlotWith, AirSlotBar, BodyThickness/2);
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

		translate([-20,-80,17.3])
			cube([15,15,5], center=true);

		translate([0,-20,19])
			cube([100,10,10], center=true);
	}
}

module CutMount()
{
	difference()
	{
		Mount();

		translate([0,-60,0])
			cube([130,150,65], center=true);

		// corner and ssd
		translate([Inner.x/2-5, Inner.y/2-5, Inner.z/2-BodyThickness/2+5/2])
			cube([15,30,5], center=true);		
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
// The model seems to be not accurate
module BoardTest()
{
	difference()
	{
		union()
		{
			Body();

		}

		translate([0,0,29])
			cube([100,200,35], center=true);

		translate([0,85,14])
			cube([100,200,35], center=true);
		translate([0,85+4,5])
			cube([100,200,35], center=true);

		translate([0,-169,10])
			cube([100,200,34], center=true);

		translate([0,100-8.7,-5])
			cube([120,200,45], center=true);

		translate([0,-178,-5])
			cube([120,200,45], center=true);

		translate([0,-43,-5])
			cube([70,65,35], center=true);

		translate([0,-60,3])
			cube([74,63,35], center=true);

		translate([50,-60,20])
			cube([70,100,35], center=true);
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

	else if(part == "button")
	{
		Button();
	}
}

