//
//      Name: initSigns
//      Desc: Initialization of sponsor signs in the workshop area
//      Return: None
//

// Get the mission directory
MISSION_ROOT = call {
    private "_arr";
    _arr = toArray str missionConfigFile;
    _arr resize (count _arr - 15);
    toString _arr
};

_obj = _this select 0;
_company = _this select 1;

_obj setObjectTextureGlobal [0, format["client\images\signage\%1.jpg", _company]];
_obj setVariable ['company', _company, true];
_obj allowDamage false;
_obj addEventHandler['handleDamage', { false }];
_obj enableSimulationGlobal false;

// Action
_obj addAction["<img size='3' color='#ffffff' shadow='0' image='" + MISSION_ROOT + "client\images\icons\menus\cart.paa' />", { 	
	[(_this select 0)] spawn buyMenu;
}, _company, 0, false, false, "", "( !GW_EDITING && ((player distance _target) < 5) )"];

