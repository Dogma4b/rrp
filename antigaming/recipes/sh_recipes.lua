// Antigaming Team 2014 //

AG.Recipes = {}

function AG.GetCraftItem(id)
	return AG.Recipes[id]
end

AG.Recipes[501] = {team = "all", category = "resource", time = 100, components = {[301]=3, [302]=2}}