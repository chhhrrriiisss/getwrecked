// Menu
class GW_Loading
{
	idd = 999998;
	movingEnabled = false;
	enableSimulation = true;	
	duration = 1e+1000;  
	name = "GW_Loading";
	fadeIn = 1; 
	fadeOut = 1;
	fade = 0;

	onLoad = "uiNamespace setVariable ['GW_Loading', _this select 0];"; 

	class controlsBackground
	{
		class Black : GW_Block
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.1};
			x = -1;
			y = 0 * safezoneH + safezoneY; 
			w = 3;
			h = 1 * safezoneH;
		};	

		class Loading_Text : GW_StructuredTextBox
		{
			access = 0;
			idc = 999999;

			colorBackground[] = 
			{
				0,
				0,
				0,
				0
			};

			colorText[] = 
			{
				1,
				1,
				1,
				1

			};

			x = 0.45 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.1 * safezoneH;

			align = "center";
			text = "<img size='1' image='client\images\loading\loading_03.paa' />";

			class Attributes
			{
				font = "PuristaMedium";
				align = "center";
				shadow = 0;
			};
		};		
	};
};