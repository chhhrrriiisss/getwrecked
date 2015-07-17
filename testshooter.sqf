_v = (vehicle player);

// player action ['eject', _v];
_shooter = _v getVariable ['shooter', nil];
_unit = nil;

if (isNil "_shooter") then {
	
	_g =createGroup civilian;
	(typeof player) createUnit [ _v modelToWorld [0,10,0], _g,"GW_Shooter = this;", 0.6, "corporal"];
	_tx = player getVariable ["GW_Sponsor", ""];

	_unit = GW_Shooter;

	removeAllActions _unit;
	removeAllWeapons _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeGoggles _unit;
	removeAllPrimaryWeaponItems _unit;
	removeallassigneditems _unit;

	_unit setDir (getDir (_v));

	_unit addEventHandler['handleDamage', { false }];


	switch (_tx) do {
		
		case "tyraid": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
		case "crisp": { _unit addheadgear "H_RacingHelmet_1_red_F"; };
		case "gastrol": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
		case "haywire": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
		case "cognition": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
		case "terminal": { _unit addheadgear "H_RacingHelmet_1_red_F"; };
		case "tank": { _unit addheadgear "H_RacingHelmet_1_black_F"; };
		case "veneer": { _unit addheadgear "H_RacingHelmet_1_white_F"; };
		default { _unit addheadgear "H_RacingHelmet_1_black_F"; };
	};

	[[_unit,_tx],"setPlayerTexture",true,false] call bis_fnc_mp;
	_v setVariable ['shooter', _unit];
	_unit addWeapon "launch_RPG32_F";

	_pPos = _v worldToModelVisual (ASLtoATL visiblePositionASL player);
	_pPos set[0, (_pPos select 0) - 0.45];
	_pPos set[1, (_pPos select 1) - 0.2];
	_unit setPos (_v modelToWorldVisual _pPos);

	_vect = [_unit, _v] call getVectorDirAndUpRelative;
	_vect set [1, (_vect select 1) vectorAdd [-0.3, -0.3, 0] ];

	_unit attachTo [_v];
	_unit setVectorDirAndUp _vect;

};

_v animateDoor ["Door_LF", 1, FALSE];
Sleep 0.5;
_unit = _v getVariable 'shooter';
player hideObject true;
_unit hideObject false;
_unit switchMove "amovpknlmstpsraswlnrdnon";
GW_SHOOTER_ACTIVE = true;

_unit spawn { 
	_vel = velocity (vehicle player);
	_up = vectorUp (vehicle player);
	_dir = direction (vehicle player);
	_speed = 0.7;

	while {GW_SHOOTER_ACTIVE} do {
		if (!alive _this) exitWith {};		
		_this playMove "amovpknlmstpsraswlnrdnon";
	};

};

// sleep 2;

// detach player;

// player moveInDriver _v;

Sleep 10;

_v animateDoor ["Door_LF", 0, false];
GW_SHOOTER_ACTIVE = false;
_unit hideObject true;
player hideObject false;
