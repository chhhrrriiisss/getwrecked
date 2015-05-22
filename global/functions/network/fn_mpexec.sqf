//
//      Name: gw_fnc_mpexec
//      Desc: Indentical usage to gw_fnc_mpexec but faster
//		Author: Karel Moricky, modified by Sli
//      Return: Nothing
//
private["_params", "_functionName", "_target", "_isPersistent", "_isCall", "_varName", "_varValue", "_function"];

_varName = _this select 0;
_varValue = _this select 1;

_mode = [_varValue, 0, [0]] call filterParam;
_params = [_varValue, 1, []] call filterParam;
_functionName = [_varValue, 2, "", [""]] call filterParam;
_target = [_varValue, 3, true, [objnull, true, 0, [], sideUnknown, grpnull, ""]] call filterParam;
_isPersistent = [_varValue, 4, false, [false]] call filterParam;
_isCall = [_varValue, 5, false, [false]] call filterParam;

if (typename _target == typename[]) then {

    {
        [_varName, [_mode, _params, _functionName, _x, _isPersistent, _isCall]] call gw_fnc_mpexec;
    }
    foreach _target;

} else {

    if (ismultiplayer && _mode == 0) then {

        private["_ownerID", "_serverID"];
        _serverID = owner(missionnamespace getvariable["bis_functions_mainscope", objnull]);

        switch (typename _target) do {
            case (typename ""):
                {
                    _ownerID = owner(missionnamespace getvariable[_target, objnull]);
                };
            case (typename objnull):
                {
                    private["_targetCuratorUnit"];
                    _targetCuratorUnit = getassignedcuratorunit _target;
                    if !(isnull _targetCuratorUnit) then {
                        _target = _targetCuratorUnit;
                    };
                    _ownerID = owner _target;
                };
            case (typename true):
                {
                    _ownerID = [_serverID, -1] select _target;
                };
            case (typename 0):
                {
                    _ownerID = _target;
                };
            case (typename grpnull);
            case (typename sideUnknown):
                {
                    _ownerID = -1;
                };
        };

        gw_fnc_mp_packet = [1, _params, _functionName, _target, _isPersistent, _isCall];

        if (_ownerID < 0) then {
            publicvariable "gw_fnc_mp_packet";
        } else {
            if (_ownerID != _serverID) then {
                _ownerID publicvariableclient "gw_fnc_mp_packet";
            };
        };

        if (_ownerID == -1 || _ownerID == _serverID) then {
            ["gw_fnc_mp_packet", gw_fnc_mp_packet] spawn gw_fnc_mpexec;
        };


        if (_isPersistent) then {
            if (typename _target != typename 0) then {
                private["_logic", "_queue"];
                _logic = missionnamespace getvariable["bis_functions_mainscope", objnull];
                _queue = _logic getvariable["gw_fnc_mp_queue", []];
                _queue set[
                    count _queue, +gw_fnc_mp_packet
                ];
                _logic setvariable["gw_fnc_mp_queue", _queue, true];
            } else {
                ["Persistent execution is not allowed when target is %1. Use %2 or %3 instead.", typename 0, typename objnull, typename false] call bis_fnc_error;
            };
        };

    } else {

        private["_canExecute"];
        _canExecute =

        switch (typename _target) do {
            case (typename grpnull):
                {
                    player in units _target
                };
            case (typename sideUnknown):
                {
                    (player call bis_fnc_objectside) == _target
                };
            default {
                true
            };
        };

        if (_canExecute) then {
            _function = missionnamespace getvariable _functionName;
            if (!isnil "_function") then {


                if (_isCall) then {
                    _params call _function;
                } else {
                    _params spawn _function;
                };
                true
            } else {
                _supportInfo = supportInfo format["*:%1*", _functionName];
                if (count _supportInfo > 0) then {


                    _cfgRemoteExecCommands = [
                        ["CfgRemoteExecCommands"], configfile
                    ] call bis_fnc_loadClass;
                    if (isclass(_cfgRemoteExecCommands >> _functionName)) then {
                        _paramCount =
                            if (typename _params == typename[]) then {
                                count _params
                            } else {
                                1
                            };
                        switch (_paramCount) do {
                            case 0:
                                {
                                    _params call compile format["%1", _functionName];
                                    true
                                };
                            case 1:
                                {
                                    _params call compile format["%1 (_this)", _functionName];
                                    true
                                };
                            case 2:
                                {
                                    _params call compile format["(_this select 0) %1 (_this select 1)", _functionName];
                                    true
                                };
                            default {

                                ["Error when remotely executing '%1' - wrong number of arguments (%2) passed, must be 0, 1 or 2", _functionName, count _params] call bis_fnc_error;
                                false
                            };
                        };
                    } else {

                        ["Scripting command '%1' is not allowed to be remotely executed", _functionName] call bis_fnc_error;
                        false
                    };
                } else {

                    ["Function or scripting command '%1' does not exist", _functionName] call bis_fnc_error;
                    false
                };
            };
        };
    };
};

