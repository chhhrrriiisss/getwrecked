//
//      Name: setupObject
//      Desc: Server based setup up of object
//      Return: None
//

_obj = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _obj) exitWith {};
if (!alive _obj) exitWith {};

_type = typeOf _obj;
_tag = _obj getVariable ["GW_Tag", ''];

_ref = if (_tag isEqualTo '') then { _type } else { _tag };
_data = [_ref, GW_LOOT_LIST] call getData; 
if (isNil "_data") exitWith {};

_class = _data select 0;
_health = _data select 3;
_tag = _data select 6;

_isHolder = _obj call isHolder;

_obj enableSimulationGlobal false;
_obj setVariable ["GW_Tag", _tag, true];
_obj setVariable ["GW_Owner", '', true];
_obj setVariable ["GW_Health", _health, true];

if (_obj isKindOf "StaticWeapon" || _isHolder) then { // Static weapons and Weaponholders
	_obj setVehicleAmmo 0;		
	_obj lockDriver true;
	_obj lockCargo true;
	{_obj lockturret [[_x],true]} forEach [0,1,2];
};

if (!_isHolder) then {
	clearWeaponCargoGlobal _obj;
	clearMagazineCargoGlobal _obj;
	clearItemCargoGlobal _obj;
	_obj lockCargo true;
};

