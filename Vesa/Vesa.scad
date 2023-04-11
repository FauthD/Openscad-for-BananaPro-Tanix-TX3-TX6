// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print and view] */
// Select a part to print
PrintThis = "vesa100"; // ["vesa100", "vesa400", "mountvesa400"]

// Currently a dummy
// WhatToPrint = "print"; //  ["print", "view"]

/* [Sizes] */
BodyThickness = 2.4;		//	[1.8:0.2:4]

// For revision text (0 turns off)
Fontsize=7;	//	[0:1:10]
// For revision text
Emboss=0.3;

VesaBodyHoles = [85, 85];
VesaHoleDiameter = 6.5;
VesaExtensionSize= 400;

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
use <../dfLibscad/SlottedHole.scad>
include <../svn_rev.scad>

TOL=1;
include <VesaMount.scad>
include <Vesa400.scad>

print_part(part=PrintThis);

module print_part(part)
{
//	echo("part=", part);
	
	if(part == "vesa100")
	{
		Vesa100();
	}
	else if(part == "vesa400")
	{
		Vesa400(VesaExtensionSize);
	}
	else if(part == "mountvesa400")
	{
		MountVesa400(VesaExtensionSize);
	}
}

