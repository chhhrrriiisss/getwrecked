private ['_ang', '_lastPos', '_of', '_tag', '_obj'];

_lastPos = [0,0,0];
_ang = if (_this call isHolder) then { [60, 120] } else { [-30, 30] };
_colour = if (isNil { player getVariable "GW_editingObject"}) then { [1,0,0,1] } else { [1,1,1,1] };
_of = if (_this call isHolder) then { [0,0,-0.6] } else { 
	[0,0,0] 
};

_tag = _this getVariable ['GW_Tag', ''];

if (_tag == "FLM") then { _ang = [-210, -150]; };
if (_tag == "RPD") then { _ang = [-120, -60]; };
if (_tag == "HMG" || _tag == "GMG") then { _of = [-0.1,0.2,-1]; };
if (_tag == "HAR") then { _ang = [-300, -240]; };
if (_tag == "LSR") then { _ang = [-210, -150]; };
	
for "_i" from (_ang select 0) to (_ang select 1) step 5 do {

	_rx = 2.5 * (sin _i) * (cos 1);
	_ry = 2.5 * (cos _i) * (cos 1);

	if (_i == (_ang select 0) || _i == (_ang select 1)) then {
		[ (_this modelToWorldVisual [(_rx * 0.93)  + (_of select 0), (_ry * 0.93) + (_of select 1), 0 + (_of select 2)]), (_this modelToWorldVisual [_rx  + (_of select 0), _ry + (_of select 1), 0 + (_of select 2)]), 0.01, _colour] spawn renderLine; 		
	};

	if (_lastPos distance [0,0,0] > 1) then {
		[_lastPos, (_this modelToWorldVisual [_rx  + (_of select 0), _ry + (_of select 1), 0 + (_of select 2)]), 0.01, _colour] spawn renderLine; 		
	};

	_lastPos = _this modelToWorldVisual [_rx + (_of select 0), _ry + (_of select 1), 0 + (_of select 2)];
};
