//
//      Name: dropObj
//      Desc: Place an object on the ground rather than attaching it
//      Return: Bool (Success)
//

private ["_obj", "_unit"];

_unit = [_this,0, objNull, [objNull]] call filterParam;
_obj = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _unit) exitWith { false };

removeAllActions _obj;
removeAllActions _unit;

_unit spawn setPlayerActions;

GW_EDITING = false;

// Add the appropriate actions for the object
[_obj] spawn setTagAction;
_isSupply = _obj call isSupplyBox;
if (_isSupply) then { [_obj] spawn setSupplyAction; } else { [_obj] spawn setMoveAction; _obj setVariable ['GW_Owner', '', true]; };

_unit setVariable ['GW_EditingObject', nil];

// Wait a second before aligning the object
Sleep 0.5;

_dir = getDir _obj;
_pos = (getPosATL _obj);
_pos set [2,0];
_obj setPosATL _pos;

[_obj, [0,0, _dir]] call setPitchBankYaw;

_objs = nearestObjects [_pos, [], 3];

if (count _objs <= 0 || (typeOf _obj == "Land_PaperBox_closed_F")) exitWith { true };

// If there's a supply box nearby, place the item in it
{
	_isSupply = _x call isSupplyBox;
	_isOwner = [_x, player, false] call checkOwner;

	if (_isSupply && _isOwner) exitWith {
		[_x, _obj] spawn addItemSupplyBox;
	};

} ForEach _objs;

true