//
//      Name: previewCamera
//      Desc: Preview camera used to display a remote location
//      Return: None
//

// Close if there's a camera already active
if (GW_PREVIEW_CAM_ACTIVE) exitWith {};
GW_PREVIEW_CAM_ACTIVE = true;

// Close HUD if open
GW_HUD_ACTIVE = false;

GW_PREVIEW_CAM_TARGET = _this select 0;
waitUntil { !isNil "GW_PREVIEW_CAM_TARGET" };

// Collect camera defaults
GW_PREVIEW_CAM_RANGE = [_this,1, 10, [0]] call BIS_fnc_param;
GW_PREVIEW_CAM_THETA = [_this,2, 0, [0]] call BIS_fnc_param;
GW_PREVIEW_CAM_PHI = [_this,3, 1, [0]] call BIS_fnc_param;
GW_PREVIEW_CAM_HEIGHT = [_this,4, 1, [0]] call BIS_fnc_param;
GW_PREVIEW_CAM_POS = if (typename GW_PREVIEW_CAM_TARGET == "OBJECT") then { (getPosASL GW_PREVIEW_CAM_TARGET) } else { GW_PREVIEW_CAM_TARGET };
GW_PREVIEW_CAM_POS set[2, GW_PREVIEW_CAM_HEIGHT];

// Create the camera
GW_PREVIEW_CAM = "camera" camCreate GW_PREVIEW_CAM_POS;
GW_PREVIEW_CAM camSetTarget GW_PREVIEW_CAM_POS;
GW_PREVIEW_CAM cameraeffect["internal","back"];
GW_PREVIEW_CAM camCommit 0;

// Determine orbit position
_theta = if (typename GW_PREVIEW_CAM_THETA == "STRING") then {  _th = parseNumber (GW_PREVIEW_CAM_THETA); GW_PREVIEW_CAM_THETA = 0; _th } else { random 360 };
_r = 7;
_phi = 1;
_rx = _r * (sin _theta) * (cos _phi);
_ry = _r * (cos _theta) * (cos _phi);
_rz = _r * (sin _phi);

// Apply to camera
GW_PREVIEW_CAM camSetPos [(GW_PREVIEW_CAM_POS select 0) +_rx, (GW_PREVIEW_CAM_POS select 1) + _ry, GW_PREVIEW_CAM_HEIGHT];
GW_PREVIEW_CAM_LASTPOS = [0,0,0];
showCinemaBorder false;
showChat false;

for "_i" from 0 to 1 step 0 do {

	if (!GW_PREVIEW_CAM_ACTIVE) exitWith {};

	// If there's a target available
	if (!isNil "GW_PREVIEW_CAM_TARGET") then {	

		_pos = if (typename GW_PREVIEW_CAM_TARGET == "OBJECT") then { (getPosASL GW_PREVIEW_CAM_TARGET) } else { GW_PREVIEW_CAM_TARGET };
		
		GW_PREVIEW_CAM_POS = if (_pos distance GW_PREVIEW_CAM_POS > 15) then {
			99999 cutText ["", "BLACK IN", 0.35];  
			_theta = random 360;
			_pos			
		} else {
			GW_PREVIEW_CAM_POS
		};

	} else {
		99999 cutText ["", "BLACK OUT", 0.1];  		
		GW_PREVIEW_CAM_POS = GW_PREVIEW_CAM_LASTPOS;
	};

	if (!isNil "GW_PREVIEW_CAM_POS") then {

		if (typename GW_PREVIEW_CAM_POS != "OBJECT") then {

			// Loop, while updating orbit position
			_tx = GW_PREVIEW_CAM_POS select 0;
			_ty = GW_PREVIEW_CAM_POS select 1;
			_tz = GW_PREVIEW_CAM_HEIGHT;

			_theta = _theta + GW_PREVIEW_CAM_THETA;
			_theta = _theta mod 360;

			_rx = _r * (sin _theta) * (cos _phi);
			_ry = _r * (cos _theta) * (cos _phi);	

			GW_PREVIEW_CAM camSetPos [(GW_PREVIEW_CAM_POS select 0) + _rx, (GW_PREVIEW_CAM_POS select 1) + _ry, GW_PREVIEW_CAM_HEIGHT];
			GW_PREVIEW_CAM_LASTPOS = [(GW_PREVIEW_CAM_POS select 0) + _rx, (GW_PREVIEW_CAM_POS select 1) + _ry, GW_PREVIEW_CAM_HEIGHT];

			GW_PREVIEW_CAM camsetTarget [_tx, _ty, _tz];
			GW_PREVIEW_CAM camCommit 0;

		};

	};
	
};

// Tidy up, reset camera position
showChat true;		
GW_PREVIEW_CAM_ACTIVE = false;
GW_PREVIEW_CAM_TARGET = nil;
_rndLoc = [tempAreas, ["Car", "Man"], 15] call findEmpty;
GW_PREVIEW_CAM_POS = if (typename _rndLoc == "ARRAY") then { _rndLoc } else { (ASLtoATL getPosASL _rndLoc) };
player cameraeffect["terminate","back"];
camdestroy GW_PREVIEW_CAM;
titlecut["","PLAIN DOWN",0.1];

