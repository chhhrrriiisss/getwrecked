//
//      Name: vehicleTag
//      Desc: Draws a custom tag for vehicles and players currently in range
//      Return: None
//

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {};

// Determine if the tag should be shown based off of signature distance
_dist = player distance _vehicle;
_data = [typeOf _vehicle, GW_VEHICLE_LIST] call getData;
_signature = if (!isNil "_data") then { ((_data select 2) select 7) } else { "" };
_visibleRange = switch (_signature) do { case "Large": { 450 }; case "Medium": { 350 }; case "Low": { 250 }; case "Tiny": { 150 }; default { 250 }; };
if (_dist > _visibleRange) exitWith {};

// Adjust the alpha of the tag based off of distance
_alpha = (1 - (_dist/_visibleRange));
_alpha = [_alpha, 0, 1] call limitToRange;
_color = [0.99,0.14,0.09, _alpha];

_crew = crew _vehicle;
_health = format['%1%2', round((1 - getDammage _vehicle) * 100), '%'];
_name = _vehicle getVariable ["name", ""];
_owner = _vehicle getVariable ["owner", ""];

// If its empty or our own vehicle, make it white
if (_owner == GW_PLAYERNAME || (count _crew) == 0) then {
	_color = [1,1,1, _alpha];
};	

// If it has no owner, just skip it
if (count toArray _owner == 0 || _owner == "") exitWith {};

// If the name is blank, come up with something a bit more interesting
_str = if (count toArray _name == 0 || _name == ' ') then {	
	_driver = (driver _vehicle);
	_name = format["%1's vehicle", _owner];
	if (!isNull _driver) then {
		_name = format["%1", name _driver];
	};
	_name
} else {
	_name
};

// Long names are not cool
_str = [_str, 30, '...'] call cropString;

// Adjust the tag when people are on foot
_currentZoom = if (cameraView == 'Internal' || _dist < 2) then { 2 * round (call getZoom) } else { round (call getZoom) };
_box = [_vehicle] call getBoundingBox;
_height = _box select 2;
_width = _box select 1;
_length = _box select 0;
_pos = _vehicle modelToWorldVisual [0,0,_height/2];

// Change the source height for players not in a vehicle
_playerPos = if (player == (vehicle player)) then { eyePos player } else {
	_p = getPosASL (vehicle player);
	_p set[2, 2];
	(ATLtoASL _p)
};

// Determine if object is visible (based off of multiple points)
// This is necessary as with large amounts of attached items in the way the vehicle tag sometimes doesnt show at all
_visible = false;
{
	_count = lineIntersectsWith[ATLtoASL (_x select 0), _playerPos, (vehicle player), _vehicle];

	// If no obstructions, its visible
	if (count _count <= 0) then {
		_visible = true;
	};

	if (GW_DEBUG) then {

		drawIcon3D [

			blankIcon,
			colorRed,
			(_x select 0),
			0,
			1,
			1,
			'x',
			0,
			0.035,
			"PuristaMedium"
		];

	};
	false
} count [ 
	[ (_vehicle modelToWorld [0,_length * 2,0]) ],
	[ (_vehicle modelToWorld [0,_length * -2,0]) ],
	[ (_vehicle modelToWorld [ (_width/ 2),0,0]) ],
	[ (_vehicle modelToWorld [-(_width / 2),0,0]) ],
	[ (_vehicle modelToWorld [0,0, (_height / 2) + 1]) ]
];

// If there's an obstruction, or the vehicle is cloaked/hidden
_status = _vehicle getVariable ["status", []];
_color = if ( !_visible || ('cloak' in _status) || ('nolock' in _status) ) then {

	_lastSeen = [_vehicle] call addToTagList;
	_color set[3, (_color select 3) - (0.35 * (time - _lastSeen))];
	_color

} else {
	
	[_vehicle] call removeFromTagList;
	_color set[3, (_color select 3) + 0.1];
	_color
};

// No point rendering if its invisible eh?
if ((_color select 2) <= 0) exitWith {};

drawIcon3D [
	blankIcon,
	_color,
	_pos,
	1,
	1,
	0,
	format['%1 / %2', _name, _health],
	0,
	0.035,
	"PuristaMedium"
];

