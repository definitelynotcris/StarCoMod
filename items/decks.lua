SMODS.Atlas{
    key = 'decks',
    path = 'decks.png',
    px = 71,
    py = 95,
}

SMODS.Back({
    key = "scpdeck",
    loc_txt = {
        name = "rather inconspicuous photograph",
        text={
        "{C:attention}+1{} Joker slot",
        "Start with {C:attention}SCP-096{}",
        "already active",
        },
    },
	
	config = { joker_slot = 1, startingtime = 200},
	pos = { x = 0, y = 0 },
	order = 1,
	atlas = "decks",
    unlocked = true,

    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slot, self.config.startingtime} }
    end,

	apply = function(self)
        --G.jokers.config.card_limit = G.jokers.config.card_limit + self.config.joker_slot
        G.E_MANAGER:add_event(Event({
            trigger = "after", 
            delay = 2,
            func = function() 
                play_sound("star_vineboom", 1, 0.7)
                G.fourpixels = 600
                if not G.GAME.scptimer then G.GAME.scptimer =  self.config.startingtime end
                return true
            end
        })) 
	end,

	check_for_unlock = function(self, args)
		if args.type == "win_deck" then
            unlock_card(self)
        else
			unlock_card(self)
		end
	end,
})