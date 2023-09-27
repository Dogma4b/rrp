// Antigaming Team //

AG = {}

print("-----------------------------------------")
print("----Initialization Antigaming modules----")
print("-----------------------------------------")

AG.PathModules = "darkrp_modules/antigaming/"

local files, folders = file.Find(AG.PathModules.."*","LUA")
local num_modules = 0

for num, folder in pairs(folders) do
	//print("Module: "..folder.." loading")
	for _, File in pairs(file.Find(AG.PathModules..folder.."/sv_*.lua","LUA")) do
		include(AG.PathModules..folder.."/"..File)
	end
	
	for _, File in pairs(file.Find(AG.PathModules..folder.."/sh_*.lua","LUA")) do
		include(AG.PathModules..folder.."/"..File)
		AddCSLuaFile(AG.PathModules..folder.."/"..File)
	end
	
	for _, File in pairs(file.Find(AG.PathModules..folder.."/cl_*.lua","LUA")) do
		AddCSLuaFile(AG.PathModules..folder.."/"..File)
	end
	print("|> Module: "..folder.." loaded")
	num_modules = num_modules + 1
end

print("Loaded: "..num_modules.." modules")
print("All modules successfully loaded")
print("-----------------------------------------")
print("------------------END--------------------")
print("-----------------------------------------")