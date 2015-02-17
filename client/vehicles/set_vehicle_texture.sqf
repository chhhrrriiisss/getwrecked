//
//      Name: setVehicleTexture
//      Desc: Applies a texture to a vehicle
//      Return: None
//

private ['_vehicle', '_tx', '_class', '_file', '_path'];

_vehicle = [_this,0, ObjNull, [ObjNull]] call BIS_fnc_param;
_tx = [_this,1, "", [""]] call BIS_fnc_param;

if(isNull _vehicle || _tx == "") exitWith { diag_log 'Couldnt apply texture - blank or no texture'; };
if (!(_tx in GW_TEXTURES_LIST) && !(_tx in GW_SPECIAL_TEXTURES_LIST)) exitWith { diag_log 'Couldnt apply texture - not in texture list'; };

_class = typeOf _vehicle;
_file =  format['client\images\vehicle_textures\%1\%1.jpg', toLower(_tx)];
_textureArray = [_file];

// Shield is a custom texture specifically for the shield generator
{	
	_baseClass = (_x select 0);
	if (_class == _baseClass) exitWith {

		_textureArray = [];
		_selectionList = (_x select 1);

		{	

			if (!isNil "_x") then {

				// Use the array information to print a texture for each selection
				_texture = switch (_x) do {
					case "": { _baseClass };
					case "default":{ _tx };
					default	{_x	};
				};

				_textureArray set [count _textureArray, format['client\images\vehicle_textures\%1\%2.jpg', toLower(_tx), toLower(_texture)] ];
			};

		} ForEach _selectionList;
	};	

	false
	
} count GW_TEXTURES_SPECIAL > 0;

//Local to us? Set it's color.
if(local _vehicle) then
{
	_vehicle setVariable["paint",_tx,true];
};

waitUntil{!isNil {_vehicle getVariable "paint"}};

{
	_vehicle setObjectTexture[_foreachindex,_x];
} ForEach _textureArray;
