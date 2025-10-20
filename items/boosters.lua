-- Booster Atlas
SMODS.Atlas{
    key = 'boosteratlas',
    path = 'boosteratlas.png',
    px = 71,
    py = 96,
}

SMODS.Sound({
    key = "music_HandymansMarch", 
    path = "music_HandymansMarch.ogg",
    pitch = 1,
    volume = 0.6,
    select_music_track = function()
        if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            if G.pack_cards
                and G.pack_cards.cards
                and G.pack_cards.cards[1]
                and G.pack_cards.cards[1].config
                and G.pack_cards.cards[1].config.center
                and G.pack_cards.cards[1].config.center.mod
                and G.pack_cards.cards[1].config.center.mod.id 
                and G.pack_cards.cards[1].config.center.mod.id == "StarCoMod" then
		        return true 
            end
        end
	end,
})

-- togif pack
SMODS.Booster{
    key = 'booster_togif',
    group_key = "k_star_booster_group",
    atlas = 'boosteratlas', 
    pos = { x = 0, y = 0 },
    discovered = true,
    loc_txt= {
        name = 'Togif Pack',
        text = { "Pick {C:attention}#1#{} card out",
                "{C:attention}#2#{} StarCoMod jokers", },
        group_name = "lolmao",
    },
    
    draw_hand = false,
    config = {
        extra = 4,
        choose = 1, 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 1,
    cost = 5,
    kind = "StarCoModPack",
    ease_background_colour = function(self)
        ease_background_colour({ new_colour = HEX("473671")})
    end,
    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "starcomodjoker",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
    select_card = 'jokers',


    in_pool = function() return true end
}

-- togif pack
SMODS.Booster{
    key = 'booster_crate',
    group_key = "k_star_booster_group",
    atlas = 'boosteratlas', 
    pos = { x = 1, y = 0 },
    discovered = true,
    loc_txt= {
        name = 'Secure Container',
        text = { "Pick {C:attention}#1#{} card out",
                "{C:attention}#2#{} Starscape jokers", },
        group_name = "lolmao 2",
    },
    
    draw_hand = false,
    config = {
        extra = 2,
        choose = 1, 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 0.6,
    cost = 3,
    kind = "StarCoModPack",
    
    ease_background_colour = function(self)
        ease_background_colour({ new_colour = HEX("000000")})
    end,

    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "starscape",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
    select_card = 'jokers',

    in_pool = function() return true end
}