_points = [(_this select 0), (_this select 1)]; 
_time = [_this,2, 0.1, [0]] call filterParam;
GW_LINEEFFECT_COLOR = [_this,3, [1,0,0,1], [[]]] call filterParam;

GW_LINEFFECT_ARRAY pushback _points;

Sleep _time;

GW_LINEFFECT_ARRAY = GW_LINEFFECT_ARRAY - [ _points ];
