#define GW_Overlay_ID 99000

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define TIMER_X (0.5 - (((GW_BUTTON_WIDTH * 1) + 0.03) /2))
#define TIMER_Y (0.5 - (((GW_BUTTON_HEIGHT * 3) + (GW_BUTTON_GAP_Y * 2) + 0.05) / 2))

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13
#define CT_EDIT 2

class GW_Hint
{
	idd = GW_Overlay_ID;
	name = "GW_Hint";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Hint', _this select 0]; "; 

	class controlsBackground
	{

		class Background : GW_Block
		{
			idc = 99005;
			colorBackground[] = {0,0,0,0.6};
			x = -1;
			y = 0 * safezoneH + safezoneY; 
			w = 3;
			h = 3;
		};			

	};

	class controls
	{
		
		
		class Title : GW_StructuredTextBox
		{
			idc = 99001;
			text = "TEST";
			
			x = (0.35) * safezoneW + safezoneX;
			y = (0.15) * safezoneH + safezoneY;
			w = 0.3  * safezoneW;
			h = 0.25  * safezoneH;

			colorBackground[] = {0,0,0,0};

		};

		class Content : GW_StructuredTextBox
		{
			idc = 99002;
			text = "TEST";
			
			x = (0.32) * safezoneW + safezoneX;
			y = (0.4) * safezoneH + safezoneY;
			w = 0.36  * safezoneW;
			h = 0.4  * safezoneH;

			colorBackground[] = {0,0,0,0};

		};

		class ButtonA : GW_RscButtonMenu
		{
			idc = 99003;
			text = "ABORT";
			onButtonClick = "closeDialog 0;";

			x = (0.42) * safezoneW + safezoneX;
			y = (0.6) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 0.75) * safeZoneW;
			h = GW_BUTTON_HEIGHT  * safeZoneH;

			colorBackground2[] = {0,0,0,0.8};
			colorBackgroundFocused[] = {0,0,0,0.8};
			colorFocused[] = {1,1,1,1};
			color2[] = {1,1,1,1};
			period = 0;

		
			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};
		};

		// class ButtonB : GW_RscButtonMenu
		// {
		// 	idc = 99004;
		// 	text = "TEST";
		// 	onButtonClick = "[] call functionOnComplete;";

		// 	x = (0.5) * safezoneW + safezoneX;
		// 	y = (0.6) * safezoneH + safezoneY;
		// 	w = (GW_BUTTON_WIDTH * 0.75) * safeZoneW;
		// 	h = GW_BUTTON_HEIGHT  * safeZoneH;

		
		// 	class TextPos
		// 	{
		// 		left = 0;
		// 		top = 0.0135;
		// 		right = 0;
		// 		bottom = 0;
		// 	};
		// };
	};
};