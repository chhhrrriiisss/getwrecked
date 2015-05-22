//
//      Name: impactEffect
//      Desc: Metal debris scattered at location
//     

_source = [_this,0, objNull, [objNull, []]] call filterParam;
_offset = [_this,1, [0,0,0], [[]]] call filterParam;
_size = [_this,2, 5, [0]] call filterParam;

if (typename _source == "OBJECT" && { isNull _source }) exitWith {};
if ((_source distance [0,0,0] < 1)) exitWith {};

_pos = if (typename _source == "OBJECT") then { (ASLtoATL visiblePositionASL _source) } else { _source };
_isVisible = [_pos, 0.5] call effectIsVisible;
if (!_isVisible) exitWith {};

_pos = if (typename _source isEqualTo "ARRAY") then { (_source vectorAdd _offset) } else { (_source modelToWorldVisual _offset) };
if ((_pos select 2) < 0) then { _pos set [2, 0]; };

for "_i" from 0 to ([(random _size), 3, 40] call limitToRange) step 1 do {

	_debris = createVehicle [format["FxExploArmor%1", (ceil (random 3) + 1)], _pos, [], 0, 'CAN_COLLIDE']; 
	_debris setDir (random 360);
	_debrisTarget = _debris modelToWorldVisual [random _size, random _size, random _size];
	_vector = [_pos, _debrisTarget] call BIS_fnc_vectorFromXToY;	
	_velocity = [_vector, _size] call BIS_fnc_vectorMultiply; 

	_debris setVectorDir _vector;
	_debris setVelocity _velocity;

	_debris spawn {
		Sleep 5;
		deleteVehicle _this;
	};	

};