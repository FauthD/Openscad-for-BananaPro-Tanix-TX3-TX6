// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

SROOT2=1.414;

V4_Width=17;
V4_Height=6;
V4_SCREW_DIA=6;

module Vesa400ScrewHole()
{
	dept=2*V4_Height;

	rotate([180,0,0])
		ScrewHole(diameter=4, dept=dept, type="Sink_M", extra_sink=0.6);
}

module Vesa400ExtensionBody(len, len1, angle)
{
	w = V4_Width;
	radius = w/2;
	rotate([0,0,angle])
		difference()
		{
			translate([w/2-len/2, 0, 0])
				RoundCornersCube(size=[len, w, V4_Height], r=radius, center=true);

			// Holes for cable binders
			for(n=[1:6])
			{
				translate([-n*35 + 20, 0, 0])
					cube(size=[3.5, 20, 2], center=true);
			}
		}

	translate([len1/2, 0, 0])
		RoundCornersCube(size=[len1, w, V4_Height], r=radius, center=true, corner=[true, true, false, false]);

	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		rotate([0,0,angle+180])
			translate([8, -3, -V4_Height/2 ])
				WriteRevision(rev=SVN_RevisionStr, fontsize=Fontsize, halign="left", mirror=true, oneline=true, rot=[0,0,180]);
	}
}

module Vesa400Extension(vesa_size, angle)
{
	w = V4_Width;
	len=(vesa_size/2-50)*SROOT2 + w;
	screw_x=(vesa_size/2-50);
	len1=100/3 +w/2;
	dept=2*V4_Height;
	translate([-50, 50, V4_Height/2])
	{
		difference()
		{
			Vesa400ExtensionBody(len, len1, angle);

			// screws
			dir = angle/45;
			translate([-screw_x, -screw_x*dir, Epsilon])
				cylinder(d=V4_SCREW_DIA+1, h=dept, center=true);
			translate([0, 0, -V4_Height/2])
				Vesa400ScrewHole();
			translate([len1-w/2, 0, -V4_Height/2])
				Vesa400ScrewHole();
		}
	}
}

// need to print 2 of these (it fits on the ender3)
module Vesa400(vesa_size)
{
	translate([20, -43, V4_Height])
		rotate([0, 180, 10])
			Vesa400Extension(vesa_size, -45);

	translate([59, -8, V4_Height])
		rotate([0, 180, 90])
			Vesa400Extension(vesa_size, 45);

	// bed=205;
	// color("blue", 0.1)
	// 	cube([bed, bed, 2]);
}

module MountVesa400(vesa_size)
{
	translate([0, 0, V4_Height])
		Vesa100();

	for(a=[[0, 0,-45], [-100, 0,45], [0, 180,-45], [100, 180,45]])
	{
		translate([0, a[0], 0])
			rotate([0, 0, a[1]])
				Vesa400Extension(vesa_size, a[2]);
	}
}
