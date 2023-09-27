// Antigaming Team 2014 //

AG.Recipes = {}

util.AddNetworkString("SendRequestRecipesToServer")
	net.Receive("SendRequestRecipesToServer", function(len, ply) 
	util.AddNetworkString("RecipesTable") 
	net.Start( "RecipesTable" )
				net.WriteTable(ply.Recipes) 
	net.Send(ply)
		print ("Request Player Recipes complete") 
	end)

function AG.LoadRecipes(ply)
	if file.Exists( "recipes/".. ply:UniqueID() ..".txt", "DATA" ) then
		recipes_coded = file.Read("recipes/".. ply:UniqueID() ..".txt")
		ply.Recipes = glon.decode(recipes_coded)
		MsgN("Player Recipes Loaded")
	else
		if(ply.Recipes==nil) then
			ply.Recipes = {}
			ply.Recipes[1] = 1
		end
		AG.RecipesSave(ply)
		MsgN("Player First Spawn")
	end
end
hook.Add( "PlayerInitialSpawn", "Player Loaded Recipes", AG.LoadRecipes )

function AG.RecipesSave(ply)
	file.Write("recipes/".. ply:UniqueID() ..".txt", glon.encode(ply.Recipes))
end

function AG.AddRecipe(ply,recipe_id)
	local recipe_key = table.Count(ply.Recipes) + 1
	ply.Recipes[recipe_key] = recipe_id
	AG.RecipesSave(ply)
end