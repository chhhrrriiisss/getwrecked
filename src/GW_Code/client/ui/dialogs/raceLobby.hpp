#define GW_Lobby_ID 103000

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define NEW_X (0.27 + 0.02)
#define NEW_Y (0.3 + 0.017)

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13

class GW_Lobby
{
	idd = GW_Lobby_ID;
	name = "GW_Lobby";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Lobby', _this select 0]; "; 

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

		class VehiclesListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 9) - (GW_BUTTON_GAP_Y)) * safezoneH;
		};	

		class AttributesListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
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
		
		class List : GW_ListBox
		{
			idc = 103001;
			colorBackground[] = GW_BUTTON_BACKGROUND;
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT) + GW_BUTTON_GAP_Y)* safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 9) - (GW_BUTTON_GAP_Y * 2)) * safezoneH;
			


			text = "";
			sizeEx = "(0.016 / (getResolution select 5))";
			columns[] = {0, 0.08, 0.25, 0.8, 0.9};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 1.15;
		
		};

		class Title : GW_RscButtonMenu
		{
			idc = 103010;
			text = "RACE LOBBY";
			onButtonClick = "";
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH *2 + GW_BUTTON_GAP_X) * safezoneW;
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


		class Description : GW_StructuredTextBox
		{
			idc = 103005;
			colorBackground[] = {0,0,0,0};
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X) + (GW_BUTTON_WIDTH * 0.12)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 7.75) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 0.76) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 1.5)) * safezoneH;

			text = "";
			size = "(0.018 / (getResolution select 5))";
		};	

		class AttributesList : GW_ListBox
		{
			idc = 103002;
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 2) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 9) - (GW_BUTTON_GAP_Y * 2)) * safezoneH;
		
			colorSelectBackground[] = {0,0,0,0};
			colorSelectBackground2[] = {0,0,0,0};

			colorSelect[] = {1,1,1,1};
			colorSelect2[] = {1,1,1,1};

			text = "";
			sizeEx = "(0.018 / (getResolution select 5))";
			columns[] = {0.1, 0.23, 0.4};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 2.5;		
	
		
		};

		

		class CloseButton : GW_RscButtonMenu
		{
			idc = -1;

			style = "0x02 + 0xC0 + 64";
			text = "RETURN TO WORKSHOP";
			onButtonClick = "[] call exitLobbyToWorkshop;";
			x = (NEW_X) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			size = 0.03;
			sizeEx = "(0.018 / (getResolution select 5))";

			shadow = 1;		

			class TextPos
			{
				left = 0;
				top = 0.0139;
				right = 0;
				bottom = 0;
			};

		};

		class UnlockIcon : GW_StructuredTextBox
		{
			idc = 103004;
			colorBackground[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			onLoad = "(_this select 0) ctrlShow false; (_this select 0) ctrlCommit 0;";
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = (GW_BUTTON_HEIGHT) * safezoneH;

			text = "";
		};	


		class StripeTile : GW_Stripe_Box
		{    
			idc = 103030;			
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + (GW_BUTTON_GAP_Y)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;
		};  

		class SaveAndClose : GW_RscButtonMenu
		{
			idc = 103003;

			style = "0x02 + 0xC0 + 64";
			text = "READY";
			onButtonClick = "[] spawn toggleRaceReady;";
			x = (NEW_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (NEW_Y + (GW_BUTTON_HEIGHT * 10) + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			size = 0.03;
			sizeEx = "(0.018 / (getResolution select 5))";

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