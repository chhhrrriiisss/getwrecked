class GW_StructuredTextBox
{

	access = 0;
	type = 13;
	idc = -1;
	style = 0;

	colorText[] = 
	{
		1,
		1,
		1,
		1
	};

	colorBackground[] = 
	{
		0,
		0,
		0,
		0.25
	};

	class Attributes
	{
		font = "PuristaMedium";
		align = "center";
		shadow = 0;
	};

	x = 0;
	y = 0;
	w = 0.5;
	h = 0.5;

	size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) * 1)";

	text = "";
	
	shadow = 0;
	linespacing = 2;

	toolTipColorText[] = {1, 1, 1, 1};
	toolTipColorBox[] = {0, 0, 0, 0};
	toolTipColorShade[] = {0, 0, 0, 0.5};

};


class GW_Corner
{    
		idc = -1;
		type = 0;
		style = 48 + 2048; 			
		x = 0;
		y = 0;	
		w = 0.05;
		h = 0.05;
		font = "";
		sizeEx = 0.05;
		colorBackground[] = {1,1,1,1};
		colorText[] = {1,1,1,0.95}; 
		text = "client\images\icons\hud\corner1.paa";
		lineSpacing = 1; 
};


class GW_Stripe_Box
{    
	idc = -1;
	type = 0;
	style = 144; 		
	tileW = 3.5; 
	tileH = 0.595; 
	x = 0;
	y = 0;
	w = 0.3;
	h = 0.1;

	font = "PuristaMedium";
	sizeEx = 0.05;

	colorBackground[] = {0,0,0,0.5}; 
	colorText[] = {1,1,1,0.8}; 

	text = "client\images\stripes_repeat_yellow.paa";
	lineSpacing = 1; 
}; 

class GW_Text_Box
{
	
	type = CT_STATIC;  
  	style = 0;           

	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "PuristaSemiBold";
	sizeEx = "0.05 / (getResolution select 5)";
	lineSpacing = 0;
	fixedWidth = 0;
	shadow = 0;

	x = 0;
	y = 0;
	w = 0.06;
	h = 0.06;

	text = "";
	size = "0.05 / (getResolution select 5)";

};

class GW_Block {
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	type = 0;
	style = 0;
	shadow = 1;
	colorShadow[] = {0, 0, 0, 0.5};
	font = "PuristaMedium";
	SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	text = "";
	colorText[] = {1, 1, 1, 1.0};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};

class GW_ListBox {
	style = 16;
	type = 102;
	shadow = 0;
	font = "PuristaMedium";
	sizeEx = "0.03";
	color[] = {0.95,0.95,0.95,1};
	colorText[] = {1,1,1,1.0};
	colorDisabled[] = {1,1,1,0.25};

	colorScrollbar[] = {0.95,0.95,0.95,1};
	colorSelect[] = {1,1,1,1};
	colorSelect2[] = {1,1,1,1};
	colorSelectBackground[] = {0.8,0.8,0.8,1};
	colorSelectBackground2[] = {1,1,1,0.5};
	soundSelect[] = {"",0.1,1};
	soundExpand[] = {"",0.1,1};
	soundCollapse[] = {"",0.1,1};
	period = 1.2;
	maxHistoryDelay = 0.5;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;

	class ListScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "client\images\icons\menus\full.paa";
		arrowEmpty = "client\images\icons\menus\empty.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};



class GW_RscTitle
{
	
	type = CT_STATIC;
	style = ST_CENTER;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.05;
	w = 0.2;
	shadow = 0;
	font = "puristaMedium";
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 12) * 1)";
};


class GW_LargeTitle
{
	
	type = CT_STATIC;
	style = ST_CENTER;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	shadow = 0;
	font = "puristaMedium";
	sizeEx = "0.17";  
};



class GW_RscText {
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	type = CT_STATIC;
	style = ST_CENTER;
	shadow = 0;
	colorShadow[] = {0, 0, 0, 0};
	font = "PuristaMedium";
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	text = "";
	colorText[] = {1, 1, 1, 1.0};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};

class GW_RscPicture {
	shadow = 0;
	colorText[] = {1, 1, 1, 1};
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
};

class GW_RscPictureKeepAspect : GW_RscPicture {
	style = 0x30 + 0x800;
};

class GW_RscLine : GW_RscText {
	idc = -1;
	style = 176;
	x = 0.17;
	y = 0.48;
	w = 0.66;
	h = 0;
	text = "";
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1.0};
};

class GW_RscListNBox {
	style = 16;
	type = 102;
	shadow = 0;
	default = 0; 
	font = "PuristaMedium";
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	color[] = {0.95,0.95,0.95,1};
	colorText[] = {1,1,1,1.0};
	colorDisabled[] = {1,1,1,0.25};
	colorScrollbar[] = {0.95,0.95,0.95,1};
	colorSelect[] = {0,0,0,1};
	colorSelect2[] = {0,0,0,1};
	colorSelectBackground[] = {0.8,0.8,0.8,1};
	colorSelectBackground2[] = {1,1,1,0.5};
	soundSelect[] = {"",0.1,1};
	soundExpand[] = {"",0.1,1};
	soundCollapse[] = {"",0.1,1};
	period = 1.2;
	maxHistoryDelay = 0.5;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;

	toolTipColorText[] = {1, 1, 1, 1};
	toolTipColorBox[] = {0, 0, 0, 0};
	toolTipColorShade[] = {0, 0, 0, 0.5};

	class ListScrollBar
	{
		color[] = {1,1,1,0.75};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};

class GW_RscButton {
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "PuristaMedium";
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	colorText[] = {1, 1, 1, 1.0};
	colorDisabled[] = {0.4, 0.4, 0.4, 1};
	colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.7};
	colorBackgroundActive[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 1};
	colorBackgroundDisabled[] = {0.95, 0.95, 0.95, 1};
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	colorFocused[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 1};
	colorShadow[] = {0, 0, 0, 1};
	colorBorder[] = {0, 0, 0, 1};
	borderSize = 0.0;
	soundEnter[] = {"\A3\ui_f\data\sound\onover", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\sound\new1", 0.0, 0};
	soundClick[] = {"\A3\ui_f\data\sound\onclick", 0.07, 1};
	soundEscape[] = {"\A3\ui_f\data\sound\onescape", 0.09, 1};
};


class GW_RscButtonMenu : GW_RscButton {
	idc = -1;
	type = 16;
	style = "0x02 + 0xC0"; 
	default = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureDisabled = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureOver = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
	animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
	colorBackground[] = {0,0,0,0.8};
	colorBackgroundFocused[] = {1,1,1,0.5};	
	colorBackground2[] = {1,1,1,0.5};

	color[] = {1,1,1,1};
	colorFocused[] = {0,0,0,1};
	color2[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.25};
	period = 1.2;
	periodFocus = 1.2;
	periodOver = 1.2;
	size = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

	toolTipColorText[] = {1, 1, 1, 1};
	toolTipColorBox[] = {0, 0, 0, 0};
	toolTipColorShade[] = {0, 0, 0, 0.5};


	class HitZone {
		left = 0.0;
		top = 0.0;
		right = 0.0;
		bottom = 0.0;
	};

	class TextPos
	{
		left = "0.25 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
		top = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - 		(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
		right = 0.005;
		bottom = 0.0;
	};
	class Attributes
	{
		font = "PuristaLight";
		color = "#E5E5E5";
		align = "center";
		shadow = "false";
	};
	class ShortcutPos
	{
		left = "(6.25 * 			(			((safezoneW / safezoneH) min 1.2) / 40)) - 0.0225 - 0.005";
		top = 0.005;
		w = 0.0225;
		h = 0.03;
	};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.09,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1};
	textureNoShortcut = "";
};




class GW_RscCombo {
	style = 16;
	type = 4;
	x = 0.01;
	y = 0;
	w = 0.12;
	h = 0.05;
	shadow = 0;
	colorSelect[] = {0, 0, 0, 1};
	soundExpand[] = {"",0.1,1};
	colorText[] = {0.95, 0.95, 0.95, 1};
	soundCollapse[] = {"",0.1,1};
	maxHistoryDelay = 1;
	colorBackground[] = {0.4,0.4,0.4,0.4};
	colorSelectBackground[] = {1, 1, 1, 0.7};
	colow_Rscrollbar[] = {1, 0, 0, 1};
	soundSelect[] = {
			"", 0.000000, 1
	};

	arrowFull = "client\images\icons\menus\full.paa";
	arrowEmpty = "client\images\icons\menus\empty.paa";

	wholeHeight = 0.45;
	color[] = {1, 1, 1, 1};
	colorActive[] = {1, 0, 0, 1};
	colorDisabled[] = {1, 1, 1, 0.25};
	font = "PuristaMedium";
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 30) * 1)";
	
	class ComboScrollBar {

		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "client\images\icons\menus\full.paa";
		arrowEmpty = "client\images\icons\menus\empty.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";

		sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 40) * 1)";
	};
};

