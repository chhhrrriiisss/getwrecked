//
//      Name: vehicleTag
//      Desc: Draws a custom tag for vehicles and players currently in range
//      Return: None
//

_vehicle = _this select 0;

if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {};

_owner = _vehicle getVariable ["owner", ""];

// If it has no owner, just skip it
if (count toArray _owner == 0 || _owner == "") exitWith {};

// Determine if the tag should be shown based off of signature distance
_dist = GW_CURRENTVEHICLE distance _vehicle;
_signature = _vehicle getVariable ['signature', 'Low'];

_visibleRange = _signature call {
	
	if (_this == "Large") exitWith { 450 };
	if (_this == "Medium") exitWith { 350 };
	if (_this == "Low") exitWith { 250 };
	if (_this == "Tiny") exitWith { 150 };
	250
};

if (_dist > _visibleRange) exitWith {};

// Adjust the alpha of the tag based off of distance
_alpha = [(1 - (_dist/_visibleRange)), 0, 1] call limitToRange;
_color = [0.99,0.14,0.09, _alpha];

_crew = crew _vehicle;
_name = _vehicle getVariable ["name", ""];
_health = _vehicle getVariable ['health', 100]; 

// If its empty or our own vehicle, make it white
if (_owner == GW_PLAYERNAME || count _crew == 0) then {
	_color = [1,1,1, (_alpha * 0.5)];
};	

// If the name is blank, come up with something a bit more interesting
_str = if (count toArray _name == 0 || _name == ' ') then {	'Untitled' } else { _name };

// Long names are not cool
_str = [_str, 28, '...'] call cropString;

// Determine if object is visible (based off of multiple points)
// This is necessary as with large amounts of attached items in the way the vehicle tag sometimes doesnt show at all
_visible = true;
{
	_count = lineIntersectsWith[ATLtoASL (_x select 0), ATLtoASL (GW_CURRENTVEHICLE modelToWorldVisual [0,0,2]), GW_CURRENTVEHICLE, _vehicle];

	// If no obstructions, its visible
	if (count _count == 0) then {
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
	[ (_vehicle modelToWorldVisual [0,4,0]) ],
	[ (_vehicle modelToWorldVisual [0,-4,0]) ]
];

// If there's an obstruction, or the vehicle is cloaked/hidden
_status = _vehicle getVariable ["status", []];
_lastSeen = _vehicle getVariable ['lastSeen', nil];
if (_vehicle == GW_CURRENTVEHICLE) then { _visible = true; };

if ( !_visible || ('cloak' in _status) || ('nolock' in _status) ) then {
	if (isNil "_lastSeen") then { _vehicle setVariable ['lastSeen', time]; _lastSeen = time; };
	_alpha = _alpha - (0.35 * (time - _lastSeen));
} else {	
	if (!isNil "_lastSeen") then { _vehicle setVariable ['lastSeen', nil]; };
	_alpha = _alpha + 0.05;
};

_pos = (_vehicle modelToWorldVisual [0,0,1]);
if ( (_pos select 2) < 1) then { _pos set[2, 1]; };

_maxLength = 3.8 * ( (300 - _dist) / 300);
_length = (_maxLength * (_health / 100));
_cL = _length call {

	if (_this >= (_maxLength * 0.75)) exitWith { [0.25,0.65,0,0.5] };
	if (_this >= (_maxLength * 0.5)) exitWith { [0.8,0.65,0.137, 0.5] };
	if (_this >= (_maxLength * 0.25)) exitWith { [1,0,0,0.3] };
	[1,0,0,1]
};

_alpha = [(_alpha * 0.5), 0, 0.5] call limitToRange;
_cL set [3, _alpha];

if ('nanoarmor' in _status) then { _cL = [0,0,0,0.6]; };
if ('overcharge' in _status) then { _cL = [1,0.424,0,0.6]; };

drawIcon3D [
	uiBar,
	([0,0,0, (_alpha / 2)]),
	_pos,
	_length + 0.05,
	0.2,
	0,
	'',
	0,
	0.028,
	"PuristaMedium"
];

drawIcon3D [
	uiBar,
	_cL,
	_pos,
	_length,
	0.15,
	0,
	'',
	0,
	0.028,
	"PuristaMedium"
];




