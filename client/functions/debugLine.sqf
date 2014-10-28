_points = [(_this select 0), (_this select 1)]; 

GW_LINEEFFECT_COLOR = [1, 0, 0, 1];
GW_LINEFFECT_ARRAY pushback _points;

Sleep (_this select 2);

GW_LINEFFECT_ARRAY = GW_LINEFFECT_ARRAY - [ _points ];
