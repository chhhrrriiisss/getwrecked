#define GW_Settings_ID 92000
#define GW_Settings_List_ID 92001
#define GW_Texture_List_ID 92002
#define GW_Settings_Name_ID 92003
#define GW_Stats_List_ID 92004
#define GW_Stats_Title_ID 92005

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define SETTINGS_X (0.27 + 0.02)
#define SETTINGS_Y (0.3 + 0.017)

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13

class GW_Settings
{
	idd = GW_Settings_ID;
	name = "GW_Settings";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_Settings_Menu', _this select 0]; "; 

	class controlsBackground
	{
		
		class MainBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.25};
			x = (SETTINGS_X - 0.015) * safezoneW + safezoneX;
			y = (SETTINGS_Y - 0.025) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH * 2) + 0.03) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 11) + (GW_BUTTON_GAP_Y * 2) + 0.05) * safezoneH;
		};	

		class SettingsListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (SETTINGS_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 9) * safezoneH;
		};	

		class StatsListBackground : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.5};
			x = (SETTINGS_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (SETTINGS_Y + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - (GW_BUTTON_GAP_X)) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 6) + (GW_BUTTON_GAP_Y * 5)) * safezoneH;
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

		class StatsList : GW_ListBox
		{
			idc = GW_Stats_List_ID;
			colorBackground[] = GW_BUTTON_BACKGROUND;
			x = (SETTINGS_X + (GW_BUTTON_WIDTH) + (GW_BUTTON_GAP_X)) * safezoneW + safezoneX;
			y = (SETTINGS_Y + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - (GW_BUTTON_GAP_X)) * safezoneW;
			h = ((GW_BUTTON_HEIGHT * 6) + (GW_BUTTON_GAP_Y * 5)) * safezoneH;
			
			colorSelectBackground[] = {0,0,0,0};
			colorSelectBackground2[] = {0,0,0,0};

			colorSelect[] = {1,1,1,1};
			colorSelect2[] = {1,1,1,1};

			text = "";
			sizeEx = "0.03";
			columns[] = {0, 0.18, 0.56, 0.7};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 1.5;

		};

		
		class SettingsList : GW_ListBox
		{
			idc = GW_Settings_List_ID;
			colorBackground[] = GW_BUTTON_BACKGROUND;
			x = (SETTINGS_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + GW_BUTTON_HEIGHT + GW_BUTTON_GAP_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
			h = (GW_BUTTON_HEIGHT * 9) * safezoneH;
			
			text = "";
			sizeEx = "0.03";
			columns[] = {0, 0.16, 0.75, 1};
			drawSideArrows = false;
			idcLeft = -1;
			idcRight = -1;
			rowHeight = GW_BUTTON_HEIGHT * 2;

			onLBSelChanged = "";
			onLBDblClick = "_this spawn setBind; false";
		
		};

		class BindingsTitle : GW_RscButtonMenu
		{
			idc = -1;
			text = "KEY BINDINGS";
			onButtonClick = "";
			x = (SETTINGS_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH * 1) * safezoneW;
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

		class ButtonClearBind : GW_RscButtonMenu

		{
			idc = -1;
			text = "CLEAR";
			size = 0.03;
			sizeEx = "0.03";
			onButtonClick = "[] spawn clearBind; false";
			x = (SETTINGS_X + (GW_BUTTON_WIDTH * 0.5) + (GW_BUTTON_GAP_X / 2)) * safezoneW + safezoneX;
			y = (SETTINGS_Y + (GW_BUTTON_HEIGHT * 10) + (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH * 0.5) - GW_BUTTON_GAP_X / 2) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.015;
				right = 0;
				bottom = 0;
			};

		};

		class ButtonResetBindings : GW_RscButtonMenu

		{
			idc = -1;
			text = "RESET ALL";
			size = 0.03;
			sizeEx = "0.03";
			onButtonClick = "[] spawn resetAllBinds; false";
			x = (SETTINGS_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + (GW_BUTTON_HEIGHT *10) + (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			w = ((GW_BUTTON_WIDTH * 0.5) - GW_BUTTON_GAP_X / 2) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			colorBackgroundFocused[] = {0.99,0.14,0.09,0.65}; 
			colorBackground2[] = {0.99,0.14,0.09,0.85};

			class TextPos
			{
				left = 0;
				top = 0.015;
				right = 0;
				bottom = 0;
			};

		};

		class ButtonRename : GW_RscButtonMenu
		{
			idc = -1;
			text = "RENAME VEHICLE";
			size = 0.03;
			sizeEx = "0.03";

			onButtonClick = "[] spawn renameVehicle; false";
			x = (SETTINGS_X + (GW_BUTTON_WIDTH) + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + (GW_BUTTON_HEIGHT * 7) + (GW_BUTTON_GAP_Y * 7)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};

		};

		class ButtonUnflip : GW_RscButtonMenu
		{
			idc = -1;
			text = "UNFLIP VEHICLE";
			size = 0.03;
			sizeEx = "0.03";
			onButtonClick = "[GW_SETTINGS_VEHICLE] spawn flipVehicle; closeDialog 0; false";
			x = (SETTINGS_X + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + (GW_BUTTON_HEIGHT * 8) + (GW_BUTTON_GAP_Y * 8)) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};

		};

		class StatsTitle : GW_RscButtonMenu
		{
			idc = GW_Stats_Title_ID;
			text = "UNTITLED";
			onButtonClick = "";
			x = (SETTINGS_X + GW_BUTTON_WIDTH + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

			colorFocused[] = {1,1,1,1};
			color2[] = {1,1,1,1};

			colorBackground[] = GW_BUTTON_BACKGROUND;
			colorBackgroundFocused[] = GW_BUTTON_BACKGROUND;
			colorBackground2[] = GW_BUTTON_BACKGROUND;

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
			x = (SETTINGS_X + (GW_BUTTON_WIDTH) + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + (GW_BUTTON_HEIGHT * 10) + (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
			h = GW_BUTTON_HEIGHT * safezoneH;
			w = (GW_BUTTON_WIDTH - GW_BUTTON_GAP_X) * safezoneW;		
		};  

		class SaveAndClose : GW_RscButtonMenu
		{
			idc = -1;

			style = "0x02 + 0xC0 + 64";
			text = "CLOSE";
			onButtonClick = "[] call saveBinds; closeDialog 0;";
			x = (SETTINGS_X + (GW_BUTTON_WIDTH) + GW_BUTTON_GAP_X) * safezoneW + safezoneX;
			y = (SETTINGS_Y + (GW_BUTTON_HEIGHT * 10) + (GW_BUTTON_GAP_Y * 2)) * safezoneH + safezoneY;
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