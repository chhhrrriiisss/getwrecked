//
//      Name: drawServiceIcon
//      Desc: Draw an icon on the hud for a service zone
//      Return: None
//

_pos = _this select 0;
_defaultIcon =_this select 1;
_activeIcons = _this select 2;
_maxVisibleRange = _this select 3;
_type = _this select 4;

_distance = _pos distance GW_CURRENTVEHICLE;
_size = (1 - ((_distance / _maxVisibleRange) * 0.6)) * 1.4;
_alpha = (_maxVisibleRange - _distance) / (_maxVisibleRange);

if (_alpha <= 0) exitWith {};

_colour = [1,1,1,_alpha];

_inUse = GW_CURRENTVEHICLE getVariable ["inUse", false];

if (_distance < 8 && _type != "") then {	
	GW_CURRENTVEHICLE setVariable ["GW_NEARBY_SERVICE", _type]; 
};	

//If the player is really close and we have an animated icon set switch icons to an 'active' state
if (count _activeIcons > 0 && _inUse) exitWith {

	// Every 5 seconds increase the tick on the animation
	if (time - GW_LASTTICK > 0.5) then {
		GW_LASTTICK = time;
		GW_ANIMCOUNT = GW_ANIMCOUNT + 1;
		GW_ANIMCOUNT = if (GW_ANIMCOUNT >=  (count _activeIcons)) then { 0 } else { GW_ANIMCOUNT };
	};

	_icon = _activeIcons select GW_ANIMCOUNT;

	drawIcon3D [_icon, _colour, _pos, _size, _size, 0, "", 0.01];					

};

drawIcon3D [_defaultIcon, _colour, _pos, _size, _size, 0, "", 0.01];	
