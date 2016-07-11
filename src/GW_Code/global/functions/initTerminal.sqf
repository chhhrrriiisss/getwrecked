//
//      Name: initTerminals
//      Desc: Add vehicle service actions to terminals
//      Return: None
//

private ['_obj', '_pad', '_p'];
params ['_obj', '_var'];

_obj setVariable ['isTerminal', _var];

if (!isServer) exitWith {};

_obj setVariable ['GW_CU_IGNORE', true];

if (typeOf _obj == "SignAd_Sponsor_ARMEX_F" && _var isEqualType objNull) exitWith {
	_obj setObjectTextureGlobal [0, "client\images\signage\vehicleserviceterminal.jpg"]; 
};

if (typeOf _obj == "SignAd_Sponsor_ARMEX_F" && _var isEqualType "") exitWith {
	_obj setObjectTextureGlobal [0, format["client\images\signage\%1.jpg",_var] ]; 
};
