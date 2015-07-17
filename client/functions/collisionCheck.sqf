//
//      Name: collisionCheck
//      Desc: Check for a collision between all melee items on vehicle
//      Return: None
//

private ['_v'];

_v = _this;

_startTime = time;

if (isNil "getMeleeOffsets") then {

	getMeleeOffsets = compileFinal "
	if (_this == 'WBR') exitWith {				
		[
			[ [-(_w/3), (_l/2), 0], [-(_w/3), (-_l/2), 0] ],
			[ [(_w/3), (_l/2), 0], [(_w/3), (-_l/2), 0] ]
		]
	};
	if (_this == 'FRK') exitWith {				
		[
			[ [-(_w/2), (_l/2), -(_h/2)], [(_w/2), (_l/2), -(_h/2)] ],
			[ [-(_w/2), -(_l/2), -(_h/2)], [(_w/2), -(_l/2), -(_h/2)] ]
		]
	};
	if (_this == 'HOK') exitWith {
		[
			[ [0, (_l/2), (_h/2)], [0, (-_l/2), (_h/2)] ],
			[ [-(_w/2), (_l/2), -(_h/2)], [-(_w/2), (-_l/2), -(_h/2)] ],
			[ [(_w/2), (_l/2), -(_h/2)], [(_w/2), (-_l/2), -(_h/2)] ]
		]
	};
	if (_this == 'CRR') exitWith {
		[
			[ [0, (_l/2), 0], [0, (-_l/2), 0] ]
		]
	};
	[
		[ [0, (_l/2), 0], [0, (_l/2), 0] ]
	]
	";
};

{
	_source = _x;
	_box = [_source] call getBoundingBox;
	_w = _box select 0;
	_l = _box select 1;
	_h = _box select 2;
	_t = 0.98;

	_tag = (_source getVariable ['GW_Tag', '']);
	_points = [];
	{
		_arr1 = [((_x select 0) select 0) * _t, ((_x select 0) select 1) * _t, ((_x select 0) select 2) * _t];
		_arr2 = [((_x select 1) select 0) * _t, ((_x select 1) select 1) * _t, ((_x select 1) select 2) * _t];
		_points pushBack [(_source modelToWorldVisual _arr1), (_source modelToWorldVisual _arr2)];
		false
	} count (_tag call getMeleeOffsets);

	{ 

		_p1 = (_x select 0);
		_p2 = (_x select 1);

		if (GW_DEBUG) then { [_p1, _p2, 0.001] spawn renderLine; };

		_objs = lineIntersectsWith [ATLtoASL _p1, ATLtoASL _p2, _v, _source];

		if (count _objs == 0) then {} else {

			_obj = nil;
			{		
				if (isNull (attachedTo _x)) exitWith { _obj = _x; false };
				if ((attachedTo _x) != _v) exitWith { _obj = _x; false };
				false
			} count _objs;

			if (isNil "_obj") exitWith {};
			if ((typeOf _obj) isEqualTo "") exitWith {};
			if ({ if (_obj isKindOf _x) exitWith {1}; false	} count ["ReammoBox", "Man", "ThingEffect", "RopeSegment"] isEqualTo 1) exitWith {};

			_vectInc = [(ASLtoATL visiblePositionASL _obj), (ASLtoATL visiblePositionASL _source)] call bis_fnc_vectorFromXToY;
			_vectOut = [(ASLtoATL visiblePositionASL _source), (ASLtoATL visiblePositionASL _obj)] call bis_fnc_vectorFromXToY;	
			_targetVehicle = if (!isNull attachedTo _obj) then { (attachedTo _obj)	} else { _obj };									

			if (_v isEqualTo _targetVehicle) exitWith {};

			_speed = ((velocity _targetVehicle) distance [0,0,0]) * 0.1;
			_command = switch (_tag) do {						
				case "FRK": {  meleeFork };
				case "CRR": {  meleePylon };
				case "HOK": {  meleeHook };
				case "WBR": {  meleeRam };
				default
				{ {true} };
			};
			
			_collision = [_source, _obj, _speed] call _command;			

			if (_collision) then { [_this, _vectInc, _targetVehicle, _vectOut] call createCollision; };						

			false	

		};

	} count _points;		

	false

} count (attachedObjects _v);

['Melee Update', (format['%1', ([time - _startTime, 2] call roundTo)])] call logDebug;

true