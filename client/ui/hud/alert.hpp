#define GW_Alert_ID 520000
#define GW_Alert_Title_ID 520001
#define GW_Alert_Icon_ID 520002

#define GW_ALERT_WIDTH 0.15
#define GW_ALERT_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define ALERT_X (0.5 - (((GW_ALERT_WIDTH * 1) + 0.03) /2))
#define ALERT_Y (0.5 - (((GW_ALERT_HEIGHT * 3) + (GW_BUTTON_GAP_Y * 2) + 0.05) / 2))

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13
#define CT_EDIT 2
#define CT_STATIC 0
#define CT_STRUCTURED_TEXT  13

#define ST_CENTER 0x02
#define ST_LINE 0xB0
#define ST_LEFT 0x00

// Menu
class GW_Alert
{
	idd = -1;
	movingEnabled = true;
	enableSimulation = true;	
	duration = 1e+1000;  
	name = "GW_Alert";
	fadeIn = 0; 
	fadeOut = 0; 

	onLoad = "uiNamespace setVariable ['GW_Alert', _this select 0];"; 

	class controlsBackground 
	{
		class Alert_Text : GW_StructuredTextBox
		{
			access = 0;
			idc = 140002;

			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 1.25) * safezoneW;
			h = (GW_ALERT_HEIGHT) * safezoneH;

			align = "center";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};



			text = "";
		};

		class Alert_Background : GW_StructuredTextBox
		{
			access = 0;
			idc = 140001;

			colorBackground[] = 
			{
				0,
				0,
				0,
				0.25
			};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 1.25) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2) * safezoneH;
		};

		// class AlertTitle : GW_RscStructuredText
		// {
		// 	idc = 11111;
		// 	type = CT_STRUCTURED_TEXT; // CT_STATIC
  //     		style = ST_CENTER;
		// 	text = "TEST";

		//  	size = 0.05;
		//  	sizeEx = "0.05";
		//  	colorText[] = {1,1,1,1};
		//  	colorBackground[] = {0,0,0,0.25};
		//  	shadow = 0;

		// 	x = (ALERT_X) * safezoneW + safezoneX;
		// 	y = (ALERT_Y) * safezoneH + safezoneY;
		// 	w = (GW_BUTTON_WIDTH * 1.25) * safezoneW;
		// 	h = (GW_BUTTON_HEIGHT * 2) * safezoneH;

		// 	class Attributes {
		// 		align = "left";
		// 	};
		// };					
	};
};