//
//      Name: initPlayerJIP
//      Desc: Syncs vehicle & player textures for JIP clients
//      Return: None
//

waitUntil{!isNil { clientCompileComplete } };
waitUntil {!isNull player};  

// Retexture all vehicles
{
	_texture = _x getVariable "paint";
	if(!isNil "_texture") then
	{
		[_x,_texture] spawn setVehicleTexture;
	};
} foreach (allMissionObjects "Car");

// Retexture all players
{
	_texture = _x getVariable "texture";
	if(!isNil "_texture") then
	{
		[_x,_texture] spawn setPlayerTexture;
	};
} foreach (allMissionObjects "Man");
