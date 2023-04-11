// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

Clearance=7.8;
StandoffWidth=6.3;
StandoffRadius=2.0;
GantryOffset=1.5;
GantryWidth=StandoffWidth+GantryOffset;
GantryHight=5.5;

HeatsinkHeight=4.8;
HeatsinkSlotWidth=6.0;
HeatsinkLength=23;
SocOffsetX=4;
SocOffsetY=3.9;
SocHeight=1;

HeatsinkTop=SocHeight+HeatsinkHeight;
PlungerHeight=Clearance-HeatsinkTop;

module HeatsinkHolder()
{
	translate([0,0,ShowHeatsink ? 0:Clearance+HeatsinkHeight])
		rotate([ShowHeatsink ? 0:180,0,0])	// upside down for printing
			HeatsinkHolderInternal();
}

module HeatsinkHolderInternal()
{
	difference()
	{
		union()
		{
			Standoffs();
			Gantry();
			Plunger();
		}
		HeatsinkScrewHoles();
		SpaceForResistor();
	}
	Heatsink();
	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		fontsize=Fontsize*0.7;
		color("black")
		{
			translate([-fontsize/2-TX_PcbScrews/2+0.5, 0, Clearance])
				WriteRevision(rev=SVN_RevisionStr, fontsize=fontsize, halign="center", oneline=true, mirror=true, rot=[0,0,90]);
		}
	}
}

module Plunger()
{
	w=HeatsinkSlotWidth-0.3;
	h=GantryHight+PlungerHeight-0.2;
	length=TX_PcbScrews+StandoffWidth;
	difference()
	{
		translate([0, -SocOffsetY, Clearance+GantryHight-h/2])
		{
			cube([length, w, h], center=true);
		}

		for(y=[-1,1])
		{
			translate([SocOffsetX+y*9/2,-SocOffsetY,0])
				cylinder(d=2.8, h=5*Clearance, center=true);
		}
	}
}

module Gantry()
{
	w=StandoffWidth;
	h=GantryHight;
	length=TX_PcbScrews+StandoffWidth;
	o=GantryOffset;

	translate([0, -TX_PcbScrews/2-1/2, Clearance+h/2])
		RoundCornersCube([length, w-1, h], center=true, r=StandoffWidth/2);
	translate([0, TX_PcbScrews/2+w/2-10-1/2, Clearance+h/2])
		RoundCornersCube([length, w-1, h], center=true, r=StandoffWidth/2);

	for(x=[-1,1])
	{
		translate([x*(TX_PcbScrews/2-o/2), 0, Clearance+h/2])
			RoundCornersCube([GantryWidth, length, h], center=true, r=StandoffWidth/2);
	}
}

module Standoffs()
{
	pcb_screw_dia=3;
	height=Clearance+GantryHight;
	for(y=[-1,1])
	{
		translate([0, y*TX_PcbScrews/2, +height/2])
		{
			for(x=[-1,1])
			{
				translate([x*TX_PcbScrews/2, 0, 0])
					RoundCornersCube([StandoffWidth, StandoffWidth,height], center=true, r=StandoffRadius);
			}
		}
	}
}

module HeatsinkScrewHoles()
{
	pcb_screw_dia=2.6;
	for(y=[-1,1])
	{
		translate([0, y*TX_PcbScrews/2, 0])
		{
			for(x=[-1,1])
			{
				translate([x*TX_PcbScrews/2, 0, 0])
				{
					cylinder(d=pcb_screw_dia, h=10*Clearance, center=true);
				}
			}
		}
	}
}

module SpaceForResistor()
{
	translate([TX_PcbScrews/2, TX_PcbScrews/2+StandoffWidth/2,0])
		rotate([0,90,0])
			cylinder(d=3, h=5*StandoffWidth, center=true);
}

module Heatsink()
{
	l=23;
	w=53.4;
	h=45;
	if(ShowHeatsink)
	{
		color("black", 0.5)
		{
			translate([SocOffsetX, -SocOffsetY, h/2+SocHeight])
			difference()
			{
				cube([HeatsinkLength-Epsilon, w, h], center=true);
				for(y=[0, 1,2, -1,-2])
				{
					translate([0, y*(HeatsinkSlotWidth+4.4), HeatsinkHeight])
						cube([HeatsinkLength+Epsilon, HeatsinkSlotWidth+0.4, h], center=true);
				}
			}
		}
	}
}