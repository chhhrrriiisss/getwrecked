//
//      Name: generateSponsorInfo
//      Desc: Creates a list of information about the sponsor (and its discounts) in the buy menu
//      Return: None
//

private ['_logo', '_discount', '_company'];

disableSerialization;
_logo = ((findDisplay 97000) displayCtrl 97010);
_discount = ((findDisplay 97000) displayCtrl 97011);
_company = (_this select 0) getVariable ['company', ''];
_sponsor = player getVariable ["GW_Sponsor", ""];

if (_company == '') exitWith {};

_stringTable = switch (_company) do {

	case "terminal": { ['-10% Sponsor Discount', '-25% Weapon Purchases', 'SR2 Railgun'] }; // The last attribute is a 'sponsor-specific-weapon' that isn't implemented as a feature just yet
	case "crisp": { ['-10% Sponsor Discount', '-25% Incendiary Devices', 'Incendiary Ammo'] };	
	case "gastrol": { ['-10% Sponsor Discount', '-25% Performance Equipment', 'Large Fuel Tank'] };
	case "haywire": { ['-10% Sponsor Discount', '-25% Electronics', 'Magnetic Coil'] };
	case "cognition": { ['-10% Sponsor Discount', '-25% Deployables', 'Caltrops'] };
	case "tyraid": { ['-10% Sponsor Discount', '-25% Building Supplies', 'Large Ammo Container'] };
	case "tank": { ['-10% Sponsor Discount', '-25% Defensive Items', 'Large Steel Panel'] };
	case "veneer": { ['-10% Sponsor Discount', '-25% Evasive Items', 'Vertical Thruster'] };

};

_logo ctrlSetStructuredText	parseText ( format["<img size='1' align='center' image='client\images\signage\%1.jpg' />", _company] );
_logo ctrlCommit 0;

// Do we have sponsor discount?
_sponsorStr = if (_company == _sponsor) then 
{ 
	(format["<t size='1' color='#ffffff' align='center'>%1</t> <br /><br />", (_stringTable select 0)])
} else { 
	"<t size='1' color='#666666' align='center'>0% Sponsor Discount</t> <br /><br />"
};

_companyStr = format["<t size='1' color='#E7A623' align='center'>%1</t> <br /><br /<", (_stringTable select 1)];
_descStr = "<t size='1' color='%1' align='center'>Double click or press 0-9 to set quantity required</t> <br /><br />";

_str = format["%1%2%3", _sponsorStr, _companyStr, _descStr];

_discount ctrlSetStructuredText	parseText ( _str );
_discount ctrlCommit 0;
