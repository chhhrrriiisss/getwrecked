//
//      Name: setTaunt
//      Desc: Sets the taunt for the current vehicle
//      Return: None
//

if (!GW_SETTINGS_READY) exitwith {};

disableSerialization;

if (_this == 0) exitWith {
	GW_SETTINGS_VEHICLE setVariable ['GW_Taunt', 'none'];	
};

_data = lbData [92006, (_this - 1)];
playSound _data;
GW_SETTINGS_VEHICLE setVariable ['GW_Taunt', _data];	
