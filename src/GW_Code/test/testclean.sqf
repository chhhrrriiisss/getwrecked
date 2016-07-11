
_agentTypes = [
	"Rabbit_F",
	"Snake_random_F",
	"ButterFly_random",
	"Bird",
	"Cicada",
	"DragonFly",
	"HoneyBee",
	"HouseFly",
	"Insect",
	"Kestrel_Random_F",
	"Mosquito",
	"SeaGull",
	"Tuna_F",
	"Turtle_F",
	"CatShark_F"
];

systemchat format['count: %1', count agents];

{ if (_agentTypes find typeof (agent _x) >= 0) then { deleteVehicle (agent _x); }; false } count agents > 0;

systemchat format['final: %1', count agents];