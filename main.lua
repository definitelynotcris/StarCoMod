--- STEAMODDED HEADER
--- MOD_NAME: StarCoMod
--- MOD_ID: StarCoMod
--- MOD_AUTHOR: [definitely not cris]
--- MOD_DESCRIPTION: gamign
--- PREFIX: star
----------------------------------------------
------------MOD CODE -------------------------
--shoutouts yahiamice 

if not StarCoMod then
	StarCoMod = {}
end

local mod_path = "" .. SMODS.current_mod.path
StarCoMod.path = mod_path
StarCoMod_config = SMODS.current_mod.config

-- effect manager for particles etc

G.effectmanager = {}

-- StarCoMod joker pool
SMODS.ObjectType({
	key = "starcomodjoker",
	default = "j_star_foxy",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

-- Starscape joker pool
SMODS.ObjectType({
	key = "starscape",
	default = "j_star_horizon",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

--void tarot pool
SMODS.ConsumableType({
	key = "star_void",
	default = "c_star_voidmagician",
	collection_rows = { 5, 6 },
	primary_colour = HEX("2C1857"),
    secondary_colour = HEX("6d4e8f"),
	loc_txt = {
		collection = 'Void Tarots',
		name = 'Void Tarot',
	},
	shop_rate = 1,
})


--Load item files
local files = NFS.getDirectoryItems(mod_path .. "items")
for _, file in ipairs(files) do
	print("[StarCoMod] Loading lua file " .. file)
	local f, err = SMODS.load_file("items/" .. file)
	if err then
		error(err) 
	end
	f()
end

--Load lib files
local files = NFS.getDirectoryItems(mod_path .. "libs/")
for _, file in ipairs(files) do
	print("[StarCoMod] Loading lib file " .. file)
	local f, err = SMODS.load_file("libs/" .. file)
	if err then
		error(err) 
	end
	f()
end

G.effectmanager = {}

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
	post_trigger = true,
}




----------------------------------------------------------
----------- MOD CODE END ----------------------------------
