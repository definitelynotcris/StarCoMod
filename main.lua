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

-- Starscape joker pool
SMODS.ObjectType({
	key = "starscape",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
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

G.effectmanager = {}

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
	post_trigger = true,
}




----------------------------------------------------------
----------- MOD CODE END ----------------------------------
