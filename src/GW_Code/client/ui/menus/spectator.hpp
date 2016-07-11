#define GW_Spectator_ID 104000
#define GW_Spectator_Block_ID 104001
#define GW_Spectator_Title_ID 104002

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

class GW_Spectator
{
	idd = GW_Spectator_ID;
	name = "GW_Spectator";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Spectator', _this select 0]; "; 

	class controlsBackground
	{

	
		class MarginBottom : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.85};
			x = -1;
			y = (MARGIN_BOTTOM + (GW_BUTTON_HEIGHT * 2)) * safezoneH + safezoneY; 
			w = 3;
			h = 0.25 * safezoneH;
		};	

		class MarginTop : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.85};
			x = -1;
			y = 0 * safezoneH + safezoneY; 
			w = 3;
			h = MARGIN_TOP + (GW_BUTTON_HEIGHT) * safezoneH;
		};	

	};

	class controls
	{
		


		class ButtonClose : GW_RscButtonMenu
		{
			idc = -1;
			text = "X";
			onButtonClick = "closeDialog 0;";
			x = (0.98 - (GW_BUTTON_WIDTH /2)) * safezoneW + safezoneX;
			y = (MARGIN_TOP) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 2)  * safeZoneW;
			h = GW_BUTTON_HEIGHT  * safeZoneH;


			class TextPos
			{
				left = 0;
				top = 0.0139;
				right = 0;
				bottom = 0;
			};

		};
			
		class StripeTile : GW_Stripe_Box
		{    
			idc = -1;			
			x = (0.4) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH)  * safeZoneW;
			h = GW_BUTTON_HEIGHT  * safeZoneH;
		};  

		class ButtonToggle : GW_RscButtonMenu

		{
			idc = 104004;
			text = "";
			onButtonClick = "[] call GW_MODE_SPECTATOR;";
			x = (0.4) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safeZoneW;
			h = GW_BUTTON_HEIGHT  * safeZoneH;

			shadow = 1;

			colorBackground[] = {0,0,0,0.5};
			colorBackgroundFocused[] = {0,0,0,0};
			colorBackground2[] = {0,0,0,0.1};

			color[] = {1,1,1,0.75};
			colorFocused[] = {1,1,1,1};
			color2[] = {1,1,1,1};			
			colorText[] = {1,1,1,1};

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};


		};

		class ButtonPrev : GW_RscButtonMenu
		{
			idc = 104003;
			text = "&#60;";
			onButtonClick = "[-1] spawn swapSpectator;";
			x = (0.4 - ( (GW_BUTTON_WIDTH / 3) + GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 3) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.014;
				right = 0;
				bottom = 0;
			};

		};

		class ButtonNext : GW_RscButtonMenu
		{
			idc = 104002;
			text = "&#62;";
			onButtonClick = "[1] spawn swapSpectator;";
			x = (0.4 + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 3) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.014;
				right = 0;
				bottom = 0;
			};
		};

		// class MouseBlock : GW_RscButtonMenu
		// {
		// 	idc = GW_Spectator_Block_ID;
		// 	text = "";
		// 	onMouseMoving = "systemchat format['moving: %1', _this]; ";
		// 	x = (0) * safezoneW + safezoneX;
		// 	y = (0) * safezoneH + safezoneY;
		// 	w = 1  * safezoneW;
		// 	h = 0.75 * safezoneH;

		// 	colorBackground[] = {0,0,0,0};
		// 	colorBackgroundFocused[] = {0,0,0,0};	
		// 	colorBackground2[] = {0,0,0,0};
	
		// };

	};
};