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
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'star_togifpack' and 100 or nil
	end,
})
SMODS.Sound({
    key = "music_starscapespaceambience", 
    path = "music_starscapespaceambience.ogg",
    pitch = 1,
    volume = 0.6,
    select_music_track = function()
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'star_scapepack' and 100 or nil
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
        group_name = "xd",
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
    kind = "star_togifpack",
    ease_background_colour = function(self)
        ease_background_colour({ new_colour = HEX("134f4d")})
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

-- starscape pack
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

    weight = 0.4,
    cost = 3,
    kind = "star_scapepack",
    
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

