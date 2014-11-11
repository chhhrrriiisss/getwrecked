//systemchat 'attach function called';

_target = _this select 0;
_source = _this select 1;
_duration = _this select 2;

if (!alive _target || !alive _source || _duration == 0) exitWith {};

_status = _target getVariable ["status", []];

if ('forked' in _status) exitWith {};

//systemchat format['forking %1', time];

//_vector = _target call BIS_fnc_getPitchBank;


// _pos = _source worldToModelVisual (ASLtoATL visiblePositionASL _target);
_dir = getDir _target;
_sourceDir = getDir _source;
_targetDir = [_sourceDir - _dir] call normalizeAngle;

// _sourceHeight = ([_source] call getBoundingBox) select 2;

// _actualHeight = ((_source modelToWorldVisual [0,0,0]) select 2) - (_sourceHeight / 2);
// _pos set[2, _actualHeight];

_target attachTo [_source, [0,2,0]];

_target setDir _targetDir;
//[_target, _vector] call setPitchBankYaw;

//systemchat format['%1 / %2', (_this select 0), (_this select 1)];

Sleep 3;

detach _target;


