// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

///////////////////////////////////////////////////////////////////////////////
// A wall mount, also suitable for vesa 100

VesaLength = 100+2*5;
VesaWidth = 100;
VesaHeight = 4;

VesaBlockHeight= 5;
VesaHookLength = 6;
VesaHolderDia = 4;
VesaTotalHeight = VesaHeight+4;

VesaMountHoleLenght = 2*VesaHookLength+2;
VesaMountHoleOffset = VesaMountHoleLenght/4 - VesaHolderDia/2;

module VesaBodyMount()
{
	h0=2;

	// sides
	w=10;
	for(y=[-1,1])
	{
		translate([0, y*VesaWidth/2, VesaHeight/2])
		{
			difference()
			{
				RoundCornersCube(size=[VesaLength, w, VesaHeight], r=5, center=true);
				// Holes for cable binders
				for(n=[-1:1])
				{
					translate([n*30, 0, 0])
						cube(size=[3.5, 20, 2], center=true);
				}
			}
		}
	}

	for(x=[-1,1])
	{
		d=2*VesaHookLength-1.5;
		h=VesaBlockHeight;
		// connect left and right
		translate([x*VesaBodyHoles.y/2, 0, h0/2])
			cube(size=[d+2, VesaWidth, h0], center=true);

		for(y=[-1,1])
		{
			translate([x*VesaBodyHoles.y/2, y*VesaBodyHoles.x/2, VesaTotalHeight/2])
			{
				cylinder(d=d, h=VesaTotalHeight, center=true);
				cylinder(d=d+2, h=VesaTotalHeight-1, center=true);
			}
		}
	}

	for(x=[-100,100])
	{
		for(y=[-100,100])
		{
			translate([x/2, y/2, VesaHeight/2])
				cylinder(d=10, h=VesaHeight, center=true);
		}
	}

	VesaMountHooks();

	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		translate([VesaBodyHoles.y/2, 0, h0 ])
			WriteRevision(rev=SVN_RevisionStr,fontsize=Fontsize, halign="center", valign="center", oneline=true, rot=[0,0,90], height=0.4);
	}
}


module VesaMountHole()
{
	h=5;
	d=VesaHolderDia+0.7;

	translate([0, 0, -h/2-BodyInnerDepth/2-BodyThickness/2])
	{
		cylinder(d=VesaHoleDiameter, h=h);
		rotate([0,0,90])
			SlottedHole(d=d, h=h, length=VesaMountHoleLenght);
	}
}

module VesaMountHook()
{
	h=VesaBlockHeight+BodyThickness+0.5;
	thick=2.5;
	d=VesaHolderDia;
	tolerance=0.2;
	translate([0, 0, -h/2+thick+tolerance])
		rotate([0,0,90])
		{
			translate([0, -VesaHookLength/4, -h/2])
				rotate([0,0,90])
					SlottedHole(d=d, h=h, length=VesaHookLength/2);
			len=VesaHookLength -1 ;
			translate([0, 0, -thick/2+h/2])
				RoundCornersCube(size=[d, 2*len, thick], center=true, r=d/2);
			translate([0, len/2, h/2-thick+0.5/2])
				cube(size=[d, len+2, 0.5], center=true);

			// Support. Needs to be cut away after print
			translate([0, len+1/2-0.4, -0.25])
				rotate([-20,0,0])
					cube(size=[d, 0.6, h-1.4*thick], center=true);
		}
}

module VesaHoles()
{
	for(x=[-1,1])
	{
		h=50;
		for(y=[-1,1])
		{
			translate([x*VesaBodyHoles.x/2, y*VesaBodyHoles.y/2 +VesaMountHoleLenght/2 + 0.5, 0])
				VesaMountHole();
		}
	}
}

module VesaMountHooks()
{
	for(x=[-1,1])
	{
		for(y=[-1,1])
		{
			translate([x*VesaBodyHoles.y/2, y*VesaBodyHoles.x/2, VesaTotalHeight+BodyThickness])
				VesaMountHook();
		}
	}
}

module Vesa100()
{
	difference()
	{
		VesaBodyMount();
		for(y=[-100,100])
		{
			d=4.4;
			h=50;
			// holes for wall mount
			for(x=[-100,100])
			{
				translate([x/2, y/2, 0])
					cylinder(d=d, h=h, center=true);
			}
			// holes for a future vesa 400 extension
			for(x=[-100/3,100/3])
			{
				translate([x/2, y/2, 0])
					cylinder(d=d, h=h, center=true);
			}
		}
	}
}

// eof
