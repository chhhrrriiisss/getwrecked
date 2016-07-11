//
//      Name: getVectorDirAndUpRelative
//		Author: Killzone Kid
//      Desc: Get relative vectordir/up between two objects
//      Return: Bool
//

private ["_o1","_o2","_v"];
params ['_o1', '_o2'];

_v = _o2 worldToModelVisual [0,0,0];
[
    _o2 worldToModelVisual vectorDirVisual _o1 vectorDiff _v,
    _o2 worldToModelVisual vectorUpVisual _o1 vectorDiff _v
]