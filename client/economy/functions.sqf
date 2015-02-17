//
//      Name: receiveMoney, numberToCurrency, showTransaction, setBalance, changeBalance, isUnlocked, unlockItem
//      Desc: Initialization of all functions related to economy, buying etc
//      Return: None
//

// If we've got a new player, give them starter cash, otherwise use their existing cash
_balance = profileNamespace getVariable ['GW_BALANCE', nil];
GW_BALANCE = if (!isNil "_balance") then {

    if (_balance < 0) then { _balance = 0; };
    _balance

} else { GW_INIT_BALANCE };

profileNamespace setVariable ['GW_BALANCE', GW_BALANCE];

// If the player has unlocked items, apply them to the unlocked items array
_unlocked = profileNamespace getVariable ['GW_UNLOCKED_ITEMS', []];

GW_UNLOCKED_ITEMS = if (count _unlocked > 0) then {

    _unlocked

} else { profileNamespace setVariable ['GW_UNLOCKED_ITEMS', []];  [] };

saveProfileNamespace;

// Handles money sent from the server, adjusts balance accordingly
receiveMoney = {

	private ['_value'];

	_value = [_this,0,0,[0]] call bis_fnc_param;

	if (_value == 0) exitWith {};

	[_value] call changeBalance;	

	// If we were just in a vehicle, count the money as "moneyEarned" stat
	_vehicle = player getVariable ["prevVeh", nil];
	if (!isNil "_vehicle") then {
		['moneyEarned', _vehicle, _value] spawn logStat;   
	};		

	_valueString = ([_value] call numberToCurrency);

	// Make everyone aware we got the dosh
	systemChat format['You earned $%1.', _valueString];
	pubVar_systemChat = format['%1 earned $%2', GW_PLAYERNAME, _valueString];
	publicVariable "pubVar_systemChat";

	// Alert message
	[format['RECEIVED $%1', _valueString], 2, successIcon, nil, "slideDown"] spawn createAlert;   

	// And audio because it's funny
	[		
		[
			player,
			"money",
			20
		],
		"playSoundAll",
		true,
		false
	] call BIS_fnc_MP;	 
};

// Converts a number to a string with commas (as a currency)
numberToCurrency = {

	private ["_value","_digits","_count","_string","_step", "_mod"];

	_value = [_this,0,0,[0]] call bis_fnc_param;
	_digits = _value call bis_fnc_numberDigits;
	_count = count (_digits) - 1;

	_mod = 3;
	_base = _count % _mod;
	_string = "";

	{
		_string = _string + str _x;

		if ((_foreachindex - _base) % (_mod) == 0 && _foreachindex != _count) then {
			_string = _string + ","; 
		};
	} ForEach _digits;

	_string
};

// Shows the transaction at the bottom right of the screen, below the balance
showTransaction = {
	
	// Make sure we're not currently animating
	if (isNil "GW_TRANSACTION_ANIM") then {	GW_TRANSACTION_ANIM = false; };
	if (GW_TRANSACTION_ANIM) exitWith {};
	GW_TRANSACTION_ANIM = true;

	private ['_amount'];
	_amount = _this;
	
	// Only show transactions in the workshop zone (hud changes when in vehicle)
	if (_amount > 0 && GW_CURRENTZONE != "workshopZone") exitWith {
		_str = format['RECEIVED $%1', ([_amount] call numberToCurrency)];
		[_str, 2, successIcon, nil, "slideDown"] spawn createAlert;     
		GW_TRANSACTION_ANIM = false;
	};

	disableSerialization;
	_layerHud = ("GW_HUD" call BIS_fnc_rscLayer);
	_hud = uiNamespace getVariable "GW_HUD"; 
	_hudTransaction = (_hud displayCtrl 10002);
	_hudTransaction ctrlShow false;
	_hudTransaction ctrlCommit 0;

	// Ensure its hidden initially
	[[_hudTransaction], [['fade', 1, 0, 0]], "quad"] spawn createTween;

	_pad = ''; // Used to add + to front of number when value is positive
	_numberString = ([_amount] call numberToCurrency);
	_color = if (_amount < 0) then { '#ee0000' } else { format['%1+', _pad]; '#00ff00' };

	// Apply the text and show the announcement
	_hudTransaction ctrlSetStructuredText parseText ( format["   <t size='1.1' color='%1' align='center'>%2%3</t>", _color, _pad,  _numberString ] );
	_hudTransaction ctrlCommit 0;
	_hudTransaction ctrlShow true;
	_hudTransaction ctrlCommit 0;

	// Animate down
	[[_hudTransaction], [['fade', 0, 1, 0.5],['y', '0', '0.05', 0.5]], "quad"] spawn createTween;	

	Sleep 2;

	// Fade out and reset position
	[[_hudTransaction], [['fade', 1, 0, 0.25], ['y', '0', '-0.05', 0]], "quad"] spawn createTween;

	Sleep 0.1;

	// Clear the text
	_hudTransaction ctrlSetStructuredText parseText ( "" );
	_hudTransaction ctrlCommit 0;

	GW_TRANSACTION_ANIM = false;
};

// Set the players balance to any value
setBalance = {	

	private ['_value'];

	_value = [_this,0,0,[0]] call BIS_fnc_param;

	_oldBalance = profileNamespace getVariable ['GW_BALANCE', 0];
	profileNamespace setVariable ['GW_BALANCE', _value];
	saveProfileNamespace;
	
	_difBalance = _value - _oldBalance;	
	_difBalance spawn showTransaction;
	GW_BALANCE = _value;
};

// Increase or decrease a balance by specified amount
changeBalance = {
	
	private ['_value', '_current'];

	_value = [_this,0,0,[0]] call BIS_fnc_param;
	if (_value == 0) exitWith { false };

	_current = profileNamespace getVariable ['GW_BALANCE', 0];
	_current = _current + _value;

	if (_current < 0) exitWith { false };

	profileNamespace setVariable ['GW_BALANCE', _current];
	saveProfileNamespace;

	_value spawn showTransaction;
	GW_BALANCE = _current;	
	
	true
};

// Determines if an item is locked or unlocked
isUnlocked = {
	
	private ['_class'];

	_class = _this;

	if (_class in GW_LOCKED_ITEMS && _class in GW_UNLOCKED_ITEMS) exitWith { true };
	if ( !(_class in GW_LOCKED_ITEMS) ) exitWith { true };

	false
};

// Unlocks a previously locked item
unlockItem = {

	private ['_item', '_current', '_unlocked'];
	
	_item = _this;

	_current = profileNamespace getVariable ['GW_UNLOCKED_ITEMS', []];

	if (_item in _current) exitWIth {};

	GW_UNLOCKED_ITEMS = if (count _current > 0) then { _current	} else { [] };
	GW_UNLOCKED_ITEMS pushBack _item;

	profileNamespace setVariable ['GW_UNLOCKED_ITEMS', GW_UNLOCKED_ITEMS];
	saveProfileNamespace;

	true
};