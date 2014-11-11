#define GW_Buy_ID 97000

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define NEW_X (0.27 + 0.02)
#define NEW_Y (0.3 + 0.017)

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13

class GW_Buy
{
	idd = GW_Buy_ID;
	name = "GW_Buy";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Buy_Menu', _this select 0]; "; 

	class controlsBackground
	{
		
		class MainBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.25};
			x = (NEW_X - 0.015) * safezoneW + safezoneX;
			y = (NEW_Y - 0.025) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH * 2) + 0.03) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 11) + (GW_BUTTON_GAP_Y * 2) + 0.05) * safezoneH;
		};	

		class ItemsListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (NEW_X + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 2) + (GW_BUTTON_GAP_Y * 3)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 7) - (GW_BUTTON_GAP_Y * 4)) * safezoneH;
		};	

		class SponsorBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.7};
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT) + GW_BUTTON_GAP_Y)* safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 10) * safezoneH;
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

		class FilterList : GW_RscCombo
		{
			idc = 97012;
			colorBackground[] = {0,0,0,0.7};
			onLBSelChanged  = "[_this select 1] spawn changeCategory;";
			x = (NEW_X + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (NEW_Y + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y ) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = (GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH;
		};

		class ItemsList : GW_ListBox
		{
			idc = 97001;
			colorBackground[] = GW_BUTTON_BACKGROUND;
			x = (NEW_X + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 2) + (GW_BUTTON_GAP_Y * 3) ) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 7) - (GW_BUTTON_GAP_Y * 4)) * safezoneH;
			
			text = "";
			sizeEx = "0.035";
			columns[] = {0.03, 0.1, 0.25, 0.52, 0.76};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 2;

			onLBDblClick = "_this spawn setQuantity; false";
			onLBClick = "_this spawn showHint; false";
		
		};

		class ItemsTitle : GW_RscButtonMenu
		{
			idc = -1;
			text = "PURCHASE ITEMS";
			onButtonClick = "";
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 2) * safezoneW;
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

		class SponsorLogo : GW_StructuredTextBox
		{
			idc = 97010;
			colorBackground[] = {0,0,0,0};
			x = (NEW_X + (GW_BUTTON_WIDTH * 0.04)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 1.7) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 0.92) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 5) * safezoneH;

			text = "";
			size = "0.275";
		};	

		class SponsorDiscount : GW_StructuredTextBox
		{
			idc = 97011;
			colorBackground[] = {0,0,0,0};
			x = (NEW_X + (GW_BUTTON_WIDTH * 0.12)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 7) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 0.76) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 4.5) * safezoneH;

			text = "";
			size = "0.035";
		};	
		
		class Total : GW_RscButtonMenu
		{
			idc = 97005;

			style = "0x02 + 0xC0 + 64";
			text = "TOTAL ";
			onButtonClick = "";
			x = (NEW_X + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 9)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			size = 0.03;
			sizeEx = "0.03";

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
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + (GW_BUTTON_GAP_Y)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;
		};  

		class Purchase : GW_RscButtonMenu
		{
			idc = 97003;

			style = "0x02 + 0xC0 + 64";
			text = "PURCHASE";
			onButtonClick = "[] spawn purchaseList;";
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
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