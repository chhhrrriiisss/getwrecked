//
//      Name: addToTagList
//      Desc: Keeps track of vehicles that are in LOS of the player and stores the time last seen
//      Return: Time (Last seen at)
//

private ['_v'];

_v =  _this select 0;

if (isNull _v) exitWith {};

_lastSeen = time;
_found = false;

// Loop through the tag list, check it doesnt already exist
{
	if (_x select 0 == _v) exitWith {
		_lastSeen = _x select 1;
		_found = true;
	};
} count GW_TAGLIST > 0;

// If it does, return the time last seen
if (_found) exitWith {
	_lastSeen
};

// Otherwise create a new entry and store time
GW_TAGLIST pushBack [_v, time];

time	