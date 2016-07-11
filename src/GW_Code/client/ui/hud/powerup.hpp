#define GW_Notification_ID 720000
#define GW_Notification_Title_ID 720001
#define GW_Notification_Icon_ID 720002

#define GW_ALERT_WIDTH 0.15
#define GW_ALERT_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define NOTFX_X 0.4
#define NOTFX_Y 0.1

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13
#define CT_EDIT 2
#define CT_STATIC 0
#define CT_STRUCTURED_TEXT  13

#define ST_CENTER 0x02
#define ST_LINE 0xB0
#define ST_LEFT 0x00

// Menu
class GW_Powerup
{
	idd = -1;
	movingEnabled = true;
	enableSimulation = true;	
	duration = 1e+1000;  
	name = "GW_Powerup";
	fadeIn = 0; 
	fadeOut = 0; 

	onLoad = "uiNamespace setVariable ['GW_Powerup', _this select 0];"; 

	class controlsBackground 
	{
		class StripesTopLeft : GW_StructuredTextBox
		{
			idc = 150003;
			fade = 1;
			colorBackground[] = {0,0,0,0};
			x = (NOTFX_X) * safezoneW + safezoneX;
			y = (NOTFX_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 1.25) * safezoneW;
			h = (GW_ALERT_HEIGHT * 4) * safezoneH;
			size = "1";

			text = "<img size='0.33' align='center' image='client\images\stripes_fade_grey_topleft.paa' />";
		};	

		class Notification_Text : GW_StructuredTextBox
		{
			access = 0;
			idc = 150002;

			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (NOTFX_X) * safezoneW + safezoneX;
			y = (NOTFX_Y + 0.085) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 1.25) * safezoneW;
			h = (GW_ALERT_HEIGHT * 4) * safezoneH;

			align = "center";
			text = "";
		};

		class Notification_Icon : GW_StructuredTextBox
		{
			access = 0;
			idc = 150001;

			colorBackground[] = 
			{
				0,
				0,
				0,
				0.25
			};
		
			x = (NOTFX_X) * safezoneW + safezoneX;
			y = (NOTFX_Y + 0.015) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 1.25) * safezoneW;
			h = (GW_ALERT_HEIGHT * 3) * safezoneH;
		};

	
	};
};