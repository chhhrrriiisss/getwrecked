//
//      Name: setObjectProperties
//      Desc: Set handlers and object variables for items
//      Return: None
//

private["_obj"];

// _obj = [_this,0, objNull, [objNull]] call filterParam;

// if (isNull _obj) exitWith {};
// if (!alive _obj) exitWith {};

// _type = typeOf _obj;
// _subType = _obj getVariable ["type", ''];
// _isHolder = if (_type == "GroundWeaponHolder" && _subType in GW_HOLDERARRAY) then { true } else { false };

// if (_isHolder) then {
// 	_type = _subType;
// };

// if (_obj isKindOf "StaticWeapon" || _isHolder) then { // Static weapons and Weaponholders
// 	_obj setVehicleAmmo 0;		
// 	_obj lockDriver true;
// 	_obj lockCargo true;
// 	_obj lockTurret [[0], true];
// 	_obj lockTurret [[0,0], true];
// };

// if (!_isHolder) then {
// 	clearWeaponCargoGlobal _obj;
// 	clearMagazineCargoGlobal _obj;
// 	clearItemCargoGlobal _obj;
// 	_obj lockCargo true;
// };


// _objData = [_type, GW_LOOT_LIST] call getData;
// if (isNil "_objData") exitWith {};

// _name = _objData select 1;
// _mass = _objData select 2;
// _health = _objData select 3;
// _ammo = _objData select 4;
// _fuel = _objData select 5;
// _tag = _objData select 6;

// _obj setVariable["name", _name, true];
// _obj setVariable["mass", _mass, true];
// _obj setVariable["ammo", _ammo, true];
// _obj setVariable["fuel", _fuel, true];

// if (count (toArray _tag) > 0) then {

// 	if (_tag in GW_WEAPONSARRAY) then {
// 		_type = _tag;
// 		_gun = _obj;
// 		_marker = _obj getVariable ["targetMarker", _obj];
// 		_obj setVariable["weapons", [_type, _gun, _marker], true];
// 		_obj setVariable ["GW_KeyBind", (_obj getVariable ["GW_KeyBind", ["-1", "1"]]) , true];
// 	};

// 	if (_tag in GW_TACTICALARRAY) then {

// 		_type = _tag;
// 		_obj setVariable["tactical", [_type, _obj, _name], true];
// 		_obj setVariable ["GW_KeyBind", (_obj getVariable ["GW_KeyBind", ["-1", "1"]]) , true];
// 	};

// 	if (_tag in GW_SPECIALARRAY) then {

// 		_type = _tag;
// 		_obj setVariable["special", _type, true];
// 	};
	
// };	

true

