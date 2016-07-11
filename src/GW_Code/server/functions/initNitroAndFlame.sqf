if (!isServer) exitWith {};

{    

	_p = createVehicle ["UserTexture10m_F", (_x select 1), [], 0, 'CAN_COLLIDE'];            
	_p setObjectTextureGlobal [0,"client\images\stripes_fade.paa"]; 
	_p setPos ((_x select 0) modelToWorld [2.4,5.8,-0.3]);
	_p setVariable ['GW_CU_IGNORE', true];
	[_p, [-90,0,(getDir (_x select 0))]] call setPitchBankYaw;  

	false
	
} count nitroPads >0;


{
	_pad = (_x select 0);
	_pos = _pad modelToWorld [0,0,0];
	_pos set [2, 0];
	_pad setVectorUp (surfaceNormal _pos);
	_pad setVariable ['GW_CU_IGNORE', true];
	
	{
		_t = createVehicle ["UserTexture10m_F", _pos, [], 0, 'CAN_COLLIDE'];  
		_t setObjectTextureGlobal [0,(_x select 0)]; 
		_t setPos (_pad modelToWorld (_x select 1));
		_t setVectorUp (surfaceNormal _pos);
		_t setVariable ['GW_CU_IGNORE', true];
		[_t, [-90,0,([(getDir _pad) + (_x select 2)] call normalizeAngle)]] call setPitchBankYaw;  
	} foreach [
		["client\images\grill_ts.paa", [-1.4,0,-0.01], 0],
		["client\images\grill_ts.paa", [1.4,0,-0.01], 0],
		["client\images\stripes_fade.paa", [11.5,0,-0.2], 90],
		["client\images\stripes_fade.paa", [-11.5,0,-0.2], -90]
	];

	false

} count flamePads > 0;


