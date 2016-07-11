//
//      Name: initPlayerJIP
//      Desc: Syncs vehicle & player textures for JIP clients
//      Return: None
//

waitUntil{!isNil { clientCompileComplete } };
waitUntil {!isNull player};  

// Retexture all vehicles
{
	_texture = _x getVariable "GW_paint";
	if(!isNil "_texture") then
	{
		[_x,_texture] spawn setVehicleTexture;
	};

	// Also sync hidden vehicles
	_isHidden = _x getVariable ['GW_HIDDEN', false];
	if (_isHidden) then { [_x, true] call pubVar_fnc_setHidden;	};

} foreach (allMissionObjects "Car");

// Retexture all players
{
	_texture = _x getVariable "texture";
	if(!isNil "_texture") then
	{
		[_x,_texture] spawn setPlayerTexture;
	};
} foreach (allMissionObjects "Man");
