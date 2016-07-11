//
//      Name: initSupplyAndPaint
//      Desc: Provides initialization for paint bucket and supply crates (server side)
//      Return: Bool
//

private ['_pos', '_objs'];

setupPaint = {
	
	private ['_bucket', '_rnd', '_height'];

	// Make simple object from it
	_bucket = _this;

	// Get the height of the bucket
	_rnd = GW_TEXTURES_LIST select (random ((count GW_TEXTURES_LIST) -1));

	// Set bucket properties
	_bucket setVariable ["color", _rnd, true];
	_bucket setVariable["isPaint", true, true];
	_bucket setVariable["name", format['%1 Paint', _rnd], true];	
	_bucket setVariable["mass", 200, true];	
	_bucket enableSimulationGlobal true;

	// Create the paint texture
	_pos = (ASLtoATL getPosASL _bucket);
	_paint = createVehicle ["UserTexture1m_F", _pos, [], 0, 'CAN_COLLIDE']; 
	_paint setObjectTextureGlobal [0, format["client\customization\paint\%1.paa", toLower(_rnd)]];

	// Position it flat inside the bucket
	_paint attachTo [_bucket, [0,0, 0.076]]; // 0.076 is the height inside the bucket
	[_paint, [-90,0,0]] call setPitchBankYaw;

	_paint setVariable ['GW_CU_IGNORE', true];

	true

};


_pos = getMarkerPos "workshopZone_camera";
_objs = nearestObjects [_pos, [], 200];

if (count _objs <= 0) exitWith { true };

{	
	if ((typeOf _x) == "Land_PaperBox_closed_F") then {	_x call setupSupplyBox;	};
	if ((typeOf _x) == "Land_Bucket_painted_F") then {	_x call setupPaint;	};
	false
} count _objs > 0;

true


