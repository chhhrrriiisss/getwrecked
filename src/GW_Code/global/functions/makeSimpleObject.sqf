//
//      Name: makeSimpleObject
//      Desc: Makes a reduced MP clone of an object and places in same place
//      Return: None
//

if (!isServer) exitWith {};

private ['_o', '_p', '_v', '_i'];

_o = _this;
_p = getPosWorld  _o;
_n = vehicleVarName _o;
_v = [vectorDir _o, vectorUp _o]; 
_i = getModelInfo _o;
_s = simulationEnabled _o;
_h = isObjectHidden _o;

// Abort if no model info availale
if (isNil "_i") exitWith { objnull };
deleteVehicle _o; 

_o = createSimpleObject [(_i select 1), _p]; 
_o setVehicleVarName _n;
_o setVectorDirAndUp _v;
_o enableSimulationglobal _s; 
_o hideObjectGlobal _h;

_o