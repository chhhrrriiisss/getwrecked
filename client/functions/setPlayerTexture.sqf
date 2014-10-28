//
//      Name: setPlayerTexture
//      Desc: Sets player texture to the specified sponsor
//      Return: None
//

private ['_vehicle', '_tx', '_class', '_file', '_path'];

_player = [_this,0, ObjNull, [ObjNull]] call BIS_fnc_param;
_tx = [_this,1, "", [""]] call BIS_fnc_param;

if(isNull _player || _tx == "") exitWith {};

_path = format['client\images\player_textures\%1.jpg', toLower(_tx)];

//Local to us? Set a variable
if(local _player) then
{
	_player setVariable["texture", _tx, true];
};

waitUntil{!isNil {_player getVariable "texture"}};

_player setObjectTexture[0,_path];
