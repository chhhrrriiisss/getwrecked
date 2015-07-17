//
//      Name: setVehicleTexture
//      Desc: Applies a texture to a vehicle
//      Return: None
//

private ['_vehicle', '_tx', '_class', '_file', '_path'];



_vehicle = [_this,0, objNull, [objNull]] call filterParam;
_tx = [_this,1, "", [""]] call filterParam;

diag_log format['Applying texture %1 to %2 at %3.', _tx, typeof _vehicle, time];

if(isNull _vehicle) exitWith { diag_log 'Couldnt apply texture - bad vehicle target'; };
if (count toArray _tx == 0) exitWith { diag_log format['Couldnt apply texture %1 - blank or no texture', _tx]; };
if (!(_tx in GW_TEXTURES_LIST) && !(_tx in GW_SPECIAL_TEXTURES_LIST)) exitWith { diag_log format['Couldnt apply texture %1 - not in texture list', _tx]; };

//Local to us? Set it's color.
if(local _vehicle) then { _vehicle setVariable["GW_paint",_tx,true]; };

// Abort if server or no display (no need to set texture on something that cant see it)
if (isDedicated || !hasInterface) exitWith {};

_timeout = time + 5;
waitUntil{ ((!isNil {_vehicle getVariable "GW_paint"}) || (time > _timeout)) };

_class = typeOf _vehicle;
_file =  format['client\images\vehicle_textures\%1\%1.jpg', toLower(_tx)];
_textureArray = [_file];

{	
	_baseClass = (_x select 0);
	if (_class == _baseClass) exitWith {

		_textureArray = [];
		_selectionList = (_x select 1);

		{	

			if (!isNil "_x") then {

				// Use the array information to print a texture for each selection
				// _texture = switch (_x) do {
				// 	case "": { _baseClass };
				// 	case "default":{ _tx };
				// 	default	{_x	};
				// };

				_texture = _tx;
				_textureArray set [count _textureArray, format['client\images\vehicle_textures\%1\%2.jpg', toLower(_tx), toLower(_texture)] ];
			};

		} ForEach _selectionList;
	};	

	false
	
} count GW_TEXTURES_SPECIAL > 0;

{
	_vehicle setObjectTexture[_foreachindex,_x];
} foreach _textureArray;
