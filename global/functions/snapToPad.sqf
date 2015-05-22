private ['_v', '_closest'];

_v = _this select 0;

// Spawn a check in case the vehicle gets too far from the pad center
[_v, (ASLtoATL visiblePositionASL ([saveAreas, (ASLtoATL visiblePositionASL _v)] call findClosest))] spawn {
		Sleep 2;
		if ((_this select 0) distance (_this select 1) > 3) then {
			(_this select 1) set [2, 1];
			(_this select 0) setPos (_this select 1);
		};
};