#define GW_VHUD_ID 12002
#define GW_VHUD_TITLE_ID 12002

#define GW_HUD_ID 10000
#define GW_HUD_STATUS_ID 10001

#define GW_BUTTON_WIDTH 0.15
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define STATUS_X ((( 1 - GW_BUTTON_WIDTH ) - (GW_BUTTON_GAP_X * 6)) + 0.0047)
#define STATUS_Y 0.788

#define WEAPONS_X 0.28
#define WEAPONS_Y 0.26

#define TITLE_X 0.5
#define TITLE_Y 0.17

#define CT_PROGRESS 8

class GW_ProgressBar {
	access = 0;
	type = CT_PROGRESS;
	style = ST_CENTER;
	colorFrame[] = {0,0,0,0};
	colorBar[] = {0,0,0,0.5};
	shadow = 2;
	texture = "#(argb,8,8,3)color(1,1,1,1)";	
};

// Menu
class GW_HUD_Vehicle
{
	idd = -1;
	name = "GW_HUD_Vehicle";
	movingEnabled = true;
	enableSimulation = true;	

	duration = 1e+1000; 
	fadeIn = 0.1; 
	fadeOut = 0.1; 
	onLoad = "uiNamespace setVariable ['GW_HUD_Vehicle', _this select 0]; ";

	class controlsBackground
	{
		class StatusBackgroundA : GW_Block
		{

			idc = 12001;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT) - (GW_BUTTON_GAP_Y)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class ProgressBarA : GW_ProgressBar
		{
			idc = 13001;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT) - (GW_BUTTON_GAP_Y)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};

		class IconA : GW_StructuredTextBox
		{
			idc = 14001;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT) - (GW_BUTTON_GAP_Y)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};	

		class StatusBackgroundB : GW_Block
		{
			idc = 12002;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 2) - (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class ProgressBarB : GW_ProgressBar
		{
			idc = 13002;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 2) - (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconB : GW_StructuredTextBox
		{
			idc = 14002;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 2) - (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};	

		class StatusBackgroundC : GW_Block
		{
			idc = 12003;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 3) - (GW_BUTTON_GAP_Y * 3)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class ProgressBarC : GW_ProgressBar
		{
			idc = 13003;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 3) - (GW_BUTTON_GAP_Y * 3)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconC : GW_StructuredTextBox
		{
			idc = 14003;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 3) - (GW_BUTTON_GAP_Y * 3)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};	

		class StatusBackgroundD : GW_Block
		{
			idc = 12004;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 4) - (GW_BUTTON_GAP_Y * 4)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class ProgressBarD : GW_ProgressBar
		{
			idc = 13004;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 4) - (GW_BUTTON_GAP_Y * 4)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconD : GW_StructuredTextBox
		{
			idc = 14004;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 4) - (GW_BUTTON_GAP_Y * 4)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};

		class StatusBackgroundE : GW_Block
		{
			idc = 12005;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 5) - (GW_BUTTON_GAP_Y * 5)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};

		class ProgressBarE : GW_ProgressBar
		{
			idc = 13005;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 5) - (GW_BUTTON_GAP_Y * 5)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconE : GW_StructuredTextBox
		{
			idc = 14005;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 5) - (GW_BUTTON_GAP_Y * 5)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};

		class StatusBackgroundF : GW_Block
		{
			idc = 12006;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 6) - (GW_BUTTON_GAP_Y * 6)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};

		class ProgressBarF : GW_ProgressBar
		{
			idc = 13006;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 6) - (GW_BUTTON_GAP_Y * 6)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconF : GW_StructuredTextBox
		{
			idc = 14006;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 6) - (GW_BUTTON_GAP_Y * 6)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};

		class StatusBackgroundG : GW_Block
		{
			idc = 12007;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 7) - (GW_BUTTON_GAP_Y * 7)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};

		class ProgressBarG : GW_ProgressBar
		{
			idc = 13007;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 7) - (GW_BUTTON_GAP_Y * 7)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconG : GW_StructuredTextBox
		{
			idc = 14007;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 7) - (GW_BUTTON_GAP_Y * 7)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};

		class StatusBackgroundH : GW_Block
		{
			idc = 12008;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 8) - (GW_BUTTON_GAP_Y * 8)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};

		class ProgressBarH : GW_ProgressBar
		{
			idc = 13008;
			fade = 1;
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 8) - (GW_BUTTON_GAP_Y * 8)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;
		};	

		class IconH : GW_StructuredTextBox
		{
			idc = 14008;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y - (GW_BUTTON_HEIGHT * 8) - (GW_BUTTON_GAP_Y * 8)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};


	};

	class controls {		

		class VehicleHealth : GW_StructuredTextBox
		{
			idc = 12013;
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (STATUS_X + 0.012) * safezoneW + safezoneX;
			y = (STATUS_Y + 0.01) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH) - (GW_BUTTON_GAP_X /2) )* safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};

		class VehicleMoney : GW_StructuredTextBox
		{
			idc = 12015;
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + 0.01) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH) - (GW_BUTTON_GAP_X /2) )* safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};

		class VehiclePicture : GW_StructuredTextBox
		{
			access = 0;
			idc = 12010;
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + 0.02) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 3) * safezoneH;

			align = "center";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};



			text = "";
		};	
		

		class VehicleFuel : GW_StructuredTextBox
		{
			idc = 12011;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + (GW_BUTTON_HEIGHT * 3) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH / 2) - (GW_BUTTON_GAP_X) )* safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";

		};	

		class VehicleAmmo : GW_StructuredTextBox
		{
			idc = 12012;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X + ((GW_BUTTON_WIDTH / 2) - (GW_BUTTON_GAP_X /2)) + (GW_BUTTON_GAP_X/2) ) * safezoneW + safezoneX;
			y = (STATUS_Y + (GW_BUTTON_HEIGHT * 3) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH / 2) - (GW_BUTTON_GAP_X / 2) )* safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";

		};

		

		class VehicleStatus : GW_StructuredTextBox
		{
			access = 0;
			idc = 12014;
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + (GW_BUTTON_HEIGHT * 1.5) - (GW_BUTTON_HEIGHT * 0.6) )  * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 1.2) * safezoneH;

			align = "center";

			size = "0.03";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};

			text = "";
		};

		class Money : GW_StructuredTextBox
		{
			idc = 12016;
			fade = 1;
			colorBackground[] = {0,0,0,0.25};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + (GW_BUTTON_HEIGHT * 4) + (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH)* safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";

		};		

		class VehicleNotification : GW_StructuredTextBox
		{
			access = 0;
			idc = 12017;
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0.15
			};

			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 3) * safezoneH;

			align = "center";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};

			text = "";
		};

		class VehicleHorn : GW_StructuredTextBox
		{
			idc = 12018;
			fade = 1;
			colorBackground[] = {0,0,0,0};
			x = (0.85) * safezoneW + safezoneX;
			y = (0.02) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 6) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 2) * safezoneH;

			text = "TEST";
		};

	};

};

// Menu
class GW_HUD
{
	idd = -1;
	name = "GW_HUD";
	movingEnabled = true;
	enableSimulation = true;	

	duration = 1e+1000; 
	fadeIn = 0; 
	fadeOut = 0; 
	onLoad = "uiNamespace setVariable ['GW_HUD', _this select 0]";

	class controlsBackground
	{
		
		class StatusBlock : GW_Block
		{
			idc = 11000;
			fade = 1;
			colorBackground[] = {0,0,0,0};
			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 3) * safezoneH;
		};		

	};

	class controls {		


		class StripesTopLeft : GW_StructuredTextBox
		{
			idc = 10021;
			fade = 1;
			colorBackground[] = {0,0,0,0};
			x = (- 0.03) * safezoneW + safezoneX;
			y = (- 0.03) * safezoneH + safezoneY;
			w = (0.22) * safezoneW;
			h = (0.12) * safezoneH;

			size = "1";

			text = "<img size='0.33' align='center' image='client\images\stripes_fade_grey_topleft.paa' />";
		};	

		class StripesBottomRight : GW_StructuredTextBox
		{
			idc = 10022;
			fade = 1;
			colorBackground[] = {0,0,0,0};
			x = (STATUS_X - 0.042) * safezoneW + safezoneX;
			y = (STATUS_Y + 0.045) * safezoneH + safezoneY;
			w = (0.22)  * safezoneW;
			h =  (0.3) * safezoneH;

			size = "1";

			text = "<img size='0.33' align='center' image='client\images\stripes_fade_grey_bottomright.paa' />";
		};	

		class Money : GW_StructuredTextBox
		{
			access = 0;
			idc = GW_HUD_STATUS_ID;
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + (GW_BUTTON_HEIGHT * 3) - (GW_BUTTON_HEIGHT /2)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH)  * safezoneW;
			h = (GW_BUTTON_HEIGHT * 1)  * safezoneH;

			align = "center";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};

			text = "";
		};

		class Transaction : GW_StructuredTextBox
		{
			access = 0;
			idc = 10002;	
			fade = 1;
			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (STATUS_X) * safezoneW + safezoneX;
			y = (STATUS_Y + (GW_BUTTON_HEIGHT * 3) - (GW_BUTTON_HEIGHT /2) + GW_BUTTON_HEIGHT - 0.01) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH)  * safezoneW;
			h = (GW_BUTTON_HEIGHT * 1)  * safezoneH;

			align = "center";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};

			text = "";
		};


	};

};
