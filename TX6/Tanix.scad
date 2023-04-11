// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

use <../dfLibscad/Helpers.scad>
use <../dfLibscad/RoundCornersCube.scad>
use <../dfLibscad/Enclosure.scad>

// Epsilon = 0.01;
// epsilon = Epsilon;

// TOL=1;

////////////////////////////////////
TX_BoardThickness=1.0;
TX_BOARD=[90,90,9];

TX_PcbScrews=69.4-2;

// center, witdt, center_z, height
TX_POWER=[11.5-7.2/2, 7.1+TOL, 9.5/2, 9.5+TOL];
TX_HDMI=[11.5+5+15/2, 15+TOL, 7/2, 6+TOL];
TX_ETH=[51.25-14.3/2, 14.3+TOL, 11.9/2-3.2, 11.4+TOL];
TX6_USB=[73-14.4/2-1.25, 14.4+TOL, 8/2+0.5, 7.5+TOL];
TX3_USB=[73-14.4/2-1.25, 14.4+TOL, 15.2/2-4.2, 15.2+TOL];
TX_RESET=[83-6.5-5/2, 2, 2.3, 2];
TX_RESET_MODEL=[83-5-5/2, 5, 2.3, 5];
TX_AUDIO=[82-5/2, 6+TOL, 4.5/2, 4+TOL];

TX_SD=[44.7-2-13.5/2, 13.5+TOL, 2.2/2+0.2, 2.2];

TX_DISPLAY=[56.5-24.2/2, 24.2, 10.5/2, 10.5];
TX_IR=[63, 8, 9/2, 9];
TX_Glas=[59-24.2/2, 46+0.3, 10.5/2, 14+0.3, 0.7];
TX_ANTENNA=[6-TX_BOARD.x, 6.7, 1, 6.7];

TX_USB3=[40-14.4/2, 14.4+TOL, 7.2/2, 7.5+TOL];

TX_CPU=[50, 25, 45, 25, 7];

TX_THINNER=[TX_BOARD[1]/2, TX_BOARD[1]+TOL, 2.3, 11.5];

function BoardSize() = [TX_BOARD[0], TX_BOARD[1]];

function UsbSize() = (BoardType=="TX6") ? TX6_USB : TX3_USB;

function UpperCon(con) = con[2]+con[3]/2;
function LowerCon(con) = con[2]-con[3]/2;

function MaxConnectorHeight() =
	max(UpperCon(TX_ETH), UpperCon(UsbSize()), UpperCon(TX_POWER) )
	+ PcbMountHeight + TX_BoardThickness;

function MinConnectorHeight() =
	min(LowerCon(TX_ETH), LowerCon(UsbSize()) )
	+ PcbMountHeight + TX_BoardThickness;


module HolesConnectors(body_inner, body_thickness)
{
	translate([-body_inner.x/2, 0, 0])
	{
		rotate([0,0,90])
		{
			HoleCube(TX_POWER);
			HoleCube(TX_HDMI);
			HoleCube(TX_ETH);
			HoleCube(UsbSize());
			HoleCylinder(TX_RESET);
			HoleCube(TX_AUDIO);
		}

	// make wall thinner here for a better mounting tolerance
	h=8*TX_BoardThickness;
	translate([+body_thickness/8, -BoardSize().y/2+4, 0])
		cube(size=[body_thickness, BoardSize().y, h], center=true);
	}
}

module HolesDisplay(body_inner, body_thickness)
{
	translate([body_inner.x/2+body_thickness, 0, 0])
		rotate([0,0,90])
		{
			HoleCube(TX_DISPLAY);
			HoleCylinder(TX_IR);
		}
}

module HoleSd(body_inner, body_thickness)
{
	dept=6;
	translate([TX_SD[0]-body_inner.x/2-1.6/(2), -dept/2-body_inner.y/2-Epsilon+0.7, TX_SD[2]])	// FIXME: why the -5?
	{
		rotate([0, 90, 90])
			RoundCornersCube(size=[TX_SD[3], TX_SD[1]-1.6, dept], r=1, center=true);
		
			cube(size=[TX_SD[1]+3, 1.35*body_thickness, TX_SD[3]+1], center=true);
	}
}

module HoleAntenna(body_thickness)
{
	translate([-Inner.x/2, -Inner.y/2-2*body_thickness, -BodyInnerDepth/2+5])
	{
		HoleCylinder(TX_ANTENNA, dept=3*body_thickness);
		translate([0, 2*body_thickness, 0])
			HoleHexagon([TX_ANTENNA[0], 10, TX_ANTENNA[2]], dept=body_thickness+Epsilon);
	}
}


module HolesDisplayGlas(body_inner, body_thickness)
{
	translate([body_inner.x/2+body_thickness+Epsilon, TX_Glas[0]-TX_BOARD[1]/2-1, 0])
		rotate([0,0,90])
		{
			HoleCubeRound(TX_Glas, dept=TX_Glas[4], r=2);
		}
}

module TX_Holes(body_inner, body_thickness)
{
	translate([0, TX_BOARD[1]/2, TX_BoardThickness])
	{
		HolesConnectors(body_inner, body_thickness);
		HolesDisplay(body_inner, body_thickness);
		HoleSd(body_inner, body_thickness);
		HolesDisplayGlas(body_inner, body_thickness);
	}
}

module BodyHolesForBoard()
{
	TX_Holes(Inner, BodyThickness);
}

module BodyHoles()
{
	HoleAntenna(BodyThickness);
}