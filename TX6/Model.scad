
module TanixBoard()
{
	difference()
	{
		union()
		{
			// translate([0,0,TX_BOARD.z/2])
			//     color("SteelBlue", 0.1)
			//         cube(size=TX_BOARD, center=true);
			translate([0,0,TX_BoardThickness/2])
				color("DarkBlue", 0.9)
					cube(size=[TX_BOARD.x, TX_BOARD.y, TX_BoardThickness], center=true);
		}

		translate([TX_BOARD.x/2-6.5/2, TX_BOARD.y/2-19.7/2, 0])
			cube(size=[6.5+Epsilon, 19.7+Epsilon, 3*TX_BOARD.z], center=true);

		translate([-TX_BOARD.x/2+4.6/2, TX_BOARD.y/2-10/2, 0])
			cube(size=[4.6+Epsilon, 10+Epsilon, 3*TX_BOARD.z], center=true);

		translate([-TX_BOARD.x/2+10/2, -TX_BOARD.y/2+45/2, 0])
			cube(size=[10+Epsilon, 45+Epsilon, 3*TX_BOARD.z], center=true);}
}

CON_DEPT=12;
module Connector(size, color="Black", trans=0.7, dept=CON_DEPT)
{
	translate([-size[0], -dept/2, size[2]])
		color(color, trans)
			cube(size=[size[1], dept, size[3]], center=true);
}

module Connectors_Model(UsbSize)
{
	TanixBoard();

	translate([TX_BOARD.x/2, TX_BOARD.y/2+1.6, 1.5*TX_BoardThickness])
	{
		Connector(TX_POWER, "Black");
		Connector(TX_HDMI, "Silver");
		Connector(TX_ETH, "DimGray");
		Connector(UsbSize, "Silver");
		Connector(TX_RESET_MODEL, "SlateGray", dept=4);
		Connector(TX_AUDIO, "Black");
	}
}

module Sd(size)
{
	
	dept=15.3;
	rotate([0,0,-90])
		translate([size[0]-TX_BOARD.y/2, -TX_BOARD.x/2+dept/2-3.3, size[2]+1.0*TX_BoardThickness])
		{
			color("silver", 0.7)
				cube(size=[size[1], dept, size[3]], center=true);
			color("black", 0.7)
				translate([size[1]/2-2.5/2, 0,0])
					cube(size=[2.5, dept, size[3]], center=true);
			color("green", 0.7)
				translate([-size[1]/2+1/2, 0,0])
					cube(size=[1, dept, size[3]], center=true);
		}
}

module Display_IR()
{
	
	dept=5.1;
	rotate([0,0,180])
	{
		translate([-TX_BOARD.y/2+TX_DISPLAY[0], TX_BOARD.x/2+dept/2, TX_DISPLAY[2]+1.0*TX_BoardThickness])
			color("White", 0.7)
				cube(size=[TX_DISPLAY[1], dept, TX_DISPLAY[3]], center=true);
		translate([-TX_BOARD.y/2+TX_IR[0], TX_BOARD.x/2+dept/2, TX_IR[2]+1.0*TX_BoardThickness])
			color("Silver", 0.7)
				cube(size=[TX_IR[1], dept, TX_IR[3]], center=true);
	}
}

module Usb3()
{
	dept=15.3;
	rotate([0,0,90])
		translate([+TX_BOARD.y/2-TX_USB3[0], -TX_BOARD.x/2+dept/2-3.3, TX_USB3[2]+1.5*TX_BoardThickness])
			color("silver", 0.7)
				cube(size=[TX_USB3[1], dept, TX_USB3[3]], center=true);
}

module Cpu()
{
	translate([TX_CPU[0]-TX_BOARD.x/2, TX_BOARD.y/2-TX_CPU[0], TX_CPU[4]/2+TX_BoardThickness])
		color("silver", 0.7)
			cube(size=[TX_CPU[1], TX_CPU[3], TX_CPU[4]], center=true);
}

module PcbScrewHoles()
{
	for(y=[-1,1])
	{
		translate([0, y*TX_PcbScrews/2, 0])
		{
			for(x=[-1,1])
			{
				translate([x*TX_PcbScrews/2, 0, 0])
					cylinder(d=2, h=3*TX_BoardThickness, center=true);
			}
		}
	}
}

module TX_Model(UsbSize)
{
	difference()
	{
		translate([0, 3, 0])
		{
			Connectors_Model(UsbSize);
			Sd(TX_SD);
			Display_IR();
			Usb3();
			Cpu();

			// translate([BoardSize().x/2-12, 90/2-14.5/2, 0])
			// 	#cube(size=[2,14.5,10], center=true);

			// translate([BoardSize().x/2-12, -90/2+8.4/2, 0])
			// 	#cube(size=[2,8.4,10], center=true);

			// translate([BoardSize().x/2-11.6/2, -90/2+8.4, 0])
			// 	#cube(size=[11.6,2,10], center=true);

		}

		PcbScrewHoles();
	}
			// translate([BoardSize().x/2-12-TX_PcbScrews, 0, 0])
			// 	#cube(size=[2,TX_PcbScrews,10], center=true);
}

module Board_Model()
{
	if(ShowBoardModel)
	{
		rotate([0,0,90])
			TX_Model((BoardType=="TX6") ? TX6_USB : TX3_USB);
	}
}
