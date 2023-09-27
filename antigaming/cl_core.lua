// Antigaming Team //

AG = {}

AG.PathModules = "darkrp_modules/antigaming/"

local files, folders = file.Find(AG.PathModules.."*","LUA")
local num_modules = 0

for num, folder in pairs(folders) do
	for _, File in pairs(file.Find(AG.PathModules..folder.."/cl_*.lua","LUA")) do
		include(AG.PathModules..folder.."/"..File)
	end
	
	for _, File in pairs(file.Find(AG.PathModules..folder.."/sh_*.lua","LUA")) do
		include(AG.PathModules..folder.."/"..File)
	end
end