#define GW_Menu_ID 42000
#define GW_VehicleName_ID 42001
#define GW_VehicleData_ID 42002
#define GW_FilterList_ID 42003
#define GW_StatsList_ID 42004


#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define MARGIN_TOP 0.15
#define MARGIN_BOTTOM 0.81

// Menu
class GW_Menu
{
	idd = GW_Menu_ID;
	name = "GW_Menu";
	movingEnabled = false;
	// onMouseMoving = "_this execVM 'client\ui\mouse_handler.sqf'";
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Preview_Menu', _this select 0]; "; 

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

		class StatsListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (0.015) * safezoneW + safezoneX;
			y = (MARGIN_TOP + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 9) * safezoneH;
		};	

	};

	class controls
	{

		
		class Title : GW_LargeTitle
		{
			idc = GW_VehicleName_ID;
			text = "";
			font = "PuristaMedium";

			x = (0.1) * safezoneW + safezoneX;
			y = (0.44) * safezoneH + safezoneY;
			w = 0.8  * safezoneW;
			h = 0.12  * safezoneH;

		};

		class ButtonBlank : GW_RscButtonMenu
		{
			idc = -1;
			text = "";
			onButtonClick = "";
			colorBackgroundFocused[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
			colorBackground2[] = {0,0,0,0};
			x = (0) * safezoneW + safezoneX;
			y = (0) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

		};

		class StatsList : GW_ListBox
		{
			idc = GW_StatsList_ID;
			colorBackground[] = GW_BUTTON_BACKGROUND;
			x = (0.015) * safezoneW + safezoneX;
			y = (MARGIN_TOP + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 9) * safezoneH;
			
			colorSelectBackground[] = {0,0,0,0};
			colorSelectBackground2[] = {0,0,0,0};

			colorSelect[] = {1,1,1,1};
			colorSelect2[] = {1,1,1,1};

			text = "";
			sizeEx = "0.03";
			columns[] = {0, 0.15, 0.5, 0.7};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 1.5;
		
		};	

		class StatsTitle : GW_RscButtonMenu
		{
			idc = -1;
			text = "VEHICLE STATS";
			onButtonClick = "";
			x = (0.015) * safezoneW + safezoneX;
			y = (MARGIN_TOP) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			colorFocused[] = {1,1,1,1};
			color2[] = {1,1,1,1};

			colorBackground[] = GW_BUTTON_BACKGROUND;
			colorBackgroundFocused[] = GW_BUTTON_BACKGROUND;
			colorBackground2[] = GW_BUTTON_BACKGROUND;

			class TextPos
			{
				left = 0;
				top = 0.0139;
				right = 0;
				bottom = 0;
			};

		};


		class FilterList : GW_RscCombo
		{
			idc = GW_FilterList_ID;
			colorBackground[] = {0,0,0,0.7};
			onLBSelChanged  = "[_this select 1] spawn changeVehicle;";
			x = (0.015) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;
		};
		
		class ButtonClose : GW_RscButtonMenu
		{
			idc = -1;
			text = "X";
			onButtonClick = "closeDialog 0;";
			x = (0.98 - (GW_BUTTON_WIDTH / 2)) * safezoneW + safezoneX;
			y = (MARGIN_TOP) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH/2) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};

		};
		

		class StripeTile : GW_Stripe_Box
		{    
			idc = -1;			
			x = (0.4) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = GW_BUTTON_WIDTH * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;
		};  

		class ButtonLoad : GW_RscButtonMenu

		{
			idc = -1;
			text = "SELECT";
			onButtonClick = "[] spawn selectVehicle";
			x = (0.4) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = GW_BUTTON_WIDTH * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

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
			onButtonClick = "['prev'] spawn changeVehicle";
			x = (0.4 - ( (GW_BUTTON_WIDTH / 3) + GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 3) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};

		};

		class ButtonNext : GW_RscButtonMenu
		{
			idc = -1;
			text = "&#62;";
			onButtonClick = "['next'] spawn changeVehicle";
			x = (0.4 + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 3) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};
		};

		class ButtonDelete : GW_RscButtonMenu
		{
			idc = -1;
			text = "Delete";
			onButtonClick = "[] spawn removeVehicle";
			x = (0.98 - (GW_BUTTON_WIDTH / 2)) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH / 2) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			colorBackgroundFocused[] = {0.99,0.14,0.09,0.65}; 
			colorBackground2[] = {0.99,0.14,0.09,0.85};

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};
		};

	};
};