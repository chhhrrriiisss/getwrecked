#define GW_Alert_New_ID 1000
#define GW_Alert_New_Title_ID 1001
#define GW_Alert_New_Icon_ID 1002

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

class GW_Alert_Structured_Text : GW_StructuredTextBox
{    
	text = "";
	align = "center";
	colorBackground[] = {0,0,0,0};

	class Attributes
	{
		font = "PuristaMedium";
		align = "center";
		shadow = 0;
	};
}; 

// Menu
class GW_Notification
{
	idd = -1;
	movingEnabled = true;
	enableSimulation = true;	
	duration = 1e+1000;  
	name = "GW_Notification";
	fadeIn = 0; 
	fadeOut = 0; 

	onLoad = "uiNamespace setVariable ['GW_Notification', _this select 0];"; 

	class controlsBackground 
	{
		
		// Text
		class AT1 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1001;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB1 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1002;

			colorBackground[] = {0,0,0,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

	
		// Text
		class AT2 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1003;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB2 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1004;
			
			colorBackground[] = {0,1,0,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};		

		// Text
		class AT3 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1005;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB3 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1006;
			
			colorBackground[] = {0,0,1,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

	
		// Text
		class AT4 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1007;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB4 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1008;
			
			colorBackground[] = {1,0,1,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

		

		// Text
		class AT5 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1009;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB5 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1010;
			
			colorBackground[] = {1,0,1,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

	

		// Text
		class AT6 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1011;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB6 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1012;
			
			colorBackground[] = {1,0,1,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

	

		// Text
		class AT7 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1013;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB7 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1014;
			
			colorBackground[] = {1,0,1,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

		

		// Text
		class AT8 : GW_Alert_Structured_Text
		{
			access = 0;
			idc = 1015;

			x = (ALERT_X) * safezoneW + safezoneX;
			y = ((ALERT_Y + GW_BUTTON_HEIGHT) - (0.0025 + (GW_BUTTON_HEIGHT / 2))) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;					
			
		};

		// Background
		class AB8 : GW_StructuredTextBox
		{
			access = 0;
			idc = 1016;
			
			colorBackground[] = {1,0,1,0.25};
		
			x = (ALERT_X) * safezoneW + safezoneX;
			y = (ALERT_Y) * safezoneH + safezoneY;
			w = (GW_ALERT_WIDTH * 0.35) * safezoneW;
			h = (GW_ALERT_HEIGHT * 2.3) * safezoneH;
		};

		
				
	};

};