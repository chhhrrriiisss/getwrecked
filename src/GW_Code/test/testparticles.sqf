Sky magma

XXXPARTICLEEFFECTSOURCEXXX setParticleCircle [0, [0.1, 0.1, 3]];
XXXPARTICLEEFFECTSOURCEXXX setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 1, [0.1, 0.1, 0.3, 1], 0, 0];
XXXPARTICLEEFFECTSOURCEXXX setParticleParams [["\A3\data_f\Cl_water", 1, 0, 1], "", "Billboard", 2, 20, [0, 0, 500], [0, 0, -200], 0, 20, 1, 0.075, [5, 5, 5, 5, 5], [[1, 1, 0.3, 0], [1, 1, 0.3, 1], [1, 1, 0.3, 1], [1, 1, 0.3, 1]], [0.08, 0.01], 0, 0, "", "", XXXOBJECTXXX];
XXXPARTICLEEFFECTSOURCEXXX setDropInterval 0.007;

Ground smoke

XXXPARTICLEEFFECTSOURCEXXX setParticleCircle [0, [0.1, 0.1, 0]];
XXXPARTICLEEFFECTSOURCEXXX setParticleRandom [0, [0.25, 0.25, 0], [2, 2, 0.5], 0, 0.25, [0, 0, 0, 1], 0, 0];
XXXPARTICLEEFFECTSOURCEXXX setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 10, [10, 0, 0], [0, 0, 1], 0, 10, 7.9, 0.075, [10, 2, 4], [[0, 0, 0, 0.8], [0.1, 0.1, 0.1, 0.5], [0.2, 0.2, 0.2, 0]], [0.08], 1, 0, "", "", XXXOBJECTXXX];
XXXPARTICLEEFFECTSOURCEXXX setDropInterval 0.1;

Scorch

XXXPARTICLEEFFECTSOURCEXXX setParticleCircle [0.5, [0, 0, 0]];
XXXPARTICLEEFFECTSOURCEXXX setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 1, [0, 0, 0, 0.5], 0, 0];
XXXPARTICLEEFFECTSOURCEXXX setParticleParams [["\A3\data_f\krater", 1, 0, 1], "", "SpaceObject", 0.05, 3, [0, 0, 0], [0, 0, 0], 0, 20, 7, 0.01, [1.2, 1.2, 1.2, 1.2], [[1, 1, 0.3, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 0, 0, "", "", XXXOBJECTXXX];
XXXPARTICLEEFFECTSOURCEXXX setDropInterval 0.5;