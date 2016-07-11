#define GW_Inventory_ID 98000

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define NEW_X (0.37)
#define NEW_Y (0.3)

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13

// Menu
class GW_Inventory
{
	idd = GW_Inventory_ID;
	name = "GW_Inventory";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Inventory_Menu', _this select 0]; "; 

	class controlsBackground
	{
		
		class MainBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.25};
			x = (NEW_X - 0.015) * safezoneW + safezoneX;
			y = (NEW_Y - 0.025) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH) + 0.03) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 11) + (GW_BUTTON_GAP_Y * 2) + 0.05) * safezoneH;
		};	

		class ItemsListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT) + GW_BUTTON_GAP_Y)* safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 9) - (GW_BUTTON_GAP_Y)) * safezoneH;
		};	


	};

	class controls
	{


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
		
		class InventoryList : GW_ListBox
		{
			idc = 98001;
			colorBackground[] = GW_BUTTON_BACKGROUND;
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT) + GW_BUTTON_GAP_Y)* safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 8) - (GW_BUTTON_GAP_Y * 1)) * safezoneH;
			

			text = "";
			sizeEx = "0.035";
			columns[] = {0.03, 0.12, 0.25, 0.52, 0.76};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 2;
			
			onLBDblClick = "_this spawn grabItemSupplyBox;";
		
		};

		class Inventory : GW_RscButtonMenu
		{
			idc = -1;
			text = "SUPPLY BOX";
			onButtonClick = "";
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y) * safezoneH + safezoneY;
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

		class StripeTile : GW_Stripe_Box
		{    
			idc = -1;			
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + (GW_BUTTON_GAP_Y)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;
		};  

		class Remove : GW_RscButtonMenu
		{
			idc = 98002;

			style = "0x02 + 0xC0 + 64";
			text = "REMOVE ITEM";
			onButtonClick = "_this spawn removeItemSupplyBox;";
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			size = 0.03;
			sizeEx = "0.03";

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
				top = 0.0139;
				right = 0;
				bottom = 0;
			};
		};
	};
};