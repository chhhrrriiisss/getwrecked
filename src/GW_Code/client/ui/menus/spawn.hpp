#define GW_Spawn_ID 52000
#define GW_LocationName_ID 52001
#define GW_Spawn_List_ID 52002
#define GW_Current_Players_ID 52003

#define GW_BUTTON_WIDTH (6.25 / 40)

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define MARGIN_TOP 0.15
#define MARGIN_BOTTOM 0.81

// Menu
class GW_Spawn
{
	idd = GW_Spawn_ID;
	name = "GW_Spawn";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Spawn_Menu', _this select 0]; "; 

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
		class SpawnTitle : GW_LargeTitle
		{
			idc = GW_LocationName_ID;
			text = "";
		
			x = (0.1) * safezoneW + safezoneX;
			y = (0.44) * safezoneH + safezoneY;
			w = 0.8  * safezoneW;
			h = 0.12  * safezoneH;

		};

		class SpawnButtonBlank : GW_RscButtonMenu
		{
			idc = -1;
			text = "";
			onButtonClick = "";
			colorBackgroundFocused[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
			colorBackground2[] = {0,0,0,0};
			x = (0) * safezoneW + safezoneX;
			y = (0) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH)  * safeZoneW;
			h = GW_BUTTON_HEIGHT  * safeZoneH;

		};

		class SpawnList : GW_RscCombo
		{
			idc = GW_Spawn_List_ID;
			colorBackground[] = {0,0,0,0.7};
			onLBSelChanged  = "(_this select 1) call previewLocation;";
			x = (0.015) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;
		};
		
		class SpawnButtonClose : GW_RscButtonMenu
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

		class ButtonDeploy : GW_RscButtonMenu

		{
			idc = -1;
			text = "DEPLOY";
			onButtonClick = "[] call selectLocation";
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
			idc = -1;
			text = "&#60;";
			onButtonClick = "-1 call changeLocation";
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
			idc = -1;
			text = "&#62;";
			onButtonClick = "1 call changeLocation";
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
	};
};