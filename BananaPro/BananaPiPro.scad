// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

use <../dfLibscad/Helpers.scad>
use <../dfLibscad/RoundCornersCube.scad>
use <../dfLibscad/Enclosure.scad>

Epsilon = 0.01;
epsilon = Epsilon;

TOL=1;

////////////////////////////////////
BP_BoardThickness=1.3;
BP_BOARD=[92, 60];

BP_SCREW_HEIGHT=-BP_BoardThickness;
BP_Screw1=[3, -3, BP_SCREW_HEIGHT];
BP_Screw2=[88.5, -8, BP_SCREW_HEIGHT];
BP_Screw3=[88.5, -57, BP_SCREW_HEIGHT];
BP_Screw4=[3, -57, BP_SCREW_HEIGHT];

// center, witdt, center_z, height
BP_ETH=[18.5, 15.94+TOL, 13.3/2+0.4, 13.3+TOL];
BP_USB=[38.5, 13.17+TOL, 14.4/2+1.5, 14.4+TOL];
BP_IR=[50.4, 7, 6, 11];

BP_AUDIO=[21.7, 9, 5/2, 5];

BUTTON_PWR_DIA=8;
BUTTON_PWR_DIA_RING=10;

BP_OTG=[15.13-0.4, 8.1+TOL, 3.6/2-0.4, 3.6+TOL];
BP_Reset=[33.3, 1.5, 1.8];
BP_PWR=[48.5, BUTTON_PWR_DIA+TOL/2, 1.8];
BP_SD=[35-15/2, 12+TOL, -2.3, 2.5];
BP_THINNER=[BP_BOARD[1]/2, BP_BOARD[1]+TOL, 2.3, 11.5];

module BananaPiPro_Model()
{
	color("Blue", 0.5)
		import("../Sizes/BananaPi_Pro.STL", convexity=10);
}

function BananaProBoardSize() = BP_BOARD;

function BananaProAirHoleLimit() = BP_AUDIO[0];

module HolesUsbEth(body_thickness)
{
	dept=5;
	translate([-dept/2, -BP_ETH[0], BP_ETH[2]])
		cube(size=[dept, BP_ETH[1], BP_ETH[3]], center=true);
	translate([-dept/2, -BP_USB[0], BP_USB[2]])
		cube(size=[dept, BP_USB[1], BP_USB[3]], center=true);
	translate([-dept/2, -BP_IR[0], BP_IR[2]])
		rotate([0, 90, 0])
			cylinder(d=BP_IR[1], h=dept, center=true);

	// make wall thinner here for a better mounting tolerance
	translate([-body_thickness/3, -BP_IR[0], BP_IR[2]])
		cube(size=[body_thickness, BP_IR[1], BP_IR[3]], center=true);
}

module HolesOtgButtons(body_inner, body_thickness)
{
	dept=2*body_thickness+Epsilon;
	translate([BP_BOARD[0]+body_thickness, -BP_OTG[0], BP_OTG[2]])
		rotate([0, 90, 0])
			RoundCornersCube(size=[BP_OTG[3], BP_OTG[1], dept], r=1.5, center=true);
	
	// Make a bit room for the connector
	translate([body_inner.x+body_thickness, -BP_OTG[0], BP_OTG[2]])
		rotate([0, 90, 0])
			RoundCornersCube(size=[7, 12, 2*body_thickness], r=2, center=true);

	translate([BP_BOARD[0]+body_thickness, -BP_Reset[0], BP_Reset[2]])
		rotate([0, 90, 0])
		{
			cylinder(d=BP_Reset[1], h=dept, center=true);
			translate([0,0, -body_thickness+0.75])
				RoundCornersCube(size=[3, 5, body_thickness], r=1, center=true);
		}

	translate([BP_BOARD[0]+body_thickness, -BP_PWR[0], BP_PWR[2]])
		rotate([0, 90, 0])
			cylinder(d=BP_PWR[1], h=dept, center=true);
	translate([BP_BOARD[0]+body_thickness/8, -BP_PWR[0], BP_PWR[2]])
		rotate([0, 90, 0])
			cylinder(d=BUTTON_PWR_DIA_RING+2*TOL, h=body_thickness, center=true);
	
	fontsize=5;
	translate([body_inner.x+0.7*body_thickness, -BP_PWR[0], BP_PWR[2] +2 +fontsize])
		rotate([90, 0, 90])
			linear_extrude(height = body_thickness, center = true, convexity = 10)
				text("\u23FB", font="Noto Sans Symbols2", size=fontsize, halign="center");


	translate([BP_BOARD[0]+body_thickness, -BP_SD[0], BP_SD[2]])
	{
		rotate([0, 90, 0])
			RoundCornersCube(size=[BP_SD[3], BP_SD[1], dept], r=1, center=true);
		
		translate(0.45*[BP_SD[1],0,0])
			sphere(d=BP_SD[1]);
	}

	// make wall thinner here for a better mounting tolerance
	// translate([body_inner.x-0.75*body_thickness, -BP_THINNER[0], BP_THINNER[2]])
	// 	rotate([0, 90, 0])
	// 		RoundCornersCube(size=[BP_THINNER[3], BP_THINNER[1], body_thickness/2], r=1.5, center=true);
}

module HoleAudio(body_thickness)
{
	dept=35;
	translate([BP_AUDIO[0], -dept/2-BP_BOARD[1], BP_AUDIO[2]])
		rotate([90, 0, 0])
			cylinder(d=BP_AUDIO[1], h=dept, center=true);
}

module BananaPiProHoles(body_inner, body_thickness)
{
	translate([-BP_BOARD[0]/2, BP_BOARD[1]/2, 0])
	{
		HolesUsbEth(body_thickness);
		HoleAudio(body_thickness);
		HolesOtgButtons(body_inner, body_thickness);
	}
}

module BananaPiProPcbMountScrews(Inner, pcb_screw_dia, pcb_mount_height)
{
	outer_dia = 5.5;
	
	translate([-BP_BOARD[0]/2, BP_BOARD[1]/2, 0])
	{
		translate([BP_Screw1.x, BP_Screw1.y, BP_Screw1.z-pcb_mount_height/2])
			EN_MountingPost(outer_dia, pcb_screw_dia, pcb_mount_height);
		translate([BP_Screw2.x, BP_Screw2.y, BP_Screw2.z-pcb_mount_height/2])
			EN_MountingPost(outer_dia, pcb_screw_dia, pcb_mount_height);
		translate([BP_Screw3.x, BP_Screw3.y, BP_Screw3.z-pcb_mount_height/2])
			EN_MountingPost(outer_dia, pcb_screw_dia, pcb_mount_height);
		translate([BP_Screw4.x, BP_Screw4.y, BP_Screw4.z-pcb_mount_height/2])
			EN_MountingPost(outer_dia, pcb_screw_dia, pcb_mount_height);

		// prevent the sd card from falling into the housing
		translate([Inner.x, BP_SD[1]/2-BP_SD[0], BP_SD[2]-BP_SD[3]+0.7 ])
			rotate([-90,0,180])
				right_triangle([ Inner.x-BP_BOARD[0]+1.5, pcb_mount_height+BP_SD[2], BP_SD[1] ], center=false);
	}
}

module BananaPiProButton(body_thickness)
{
	h=body_thickness+1.3;
	translate([0, 0, h/2])
		cylinder(d=BUTTON_PWR_DIA, h=h, center=true);
	translate([0, 0, body_thickness/8])
		cylinder(d=BUTTON_PWR_DIA_RING, h=body_thickness/4, center=true);
}
