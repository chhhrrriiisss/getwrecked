//
//      Name: tauntVehicle
//      Desc: Emits a custom sound from the vehicle
//      Return: None
//

private ['_vehicle', '_dir', '_pos', '_alt', '_vel'];

_vehicle = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith {};

_sound = _vehicle getVariable ['GW_Taunt', 'none'];
_sound = if (typename _sound == "ARRAY") then { "none" } else { _sound };

if (!isNil "_sound") then {

	if (_sound == "none") exitWith {};

	// Prevent too much horn spam
    if (isNil "GW_LASTTAUNT") then {  GW_LASTTAUNT = time - 1;  };   
    _timeSince = (time - GW_LASTTAUNT);

	if (_sound in GW_TAUNTS_LIST && (_timeSince > 0.98)) then {

		GW_LASTTAUNT = time;		

		[		
			[
				_vehicle,
				_sound,
				200
			],
			"playSoundAll",
			true,
			false
		] call gw_fnc_mp;

	};

};