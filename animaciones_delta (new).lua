if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end

local USAR_CUELLO = false -- true = animar el cuello (riesgo de morir)
local SIN_COLISIONES = true -- true = no chocas con otros jugadores (ni ellos contigo en tu pantalla)
local DENSIDAD_HRP = 2.1  -- baja a 1.5 si sube; súbela a 2.5 si se hunde

-- ========== TUS ANIMACIONES GUARDADAS ==========
-- Para añadir una: copia un bloque {nombre = ..., datos = [[ ... ]]},
-- cambia el nombre y pega tu animación entre [[ y ]]
local Animaciones = {
	{
		nombre = "1",
		datos = [[
		offsets = {
			Neck = 1,
			["Left Shoulder"] = -0.1,
			["Right Shoulder"] = -0.1,
		},
		fullOffset = 0,
		speed = 1,
		a = {
			["RootJoint"] = CFrame.new(0, -0.727142, -0.126193, 1, 0, 0, 0, 0.968244, -0.250006, 0, 0.250006, 0.968244);
			["Left Hip"] = CFrame.new(0, 0, 0, 0.970637, 0.222783, 0.090729, -0.230181, 0.969742, 0.081341, -0.069862, -0.099837, 0.992548);
			["Neck"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.978123, -0.208029, 0, 0.208029, 0.978123);
			["Right Shoulder"] = CFrame.new(0.09522, -0.903157, -0.115498, -0.318163, -0.933233, 0.166878, 0.898955, -0.241076, 0.365736, -0.301086, 0.266379, 0.915636);
			["Right Hip"] = CFrame.new(0, 0, 0, 0.972167, -0.222515, -0.073336, 0.229011, 0.96858, 0.09699, 0.04945, -0.111085, 0.99258);
			["Left Shoulder"] = CFrame.new(0.071992, -0.901743, -0.101227, -0.16122, 0.957595, -0.238789, -0.984475, -0.139028, 0.107142, 0.0694, 0.252356, 0.965142);
		},
		b = {
			["RootJoint"] = CFrame.new(0, -0.85979, -0.160444, 1, 0, 0, 0, 0.987532, -0.15742, 0, 0.15742, 0.987532);
			["Neck"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.902457, -0.43078, 0, 0.43078, 0.902457);
			["Left Hip"] = CFrame.new(0, 0, 0, 0.995694, 0.018997, 0.090729, -0.026421, 0.996336, 0.081341, -0.088851, -0.083388, 0.992548);
			["Right Shoulder"] = CFrame.new(-0.013294, -0.933951, -0.083421, -0.267871, -0.948892, 0.166878, 0.910546, -0.192726, 0.365736, -0.314882, 0.24992, 0.915636);
			["Right Hip"] = CFrame.new(0, 0, 0, 0.997137, -0.018422, -0.073336, 0.025515, 0.994958, 0.096989, 0.071179, -0.098583, 0.99258);
			["Left Shoulder"] = CFrame.new(0.185674, -0.908358, -0.072365, -0.097394, 0.966175, -0.238789, -0.991526, -0.07347, 0.107142, 0.085974, 0.247201, 0.965143);
		}
]],
	},	{
		nombre = "2",
		datos = [[
		offsets = {
			Neck = 1,
			["Left Shoulder"] = 1,
			["Right Shoulder"] = 0.5,
			["Left Hip"] = -1,
			["Right Hip"] = -1,
			["br_Bone"] = 2,
			["br_Bone.001"] = 0.5,
			["bl_Bone.001"] = 0.5,
			["bl_Bone"] = 1.6,
		},
		fullOffset = 0,
		speed = 1,
		a = {
			["tors_Move"] = CFrame.new(-0.275154, 0.459261, -0.003436, -0.811252, 0.584696, -0.000027, -0.584582, -0.811092, 0.019834, 0.011575, 0.016106, 0.999803),
			["ps_Bone.004"] = CFrame.new(0.045736, 0.226955, 0.002633, 0.919169, -0.356296, -0.167872, 0.392325, 0.865878, 0.310382, 0.034769, -0.351154, 0.935672),
			["ps_Bone.001"] = CFrame.new(-0.045774, 0.224894, -0.00264, 0.915116, 0.398344, 0.062329, -0.401827, 0.888349, 0.222197, 0.033141, -0.228382, 0.973008),
			["p_Bone"] = CFrame.new(0.018623, 0, -0.759913, 1, 0, 0, 0, 0.065466, -0.997855, 0, 0.997855, 0.065466),
			["p_Bone.001"] = CFrame.new(0, 0.405062, 0, 1, 0, 0, 0, 0.87368, 0.486502, 0, -0.486502, 0.87368),
			["p_Bone.002"] = CFrame.new(0, 0.462188, -0.000002, 1, 0, 0, 0, 0.971208, 0.238231, 0, -0.238231, 0.971208),
			["bl_Bone"] = CFrame.new(-0.417415, 0.801303, 0.341858, -0.336758, -0.919662, 0.202029, 0.938158, -0.309409, -0.155327, 0.080339, 0.241843, 0.966984),
			["bl_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.825665, 0.518199, -0.223041, -0.531843, 0.846842, -0.001302, 0.188206, 0.119698, 0.974808),
			["br_Bone"] = CFrame.new(-0.417415, 0.801303, -0.341858, -0.336758, -0.919662, -0.202029, 0.938158, -0.309409, -0.155327, 0.080339, -0.241843, 0.966984),
			["br_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.825665, 0.518199, 0.223041, -0.531843, 0.846842, 0.001302, -0.188206, -0.119698, 0.974808),
			["RootJoint"] = CFrame.new(0, -1.745409, -1.354662, 1, 0, 0, 0, -0.224585, -0.974455, 0, 0.974455, -0.224585);
			["Neck"] = CFrame.new(0, 0, 0, 0.780355, 0.595043, 0.192275, -0.583079, 0.581262, 0.567586, 0.225976, -0.55503, 0.800548);
			["Left Hip"] = CFrame.new(0.007985, 0.516552, -0.007868, 0.035134, 0.984172, 0.173698, -0.971154, -0.007395, 0.238337, 0.235849, -0.177062, 0.955523);
			["Right Shoulder"] = CFrame.new(1.094171, 0.461417, -0.423845, -0.946558, 0.19358, 0.257983, -0.194628, -0.980636, 0.021724, 0.257193, -0.029648, 0.965905);
			["Right Hip"] = CFrame.new(-0.00841, 0.524265, 0.029378, 0.035587, -0.99273, -0.114985, 0.975828, 0.009694, 0.218324, -0.215622, -0.119976, 0.969078);
			["Left Shoulder"] = CFrame.new(-0.392717, 0.11482, -0.373389, 0.620888, 0.744192, 0.246325, -0.700719, 0.667758, -0.251181, -0.351412, -0.016649, 0.936073);
		},
		b = {
			["tors_Move"] = CFrame.new(0.00011, 0.253359, 0.000656, -0.811253, 0.584696, -0.000027, -0.584581, -0.811093, 0.019834, 0.011575, 0.016106, 0.999803),
			["ps_Bone.004"] = CFrame.new(-0.000008, 0.206951, -0.000003, 0.91917, -0.356295, -0.167872, 0.392325, 0.865878, 0.310382, 0.034769, -0.351154, 0.935672),
			["ps_Bone.001"] = CFrame.new(0.000008, 0.204971, -0.000001, 0.915116, 0.398344, 0.062329, -0.401827, 0.888349, 0.222197, 0.033141, -0.228382, 0.973007),
			["p_Bone"] = CFrame.new(0.018623, 0, -0.759913, 1, 0, 0, 0, 0.065466, -0.997855, 0, 0.997855, 0.065466),
			["p_Bone.001"] = CFrame.new(0, 0.405062, 0, 1, 0, 0, 0, 0.87368, 0.486502, 0, -0.486502, 0.87368),
			["p_Bone.002"] = CFrame.new(0, 0.462188, -0.000002, 1, 0, 0, 0, 0.971208, 0.238231, 0, -0.238231, 0.971208),
			["bl_Bone"] = CFrame.new(-0.417415, 0.801304, 0.341858, -0.671654, -0.729941, 0.126756, 0.736496, -0.639295, 0.221078, 0.080339, 0.241843, 0.966984),
			["bl_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.936688, 0.310802, -0.161299, -0.319086, 0.947323, -0.027617, -0.144219, 0.077337, 0.986519),
			["br_Bone"] = CFrame.new(-0.417415, 0.801304, -0.341858, -0.671654, -0.729941, -0.126756, 0.736496, -0.639295, -0.221078, 0.080339, -0.241843, 0.966984),
			["br_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.936688, 0.310802, 0.161299, -0.319086, 0.947323, 0.027617, -0.144219, -0.077337, 0.986519),
			["RootJoint"] = CFrame.new(0, -1.84526, -1.297018, 1, 0, 0, 0, -0.204325, -0.978903, 0, 0.978903, -0.204325);
			["Neck"] = CFrame.new(0, 0, 0, 0.746239, 0.650101, 0.143166, -0.615443, 0.591818, 0.520558, 0.253687, -0.476571, 0.841738);
			["Left Hip"] = CFrame.new(-0.058638, 0.512493, -0.029295, 0.056375, 0.982762, 0.17607, -0.971461, 0.013297, 0.236828, 0.230404, -0.184396, 0.955464);
			["Right Shoulder"] = CFrame.new(1.143101, 0.333471, -0.434034, -0.949887, 0.176518, 0.257983, -0.176954, -0.983979, 0.021723, 0.257684, -0.025017, 0.965905);
			["Right Hip"] = CFrame.new(0.060554, 0.521464, 0.0508, 0.05651, -0.991758, -0.114985, 0.975407, 0.030266, 0.218324, -0.213045, -0.124495, 0.969078);
			["Left Shoulder"] = CFrame.new(-0.444076, 0.068736, -0.37224, 0.620888, 0.744192, 0.246325, -0.700719, 0.667758, -0.251181, -0.351412, -0.016649, 0.936073);
		}
]],
		
	    },   
		{
			nombre = "3",
			datos = [[
		offsets = {
			Neck = 0;
			["Left Shoulder"] = -0.1;
			["Right Shoulder"] = -0.1;
		};
		fullOffset = 0;
		speed = 1;
		a = {
			["p_Bone.001"] = CFrame.new(0, 0.411136, -0.012494, 1, 0, 0, 0, 0.983805, 0.179241, 0, 1.179241, 0.983805),
			["Left Shoulder"] = CFrame.new(0.016842, 0.287167, -0.145407, -0.981647, 0.15731, -0.10781, -0.190708, -0.80986, 0.554759, -0.000042, 0.565137, 0.824997);
			["Right Shoulder"] = CFrame.new(-0.016842, 0.287167, -0.145407, -0.981647, -0.15731, 0.10781, 0.190708, -0.80986, 0.554759, 0.000042, 0.565137, 0.824997);
			RootJoint = CFrame.new(0, -1.105643, -2.440902, 1, 0, 0, 0, 0.058569, 0.998283, 0, -0.998283, 0.058569);
			Neck = CFrame.new(0, -0.068978, 0.261868, 1, 0, 0, 0, 0.645967, -0.763366, 0, 0.763366, 0.645967);
			["Right Hip"] = CFrame.new(0, 0, 0, 0.982496, -0.185408, -0.018064, 0.186286, 0.977846, 0.095467, -0.000037, -0.097161, 0.995269);
			["Left Hip"] = CFrame.new(0, 0, 0, 0.982503, 0.184166, 0.027748, -0.186245, 0.971553, 0.146277, -0.00002, -0.148886, 0.988854);
		};
		b = {
			["p_Bone.001"] = CFrame.new(0, 0.411136, -0.012494, 1, 0, 0, 0, 0.983805, 0.179241, 0, 1.179241, 0.983805),
			["Left Shoulder"] = CFrame.new(0.016842, 0.287167, -0.145407, -0.981647, 0.15731, -0.10781, -0.190708, -0.80986, 0.554759, -0.000042, 0.565137, 0.824997);
			["Right Shoulder"] = CFrame.new(-0.016842, 0.287167, -0.145407, -0.981647, -0.15731, 0.10781, 0.190708, -0.80986, 0.554759, 0.000042, 0.565137, 0.824997);
			RootJoint = CFrame.new(0, -1.105928, -2.440962, 1, 0, 0, 0, 0.058568, 0.998283, 0, -0.998283, 0.058568);
			Neck = CFrame.new(0, -0.068978, 0.261868, 1, 0, 0, 0, 0.69086, -0.722988, 0, 0.722988, 0.69086);
			["Right Hip"] = CFrame.new(0, 0, 0, 0.982496, -0.185408, -0.018064, 0.186286, 0.977846, 0.095467, -0.000037, -0.097161, 0.995269);
			["Left Hip"] = CFrame.new(0, 0, 0, 0.982503, 0.184166, 0.027748, -0.186245, 0.971553, 0.146277, -0.00002, -0.148886, 0.988854);
		};
	};
]],
	        }, 		
			{
				nombre = "4",
				datos = [[
		offsets = {
			Neck = 0;
			["Right Shoulder"] = 1;
			["Left Shoulder"] = 1;
			["Right Hip"] = 0.2;
			["Left Hip"] = 0.2;
			br_Bone = 2,
			["br_Bone.001"] = 0.5,
			["bl_Bone.001"] = 0.5,
			["bl_Bone"] = 1.6,
		};
		fullOffset = 0;
		speed = 1;
		a = {
			["p_Bone"] = CFrame.new(0.018623, 0, -0.759913, 1, 0, 0, 0, 0.065466, -0.997855, 0, 0.997855, 0.065466),
			["p_Bone.001"] = CFrame.new(0, 0.40506, 0, 1, 0, 0, 0, 0.997287, 0.073614, 0, -0.073614, 0.997287),
			["p_Bone.002"] = CFrame.new(0, 0.462188, -0.000002, 1, 0, 0, 0, 0.971208, 0.238231, 0, -0.238231, 0.971208),
			["tors_Move"] = CFrame.new(0.00011, 0.253359, 0.000656, -0.811253, 0.584696, -0.000027, -0.584581, -0.811093, 0.019834, 0.011575, 0.016106, 0.999803),
			["ps_Bone.004"] = CFrame.new(-0.000008, 0.206951, -0.000003, 0.91917, -0.356295, -0.167872, 0.392325, 0.865878, 0.310382, 0.034769, -0.351154, 0.935672),
			["ps_Bone.001"] = CFrame.new(0.000008, 0.204971, -0.000001, 0.915116, 0.398344, 0.062329, -0.401827, 0.888349, 0.222197, 0.033141, -0.228382, 0.973007),
			["bl_Bone"] = CFrame.new(-0.417414, 0.801304, 0.382984, -0.110023, -0.975758, 0.189185, 0.990622, -0.123166, -0.059144, 0.081012, 0.180903, 0.980159),
			["bl_Bone.001"] = CFrame.new(-0.049045, 0.410061, 0.004972, 0.767365, 0.634169, -0.094763, -0.637646, 0.770281, -0.00864, 0.067515, 0.067055, 0.995463),
			["br_Bone"] = CFrame.new(-0.417415, 0.801303, -0.341858, -0.336758, -0.919662, -0.202029, 0.938158, -0.309409, -0.155327, 0.080339, -0.241843, 0.966984),
			["br_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.825665, 0.518199, 0.223041, -0.531843, 0.846842, 0.001302, -0.188206, -0.119698, 0.974808),
			["Left Shoulder"] = CFrame.new(0.277105, -0.26608, -0.219432, 0.924392, -0.374925, 0.070223, 0.380117, 0.890087, -0.251506, 0.031791, 0.259183, 0.965305);
			["Right Shoulder"] = CFrame.new(-0.277106, -0.266079, -0.219432, 0.924392, 0.374925, -0.070223, -0.380117, 0.890087, -0.251506, -0.031791, 0.259183, 0.965305);
			RootJoint = CFrame.new(0, -2.022795, -0.34217, -1, 0, 0, 0, -0.83864, -0.544687, 0, -0.544687, 0.838639);
			Neck = CFrame.new(0, -0.029613, 0.045593, 1, 0, 0, 0, 0.817699, -0.575646, 0, 0.575646, 0.817699);
			["Right Hip"] = CFrame.new(0.248105, 0.262275, 0.711553, 0.656353, 0.553212, -0.51299, -0.606691, 0.7912, 0.076995, 0.448472, 0.260691, 0.854935);
			["Left Hip"] = CFrame.new(-0.248105, 0.262275, 0.711553, 0.656353, -0.553212, 0.51299, 0.606691, 0.7912, 0.076995, -0.448472, 0.260691, 0.854935);
		};
		b = {
			["p_Bone"] = CFrame.new(0.018623, 0, -0.759913, 1, 0, 0, 0, 0.115853, -0.993266, 0, 0.993266, 0.115853),
			["p_Bone.001"] = CFrame.new(0, 0.40506, 0, 1, 0, 0, 0, 0.983195, 0.18256, 0, -0.18256, 0.983195),
			["p_Bone.002"] = CFrame.new(0, 0.462189, -0.000002, 1, 0, 0, 0, 0.92811, 0.372306, 0, -0.372306, 0.92811),
			["tors_Move"] = CFrame.new(-0.275154, 0.459261, -0.003436, -0.811252, 0.584696, -0.000027, -0.584582, -0.811092, 0.019834, 0.011575, 0.016106, 0.999803),
			["ps_Bone.004"] = CFrame.new(0.045736, 0.226955, 0.002633, 0.919169, -0.356296, -0.167872, 0.392325, 0.865878, 0.310382, 0.034769, -0.351154, 0.935672),
			["ps_Bone.001"] = CFrame.new(-0.045774, 0.224894, -0.00264, 0.915116, 0.398344, 0.062329, -0.401827, 0.888349, 0.222197, 0.033141, -0.228382, 0.973008),
			["bl_Bone"] = CFrame.new(-0.417415, 0.801304, 0.382984, -0.647958, -0.737674, 0.189704, 0.757356, -0.65047, 0.057458, 0.081012, 0.180903, 0.980159),
			["bl_Bone.001"] = CFrame.new(-0.049045, 0.410061, 0.004974, 0.945132, 0.326322, -0.015467, -0.326656, 0.943317, -0.058733, -0.004576, 0.060563, 0.998154),
			["br_Bone"] = CFrame.new(-0.417415, 0.801304, -0.341858, -0.671654, -0.729941, -0.126756, 0.736496, -0.639295, -0.221078, 0.080339, -0.241843, 0.966984),
			["br_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.936688, 0.310802, 0.161299, -0.319086, 0.947323, 0.027617, -0.144219, -0.077337, 0.986519),
			["Left Shoulder"] = CFrame.new(0.028114, 0.074055, -0.219431, 0.924392, -0.374925, 0.070223, 0.380117, 0.890087, -0.251506, 0.031791, 0.259183, 0.965305);
			["Right Shoulder"] = CFrame.new(-0.028114, 0.074054, -0.219431, 0.924392, 0.374925, -0.070223, -0.380117, 0.890087, -0.251506, -0.031791, 0.259183, 0.965305);
			RootJoint = CFrame.new(0, -1.857688, -0.870168, -1, 0, 0, 0, -0.872476, -0.488657, 0, -0.488657, 0.872476);
			Neck = CFrame.new(0, -0.029613, 0.045593, 1, 0, 0, 0, 0.769212, -0.638994, 0, 0.638994, 0.769212);
			["Right Hip"] = CFrame.new(0.441085, 0.427509, 0.865087, 0.629234, 0.53306, -0.565607, -0.655136, 0.755321, -0.016977, 0.418165, 0.381232, 0.8245);
			["Left Hip"] = CFrame.new(-0.4655, 0.471107, 0.865087, 0.629234, -0.53306, 0.565607, 0.655136, 0.755321, -0.016977, -0.418165, 0.381232, 0.8245);
		};
	};
]],
		    
	},
	{
		nombre = "5",
		datos = [[
	offsets = {
			Neck = -0.4;
			["Left Shoulder"] = -0.6;
			["Right Shoulder"] = -0.6;
		};
		fullOffset = 0;
		speed = 0.5;
		a = {
			["p_Bone"] = CFrame.new(-0.007475, -0.091987, -0.635826, 1, 0, 0, 0, 0.483953, -0.875094, 0, 0.875094, 0.483953),
			["p_Bone.001"] = CFrame.new(0, 0.411136, -0.012494, 1, 0, 0, 0, 0.983805, 0.179241, 0, 1.5, 0.983805),
			["p_Bone.002"] = CFrame.new(0, 0.462191, -0.000001, 1, 0, 0, 0, 0.858051, 0.513565, 0, 0.513565, 0.858051),
			["Left Shoulder"] = CFrame.new(-0.277891, -0.65014, -0.099968, 0.673033, 0.739606, -0.003051, -0.670465, 0.611847, 0.419666, 0.312255, -0.280404, 0.907673);
			["Right Shoulder"] = CFrame.new(0.277639, -0.650384, -0.100055, 0.673033, -0.739606, 0.003051, 0.670465, 0.611847, 0.419667, -0.312255, -0.280404, 0.907673);
			RootJoint = CFrame.new(0, -1.580011, -0.399976, -1, 0, 0, 0, -0.906308, 0.422618, 0, 0.422618, 0.906308);
			Neck = CFrame.new(0, -0.000067, 0.000014, 0.98106, 0.085832, 0.173648, -0.039414, 0.966167, -0.254887, -0.189651, 0.243216, 0.951251);
			["Right Hip"] = CFrame.new(0.166303, 0.382434, 0.299942, 0.891519, -0.410422, -0.191694, 0.413072, 0.910273, -0.027828, 0.185915, -0.054374, 0.98106);
			["Left Hip"] = CFrame.new(-0.166771, 0.382606, 0.299945, 0.891519, 0.410422, 0.191694, -0.413072, 0.910273, -0.027828, -0.185915, -0.054374, 0.98106);
		};
		b = {
			["p_Bone"] = CFrame.new(-0.007475, -0.091987, -0.635826, 1, 0, 0, 0, 0.483953, -0.875094, 0, 0.875094, 0.483953),
			["p_Bone.001"] = CFrame.new(0, 0.411136, -0.012494, 1, 0, 0, 0, 0.983805, 0.179241, 0, 1.5, 0.983805),
			["p_Bone.002"] = CFrame.new(0, 0.462191, -0.000001, 1, 0, 0, 0, 0.858051, 0.513565, 0, 0.513565, 0.858051),
			["Left Shoulder"] = CFrame.new(-0.20998, -0.767726, -0.099919, 0.670921, 0.739605, 0.053374, -0.703282, 0.611848, 0.361989, 0.235072, -0.280403, 0.930653);
			["Right Shoulder"] = CFrame.new(0.209736, -0.768132, -0.099908, 0.670922, -0.739605, -0.053374, 0.703282, 0.611849, 0.361989, -0.235072, -0.280404, 0.930653);
			RootJoint = CFrame.new(0, -1.382725, -0.399979, -1, 0, 0, 0, -0.965316, 0.261084, 0, 0.261084, 0.965316);
			Neck = CFrame.new(0.000008, 0.00007, 0.000042, 0.97451, 0.105064, 0.198223, -0.071145, 0.982684, -0.171086, -0.212766, 0.152622, 0.96511);
			["Right Hip"] = CFrame.new(0.256384, 0.352421, 0.375411, 0.977627, -0.082094, -0.193665, 0.084745, 0.996388, 0.005429, 0.19252, -0.02172, 0.981053);
			["Left Hip"] = CFrame.new(-0.25701, 0.352649, 0.375501, 0.977627, 0.082093, 0.193665, -0.084744, 0.996388, 0.005429, -0.19252, -0.02172, 0.981053);
		};
	};
]],

	},
	{
		nombre = "6",
		datos = [[
		offsets = {
			Neck = 0;
			["Right Shoulder"] = -1;
			["Left Shoulder"] = -1;
			["Right Hip"] = 0.3;
			["Left Hip"] = 0.3;
			bl_Bone = 0.6;
			["bl_Bone.001"] = 0.6;
			br_Bone = 0.6;
			["br_Bone.001"] = 0.6;
		};
		fullOffset = 0;
		speed = 1;
		a = {
			["p_Bone"] = CFrame.new(0.018623, 0, -0.759913, 1, 0, 0, 0, 0.065466, -0.997855, 0, 0.997855, 0.065466),
			["p_Bone.001"] = CFrame.new(0, 0.40506, 0, 1, 0, 0, 0, 0.997287, 0.073614, 0, -0.073614, 0.997287),
			["p_Bone.002"] = CFrame.new(0, 0.462188, -0.000002, 1, 0, 0, 0, 0.971208, 0.238231, 0, -0.238231, 0.971208),
			["tors_Move"] = CFrame.new(0.00011, 0.253359, 0.000656, -0.811253, 0.584696, -0.000027, -0.584581, -0.811093, 0.019834, 0.011575, 0.016106, 0.999803),
			["ps_Bone.004"] = CFrame.new(-0.000008, 0.206951, -0.000003, 0.91917, -0.356295, -0.167872, 0.392325, 0.865878, 0.310382, 0.034769, -0.351154, 0.935672),
			["ps_Bone.001"] = CFrame.new(0.000008, 0.204971, -0.000001, 0.915116, 0.398344, 0.062329, -0.401827, 0.888349, 0.222197, 0.033141, -0.228382, 0.973007),
			["bl_Bone"] = CFrame.new(-0.417414, 0.801304, 0.382984, -0.110023, -0.975758, 0.189185, 0.990622, -0.123166, -0.059144, 0.081012, 0.180903, 0.980159),
			["bl_Bone.001"] = CFrame.new(-0.049045, 0.410061, 0.004972, 0.767365, 0.634169, -0.094763, -0.637646, 0.770281, -0.00864, 0.067515, 0.067055, 0.995463),
			["br_Bone"] = CFrame.new(-0.417415, 0.801303, -0.341858, -0.336758, -0.919662, -0.202029, 0.938158, -0.309409, -0.155327, 0.080339, -0.241843, 0.966984),
			["br_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.825665, 0.518199, 0.223041, -0.531843, 0.846842, 0.001302, -0.188206, -0.119698, 0.974808),
			["Left Shoulder"] = CFrame.new(-0.079139, 0.70603, 0.034693, -0.634986, 0.307838, -0.70854, -0.741788, -0.499099, 0.44794, -0.215739, 0.810022, 0.545272);
			["Right Shoulder"] = CFrame.new(0.079157, 0.706053, 0.034748, -0.63499, -0.307836, 0.708537, 0.741785, -0.499102, 0.447943, 0.21574, 0.810021, 0.545273);
			RootJoint = CFrame.new(0, 1.300024, -2.20005, 1, 0, 0, 0, -0.642788, 0.766044, 0, -0.766044, -0.642788);
			Neck = CFrame.new(0, -0.385757, 0.317547, 1, 0, 0, 0, 0.173606, -0.984815, 0, 0.984815, 0.173606);
			["Right Hip"] = CFrame.new(0.398273, 0.319006, 0.499857, 0.684493, 0.726214, -0.063903, -0.594152, 0.606508, 0.528328, 0.422437, -0.323669, 0.846632);
			["Left Hip"] = CFrame.new(-0.397827, 0.318546, 0.500255, 0.684495, -0.726211, 0.063903, 0.59415, 0.60651, 0.528328, -0.422436, -0.32367, 0.846632);
		};
		b = {
			["p_Bone"] = CFrame.new(0.018623, 0, -0.759913, 1, 0, 0, 0, 0.115853, -0.993266, 0, 0.993266, 0.115853),
			["p_Bone.001"] = CFrame.new(0, 0.40506, 0, 1, 0, 0, 0, 0.983195, 0.18256, 0, -0.18256, 0.983195),
			["p_Bone.002"] = CFrame.new(0, 0.462189, -0.000002, 1, 0, 0, 0, 0.92811, 0.372306, 0, -0.372306, 0.92811),
			["tors_Move"] = CFrame.new(-0.275154, 0.459261, -0.003436, -0.811252, 0.584696, -0.000027, -0.584582, -0.811092, 0.019834, 0.011575, 0.016106, 0.999803),
			["ps_Bone.004"] = CFrame.new(0.045736, 0.226955, 0.002633, 0.919169, -0.356296, -0.167872, 0.392325, 0.865878, 0.310382, 0.034769, -0.351154, 0.935672),
			["ps_Bone.001"] = CFrame.new(-0.045774, 0.224894, -0.00264, 0.915116, 0.398344, 0.062329, -0.401827, 0.888349, 0.222197, 0.033141, -0.228382, 0.973008),
			["bl_Bone"] = CFrame.new(-0.417415, 0.801304, 0.382984, -0.647958, -0.737674, 0.189704, 0.757356, -0.65047, 0.057458, 0.081012, 0.180903, 0.980159),
			["bl_Bone.001"] = CFrame.new(-0.049045, 0.410061, 0.004974, 0.945132, 0.326322, -0.015467, -0.326656, 0.943317, -0.058733, -0.004576, 0.060563, 0.998154),
			["br_Bone"] = CFrame.new(-0.417415, 0.801304, -0.341858, -0.671654, -0.729941, -0.126756, 0.736496, -0.639295, -0.221078, 0.080339, -0.241843, 0.966984),
			["br_Bone.001"] = CFrame.new(-0.050546, 0.415587, 0.003025, 0.936688, 0.310802, 0.161299, -0.319086, 0.947323, 0.027617, -0.144219, -0.077337, 0.986519),
			["Left Shoulder"] = CFrame.new(-0.093429, 0.644036, 0.034763, -0.556328, 0.356957, -0.750387, -0.802469, -0.465237, 0.373628, -0.215739, 0.810022, 0.545271);
			["Right Shoulder"] = CFrame.new(0.093404, 0.644009, 0.034813, -0.556333, -0.356955, 0.750384, 0.802465, -0.465241, 0.373632, 0.21574, 0.810021, 0.545273);
			RootJoint = CFrame.new(0, 1.399455, -2.200066, 1, 0, 0, 0, -0.70674, 0.707473, 0, -0.707473, -0.70674);
			Neck = CFrame.new(0, -0.385788, 0.317618, 0.999898, -0.014289, -0.000001, 0.001246, 0.087222, -0.996188, 0.014234, 0.996086, 0.087231);
			["Right Hip"] = CFrame.new(0.441065, 0.361981, 0.499852, 0.631697, 0.774985, -0.018915, -0.650004, 0.542805, 0.531843, 0.422437, -0.323669, 0.846632);
			["Left Hip"] = CFrame.new(-0.440628, 0.361505, 0.500269, 0.6317, -0.774983, 0.018915, 0.650003, 0.542807, 0.531843, -0.422436, -0.32367, 0.846632);
		};
	};
]],

	},
		
	-- {
	-- 	nombre = "Mi animación 2",
	-- 	datos = [[
	-- 		(pega aquí tu animación completa)
	-- 	]],
	-- },
}

-- ========== LECTOR ==========
local function extractBlock(text, key)
	local s, e = text:find("%f[%w_]" .. key .. "%s*=%s*{")
	if not s then return nil end
	local depth, i = 1, e + 1
	while i <= #text and depth > 0 do
		local c = text:sub(i, i)
		if c == "{" then depth += 1 elseif c == "}" then depth -= 1 end
		i += 1
	end
	return text:sub(e + 1, i - 2)
end

local function toCFrame(nums)
	local t = {}
	for part in nums:gmatch("[^,]+") do
		local n = tonumber(part)
		if n then t[#t + 1] = n end
	end
	if #t == 12 then return CFrame.new(table.unpack(t)) end
	if #t == 3 then return CFrame.new(t[1], t[2], t[3]) end
end

local function parsePoses(block)
	local poses = {}
	if not block then return poses end
	for name, nums in block:gmatch('%["([^"]+)"%]%s*=%s*CFrame%.new%(([^%)]*)%)') do
		poses[name] = toCFrame(nums)
	end
	for name, nums in block:gmatch('([%a_][%w_]*)%s*=%s*CFrame%.new%(([^%)]*)%)') do
		poses[name] = toCFrame(nums)
	end
	return poses
end

local function parseOffsets(block)
	local o = {}
	if not block then return o end
	for name, v in block:gmatch('%["([^"]+)"%]%s*=%s*([%-%d%.]+)') do o[name] = tonumber(v) end
	for name, v in block:gmatch('([%a_][%w_]*)%s*=%s*([%-%d%.]+)') do o[name] = tonumber(v) end
	return o
end

local function parseAnimation(text)
	local anim = {
		offsets = parseOffsets(extractBlock(text, "offsets")),
		fullOffset = tonumber(text:match("fullOffset%s*=%s*([%-%d%.]+)")) or 0,
		speed = tonumber(text:match("%f[%w_]speed%s*=%s*([%-%d%.]+)")) or 1,
		a = parsePoses(extractBlock(text, "a")),
		b = parsePoses(extractBlock(text, "b")),
	}
	if next(anim.a) == nil then return nil end
	return anim
end

-- ========== REPRODUCCIÓN ==========
local ORDER = {"RootJoint", "Neck", "Left Shoulder", "Right Shoulder", "Left Hip", "Right Hip"}
local conn, stepConn, oldProps
local removed = {}
local colisionesOriginales = {}

local function ponerSinColision(char)
	for _, p in ipairs(char:GetChildren()) do
		if p:IsA("BasePart") and p.CanCollide then
			colisionesOriginales[p] = true
			p.CanCollide = false
		end
	end
end

local function restaurarColisiones()
	for p in pairs(colisionesOriginales) do
		if p.Parent then p.CanCollide = true end
	end
	colisionesOriginales = {}
end

local function stop()
	if conn then conn:Disconnect() conn = nil end
	if stepConn then stepConn:Disconnect() stepConn = nil end
	restaurarColisiones()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp and oldProps ~= nil then hrp.CustomPhysicalProperties = oldProps end
	oldProps = nil
	for _, r in ipairs(removed) do
		if r.parent and r.parent.Parent then r.clone.Parent = r.parent end
	end
	removed = {}
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function()
			hum.RequiresNeck = true
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end)
	end
end

local function play(anim)
	stop()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not (hum and hrp and char:FindFirstChild("Torso")) then
		return false, "Necesitas un personaje R6 (el tuyo es " .. (hum and tostring(hum.RigType) or "desconocido") .. ")"
	end

	local usaCuello = USAR_CUELLO and anim.a["Neck"] ~= nil
	if usaCuello then
		pcall(function()
			hum.RequiresNeck = false
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		end)
	end

	local joints = {}
	for _, name in ipairs(ORDER) do
		if anim.a[name] and (name ~= "Neck" or usaCuello) then
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("Motor6D") and d.Name == name then
					if d.Part0 and d.Part1 then
						joints[#joints + 1] = {
							name = name, part0 = d.Part0, part1 = d.Part1,
							c0 = d.C0, c1inv = d.C1:Inverse(),
						}
						removed[#removed + 1] = {clone = d:Clone(), parent = d.Parent}
						d:Destroy()
					end
					break
				end
			end
		end
	end

	-- el arreglo de peso solo hace falta si se mueve el RootJoint
	if anim.a["RootJoint"] then
		oldProps = hrp.CustomPhysicalProperties
		hrp.CustomPhysicalProperties = PhysicalProperties.new(DENSIDAD_HRP, 0.3, 0, 1, 1)
	end

	-- colisiones: las propias (si hay RootJoint) y las de otros jugadores (si SIN_COLISIONES)
	if anim.a["RootJoint"] or SIN_COLISIONES then
		stepConn = RunService.Stepped:Connect(function()
			ponerSinColision(char)
			if SIN_COLISIONES then
				for _, pl in ipairs(Players:GetPlayers()) do
					if pl ~= player and pl.Character then
						ponerSinColision(pl.Character)
					end
				end
			end
		end)
	end

	local t0 = os.clock()
	conn = RunService.Heartbeat:Connect(function()
		local el = os.clock() - t0
		for _, jd in ipairs(joints) do
			local a = anim.a[jd.name]
			local b = anim.b[jd.name] or a
			local off = anim.offsets[jd.name] or 0
			local phase = el * anim.speed + anim.fullOffset + off
			local alpha = 0.5 - 0.5 * math.cos(phase * math.pi * 2)
			jd.part1.CFrame = jd.part0.CFrame * jd.c0 * a:Lerp(b, alpha) * jd.c1inv
			jd.part1.AssemblyLinearVelocity = Vector3.zero
			jd.part1.AssemblyAngularVelocity = Vector3.zero
		end
	end)
	return true
end

player.CharacterAdded:Connect(function()
	if conn then conn:Disconnect() conn = nil end
	if stepConn then stepConn:Disconnect() stepConn = nil end
	colisionesOriginales = {}
	oldProps = nil
	removed = {}
end)

-- ========== GUI ==========
local function getGuiParent()
	local ok, pg = pcall(function() return player:WaitForChild("PlayerGui", 10) end)
	if ok and pg then return pg end
	local ok2, h = pcall(function() return gethui and gethui() end)
	if ok2 and h then return h end
	return game:GetService("CoreGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimMultiples"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
local guiParent = getGuiParent()
local viejo = guiParent:FindFirstChild("AnimMultiples")
if viejo then viejo:Destroy() end
gui.Parent = guiParent

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 400)
frame.Position = UDim2.fromOffset(20, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 26)
title.BackgroundTransparency = 1
title.Text = "Animaciones CFrame (R6)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -16, 0, 90)
box.Position = UDim2.fromOffset(8, 28)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
box.TextColor3 = Color3.new(1, 1, 1)
box.PlaceholderText = "Pega aquí una animación para probarla"
box.Text = ""
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextWrapped = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.ClipsDescendants = true
box.Font = Enum.Font.Code
box.TextSize = 11
box.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -16, 0, 16)
status.Position = UDim2.fromOffset(8, 122)
status.BackgroundTransparency = 1
status.Text = "Esperando animación..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame

local function makeBtn(parent, text, color, size, pos, callback)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = color
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.MouseButton1Click:Connect(callback)
	return b
end

local function reproducir(anim, nombre)
	local ok, err = play(anim)
	status.Text = ok and ("Reproduciendo: " .. nombre) or (err or "Error")
end

makeBtn(frame, "Probar lo pegado", Color3.fromRGB(50, 130, 70),
	UDim2.new(0.6, -12, 0, 30), UDim2.fromOffset(8, 142), function()
		local anim = parseAnimation(box.Text)
		if not anim then
			status.Text = "No se pudo leer (revisa el formato)"
			return
		end
		reproducir(anim, "pegada")
	end)

makeBtn(frame, "Parar", Color3.fromRGB(150, 50, 50),
	UDim2.new(0.4, -12, 0, 30), UDim2.new(0.6, 4, 0, 142), function()
		stop()
		status.Text = "Detenida"
	end)

local lista = Instance.new("ScrollingFrame")
lista.Size = UDim2.new(1, -16, 1, -184)
lista.Position = UDim2.fromOffset(8, 178)
lista.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
lista.BorderSizePixel = 0
lista.ScrollBarThickness = 4
lista.AutomaticCanvasSize = Enum.AutomaticSize.Y
lista.CanvasSize = UDim2.new()
lista.Parent = frame
Instance.new("UICorner", lista).CornerRadius = UDim.new(0, 6)
local ll = Instance.new("UIListLayout", lista)
ll.Padding = UDim.new(0, 4)
ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", lista).PaddingTop = UDim.new(0, 4)

for _, item in ipairs(Animaciones) do
	local anim = parseAnimation(item.datos)
	if anim then
		makeBtn(lista, item.nombre, Color3.fromRGB(50, 90, 150),
			UDim2.new(1, -12, 0, 30), UDim2.new(), function()
				reproducir(anim, item.nombre)
			end)
	else
		warn("No se pudo leer la animación: " .. tostring(item.nombre))
	end
end