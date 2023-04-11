// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

///////////////////////////////////////////////////////////////////////////////
// Adapter to various boards
use <BananaPiPro.scad>
// add more board includes here

function BoardSize() =
	  (BoardType=="BananaPro") ? BananaProBoardSize()
	// : (BoardType=="BananaXXX") ? BananaProBoardSize()
	: [10,5];

function AirHoleLimit() = 
	  (BoardType=="BananaPro") ? BananaProAirHoleLimit()
	// : (BoardType=="BananaXXX") ? BananaProAirHoleLimit()
	: 0;

module Board_Model()
{
	if(ShowBoardModel)
	{
		if (BoardType=="BananaPro")
		{
			BananaPiPro_Model();
		}
		else if (BoardType=="BananaXXX")
		{
			//BananaPiPro_Model();
		}
	}
}

module BodyHolesForBoard()
{
	if (BoardType=="BananaPro")
	{
		BananaPiProHoles(Inner, BodyThickness);
	}
	else if (BoardType=="BananaXXX")
	{
		//BananaXXXHoles(Inner, BodyThickness);
	}
}

module BodyHoles()
{
}

module PcbMountScrews()
{
	if (BoardType=="BananaPro")
	{
		BananaPiProPcbMountScrews(Inner, pcb_screw_dia=PcbScrewDiameter, pcb_mount_height=PcbMountHeight);
	}
	else if (BoardType=="BananaXXX")
	{
		//BananaXXXPcbMountScrews(Inner, pcb_screw_dia=PcbScrewDiameter, pcb_mount_height=PcbMountHeight);
	}
}

module Button()
{
	if (BoardType=="BananaPro")
	{
		BananaPiProButton(body_thickness=BodyThickness);
	}
	else if (BoardType=="BananaXXX")
	{
		//BananaXXXButton(body_thickness=BodyThickness);
	}
}

///////////////////////////////////////////////////////////////////////////////
// End of Adapter area
///////////////////////////////////////////////////////////////////////////////
