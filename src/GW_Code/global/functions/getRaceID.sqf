//
//      Name: getRaceID
//      Desc: Return index reference and object of race from name
//      Return: Object (The location) or [0,0,0] if none found
//

private ['_targetRace', '_id'];

_targetRace = [];
_id = -1;

{
	if (_this == ((_x select 0) select 0) ) exitWith {
		_targetRace = _x;
		_id = _forEachIndex;
	};
} foreach GW_ACTIVE_RACES;

[_targetRace, _id]