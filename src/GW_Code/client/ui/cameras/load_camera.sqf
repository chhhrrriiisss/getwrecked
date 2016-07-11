//
//      Name: loadCamera
//      Desc: Loading camera used while scripts compiling
//      Return: None
//

if (isNil "GW_LOADING_ACTIVE") then {
	GW_LOADING_ACTIVE = false;
};

if (isNil "loadCameras") then {
	loadCameras = ['loadCamera'] call findAllObjects;
};

if (GW_LOADING_ACTIVE) exitWith {};
GW_LOADING_ACTIVE = true;

99999 cutText ["", "BLACK", 0.5]; 

Sleep 0.5;

showCinemaBorder false;
// showChat false;
GW_HUD_ACTIVE = false;

"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectAdjust [0.4, 1.1, -0.1, [1, 1, 1, 0], [1, 1, 1, 0], [0.75, 0.25, 0, 1.0]]; 
"colorCorrections" ppEffectCommit 0;

"filmGrain" ppEffectEnable false;  
"filmGrain" ppEffectAdjust [0.04, 1, 1, 0, 1]; 
"filmGrain" ppEffectCommit 0; 



_condition = [_this, 0, { false }, [{}]] call filterParam;

_length = (count loadCameras);
_rnd = floor (random _length);
_loadCamera = loadCameras select _rnd;
_pos = getPos _loadCamera;
_target = _loadCamera getVariable ['GW_LOADING_TARGET', [0,0,0]];

_camera = "camera" camCreate _pos;
_camera camPrepareTarget _target;
_camera camPreparePos _pos;
_camera camPrepareFOV 0.700;
_camera camCommitPrepared 0;
_camera cameraeffect["internal","back"];
_camera camCommit 0;

99999 cutText ["", "BLACK IN", 0.5]; 

Sleep 0.5;

_timeout = time + 5;

for "_i" from 0 to 1 step 0 do {
	if (time > _timeout || (call _condition)) exitWith { 99999 cutText ["", "BLACK", 0.5];  };
	Sleep 1;	
};

Sleep 0.5;

// Tidy up, reset camera position
showChat true;		
player cameraeffect["terminate","back"];
camdestroy _camera;

"colorCorrections" ppEffectEnable false; 
"colorCorrections" ppEffectCommit 0;

"filmGrain" ppEffectEnable false;
"filmGrain" ppEffectCommit 0;

99999 cutText ["", "BLACK IN", 0.5]; 

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
_layerStatic cutRsc ["RscStatic", "PLAIN" , 5];

// titlecut["","PLAIN DOWN",1];

GW_LOADING_ACTIVE = false;
