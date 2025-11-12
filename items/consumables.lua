SMODS.Atlas{
    key = 'witchsheart', --atlas key
    path = 'witchsheart.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Consumable({
    key = "witchsheart",
    set = "Spectral",
    object_type = "Consumable",
    soul_set = "Spectral",
    name = "Witch's Heart",
    loc_txt = {
        name = "Witch's Heart",
        text={
        'Removes {C:enhanced}eternal{} from all {C:attention}Jokers{}',
        ' ',
        '"Do you have...                  ',
        "{C:red}a wish you'd be {}",
        '               {C:red}willing to kill for?{}"',
        },
    },
	
	
	pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },
	--order = 99,
	atlas = "witchsheart",
    unlocked = true,
    cost = 4,
    
    use = function(self, card, area, copier)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i].ability.eternal = false
        end
    end,

    can_use = function(self, card)
        return true
	end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})

------VOID TAROT EFFECTS------
SMODS.current_mod.calculate = function(self,context)
    if not G.GAME.star_corrupted_cards then 
        G.GAME.star_corrupted_cards = {} 
    end
    if G.GAME.starcoluck == nil then G.GAME.starcoluck = 0 end 
    if context.mod_probability then
        return {
            numerator = context.numerator + G.GAME.starcoluck
        }
    end
end

local sell_card_hook = Card.sell_card
function Card:sell_card()
    local hook = sell_card_hook(self)
    if G.jokers and self.ability.set == 'Joker' then
        G.GAME.last_sold_joker = {}
        local copied_card = copy_card(self, nil, 0) -- Creates a copy with 0 scale
        G.GAME.last_sold_joker[1] = copied_card
    end
    return hook
end
-----------------VOIDS-------------------
SMODS.Atlas{
    key = 'voidtarots', --atlas key
    path = 'VoidTarots.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Consumable({
    key = "voidfool",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Fool",
    loc_txt = {
        name = "Void Fool",
        text={
        "Creates the last sold",
        "{C:attention}Joker{} with {C:money}$0{} {C:attention}sell value",
        "{C:inactive}(Must have room)",
        "{C:red,E:2}Corrupts all Fools"
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=0, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        local copy = create_card('Joker', G.jokers, nil, nil, nil, nil, G.GAME.last_sold_joker[1].config.center.key, nil)
        copy.sell_cost = 0
        copy:add_to_deck()
        G.jokers:emplace(copy)

        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Fool"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    can_use = function(self, card)
        return G.GAME.last_sold_joker and G.GAME.last_sold_joker[1] ~= nil and G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('fool',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Fool"] == true then card:set_ability("c_star_voidfool") end
    end
    },
    true
)

------------------------------------

SMODS.Consumable({
    key = "voidmagician",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Magician",
    loc_txt = {
        name = "Void Magician",
        text={
        "Permanently increases",
        "{C:green}luck{} by {C:attention}0.2{}",
        "{C:inactive}(ex: {}{C:green}2 in 4{}{C:inactive} -> {}{C:green}2.2 in 4{}{C:inactive})",
        "{C:red,E:2}Corrupts all Magicians"
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=1, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    G.GAME.starcoluck = G.GAME.starcoluck + 0.2
                    if not G.GAME.star_corrupted_cards then
			            G.GAME.star_corrupted_cards = {}
		            end
                    G.GAME.star_corrupted_cards["Magician"] = true 
                return true
            end
         }))
         delay(0.6)
    end,

    can_use = function(self, card)
        return true
	end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('magician',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Magician"] == true then card:set_ability("c_star_voidmagician") end
    end
    },
    true
)
---------------------------------------------

SMODS.Consumable({
    key = "voidhigh_priestess",
    set = "star_void",
    object_type = "Consumable",
    name = "Void High Priestess",
    loc_txt = {
        name = "Void High Priestess",
        text={
        "Creates a {C:planet}Planet{} Card",
        "of your most played {C:attention}Poker Hand",
        "{C:red,E:2}Corrupts all High Priestesses",
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=2, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        local card_type = 'Planet'
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.0,
            func = function()
                --gets most played hand (from telescope)
                local _planet, _hand, _tally = nil, nil, 0
                for _, handname in ipairs(G.handlist) do
                    if SMODS.is_poker_hand_visible(handname) and G.GAME.hands[handname].played > _tally then
                        _hand = handname
                        _tally = G.GAME.hands[handname].played
                    end
                end

                if _hand then --get planet card
                    for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == _hand then
                            _planet = v.key
                        end
                    end
                end

                  local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, nil)
                  card:add_to_deck()
                  G.consumeables:emplace(card)
                  G.GAME.consumeable_buffer = 0
                  return true
                end
        }))

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["High Priestess"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('high_priestess',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["High Priestess"] == true then card:set_ability("c_star_voidhigh_priestess") end
    end
    },
    true
)

---------------------------------------------

SMODS.Consumable({
    key = "voidempress",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Empress",
    loc_txt = {
        name = "Void Empress",
        text={
            "Permanently add {C:mult}+#1# mult{}",
            "to {C:attention}2{} selected cards",
            "{C:red,E:2}Corrupts all Empresses",
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=3, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = {extra = { mult = 2, max_highlighted = 2}},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.max_highlighted }}
    end,
    
    
    use = function(self, card, area, copier)
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i].ability.perma_mult = G.hand.highlighted[i].ability.perma_mult + card.ability.extra.mult
                    SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.MULT}, G.hand.highlighted[i])
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot2', percent, 0.6)
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Empress"] = true 
        --print (G.GAME.star_corrupted_cards)
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('empress',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Empress"] == true then card:set_ability("c_star_voidempress") end
    end
    },
    true
)

---------------------------------------------

SMODS.Consumable({
    key = "voidemperor",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Emperor",
    loc_txt = {
        name = "Void Emperor",
        text={
        "Creates up to {C:attention}#1#",
        "random {C:tarot}Void Tarot{} cards",
        "{C:inactive}(Must have room)",
        "{C:red,E:2}Corrupts all Emperors",
        },
    },
    config = { extra = { voids = 2 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.voids } }
    end,
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=4, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,




    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.extra.voids, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani') 
                        --this fucking sucks hidden cards stay hidden even for the set theyre a part of so i have to use a fuckton of ifs here WHY   
                        local tocreate = math.random(1, 22)
                        local tocreatekey = 'c_star_voidfool'
                            if tocreate == 1 then tocreatekey = 'c_star_voidfool'  
                            elseif tocreate == 2 then tocreatekey = 'c_star_voidmagician'  
                            elseif tocreate == 3 then tocreatekey = 'c_star_voidhigh_priestess'  
                            elseif tocreate == 4 then tocreatekey = 'c_star_voidempress'  
                            elseif tocreate == 5 then tocreatekey = 'c_star_voidemperor'  
                            elseif tocreate == 6 then tocreatekey = 'c_star_voidhierophant'  
                            elseif tocreate == 7 then tocreatekey = 'c_star_voidlovers'  
                            elseif tocreate == 8 then tocreatekey = 'c_star_voidchariot'  
                            elseif tocreate == 9 then tocreatekey = 'c_star_voidjustice'  
                            elseif tocreate == 10 then tocreatekey = 'c_star_voidhermit'  
                            elseif tocreate == 11 then tocreatekey = 'c_star_voidwheel_of_fortune'  
                            elseif tocreate == 12 then tocreatekey = 'c_star_voidstrength'  
                            elseif tocreate == 13 then tocreatekey = 'c_star_voidhanged_man'  
                            elseif tocreate == 14 then tocreatekey = 'c_star_voiddeath'  
                            elseif tocreate == 15 then tocreatekey = 'c_star_voidtemperance'  
                            elseif tocreate == 16 then tocreatekey = 'c_star_voiddevil'  
                            elseif tocreate == 17 then tocreatekey = 'c_star_voidtower'  
                            elseif tocreate == 18 then tocreatekey = 'c_star_voidstar'  
                            elseif tocreate == 19 then tocreatekey = 'c_star_voidmoon'  
                            elseif tocreate == 20 then tocreatekey = 'c_star_voidsun'  
                            elseif tocreate == 21 then tocreatekey = 'c_star_voidjudgement'  
                            elseif tocreate == 22 then tocreatekey = 'c_star_voidworld' end
                           --print(tocreatekey)
                        local newcard = SMODS.create_card({set = 'star_void', area = G.consumeables, key = tocreatekey})
                        G.consumeables:emplace(newcard)
                        G.GAME.consumeable_buffer = 0
                        card:juice_up(0.3, 0.5)
                    end
                    if not G.GAME.star_corrupted_cards then
			            G.GAME.star_corrupted_cards = {}
		            end
                    G.GAME.star_corrupted_cards["Emperor"] = true 
                return true
                end
            }))
        end
        delay(0.6)
    end,

    can_use = function(self, card)
        return true
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('emperor',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Emperor"] == true then card:set_ability("c_star_voidemperor") end
    end
    },
    true
)

------------------------------------

SMODS.Consumable({
    key = "voidhierophant",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Hierophant",
    loc_txt = {
        name = "Void Hierophant",
        text={
        "Permanently add {C:chips}+#1# chips{}",
        "to {C:attention}2{} selected cards",
        "{C:red,E:2}Corrupts all Hierophants",
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=5, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = {extra = { chips = 15, max_highlighted = 2}},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.max_highlighted }}
    end,
    
    
    use = function(self, card, area, copier)
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i].ability.perma_bonus = G.hand.highlighted[i].ability.perma_bonus + card.ability.extra.chips
                    SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.CHIPS}, G.hand.highlighted[i])
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot2', percent, 0.6)
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Hierophant"] = true 
        --print (G.GAME.star_corrupted_cards)
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('heirophant', --why is it spelled wrong here
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Hierophant"] == true then card:set_ability("c_star_voidhierophant") end
    end
    },
    true
)

------------------------------------

SMODS.Consumable({
    key = "voidlovers",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Lovers",
    loc_txt = {
        name = "Void Lovers",
        text={
        "Converts {C:attention}#1#{} random",
        "cards into {C:attention}Wild Cards",
        "{C:red,E:2}Corrupts all Lovers"
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=6, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { converted = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.converted} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        --tochange = pickrandomfromhand(card.ability.extra.converted)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        changerandomcards(card.ability.extra.converted, 'm_wild')
        delay(0.5)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Lovers"] = true 
        --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('lovers',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Lovers"] == true then card:set_ability("c_star_voidlovers") end
    end
    },
    true
)

------------------------------------

SMODS.Consumable({
    key = "voidchariot",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Chariot",
    loc_txt = {
        name = "Void Chariot",
        text={
        "Converts {C:attention}#1#{} random",
        "cards into {C:attention}Steel Cards",
        "{C:red,E:2}Corrupts all Chariots"
        },
    },

    
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=7, y= 0},
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { converted = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.converted} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        --tochange = pickrandomfromhand(card.ability.extra.converted)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        changerandomcards(card.ability.extra.converted, 'm_steel')
        delay(0.5)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Chariot"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('chariot',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Chariot"] == true then card:set_ability("c_star_voidchariot") end
    end
    },
    true
)

------------------------------------


SMODS.Consumable({
    key = "voidjustice",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Justice",
    loc_txt = {
        name = "Void Justice",
        text={
        "Converts {C:attention}#1#{} random",
        "cards into {C:attention}Glass Cards",
        "{C:red,E:2}Corrupts all Justices"
        },
    },
	
    pools = { ["star_void"] = true},

	hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,
	pos = {x=8, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { converted = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.converted} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        --tochange = pickrandomfromhand(card.ability.extra.converted)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        changerandomcards(card.ability.extra.converted, 'm_glass')
        delay(0.5)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Justice"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('justice',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Justice"] == true then card:set_ability("c_star_voidjustice") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidhermit",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Hermit",
    loc_txt = {
        name = "Void Hermit",
        text={
        "Permanently increases",
        "max {C:money}interest{} by {C:attention}#2#",
        "{C:red,E:2}Corrupts all Hermits"
        },
    },
    config = { extra = { interest = 5, displayinterest = 1 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.interest, card.ability.extra.displayinterest} }
    end,
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=9, y= 0},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,
    
    use = function(self, card, area, copier)
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest
                    if not G.GAME.star_corrupted_cards then
			            G.GAME.star_corrupted_cards = {}
		            end
                    G.GAME.star_corrupted_cards["Hermit"] = true 
                return true
            end
         }))
         delay(0.6)
    end,

    can_use = function(self, card)
        return true
	end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('hermit',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Hermit"] == true then card:set_ability("c_star_voidhermit") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidwheel_of_fortune",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Wheel of Fortune",
    loc_txt = {
        name = "Void Wheel of Fortune",
        text={
            "{C:green}#1# in #2#{} chance to",
            "make {C:attention}all Jokers",
            "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
            "{C:dark_edition}Polychrome{} edition",
            "{C:inactive}(Overrides existing editions)",
            "{C:red,E:2}Corrupts all Wheels of Fortune",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=0, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { mainodds = 1, totalodds = 4 } },

    loc_vars = function(self, info_queue, center)
        local numerator, denominator = SMODS.get_probability_vars(card, center.ability.extra.mainodds, center.ability.extra.totalodds, 'voidwheeloffortune')    
        return {vars = {numerator, denominator}}
    end,
    
    use = function(self, card, area, copier)
        if SMODS.pseudorandom_probability(card, 'vremade_wheel_of_fortune', card.ability.extra.mainodds, card.ability.extra.totalodds) then
            local edition = poll_edition('star_voidwheel_of_fortune', nil, true, true, { 'e_polychrome', 'e_holo', 'e_foil' })
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:set_edition(edition, true)
            end
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end


        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Wheel of Fortune"] = true 
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards > 0
	end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('wheel_of_fortune',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Wheel of Fortune"] == true then card:set_ability("c_star_voidwheel_of_fortune") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidstrength",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Strength",
    loc_txt = {
        name = "Void Strength",
        text={
        "Upgrade {C:attention}1 Joker",
        "to a random {C:attention}Joker",
        "of the next {C:legendary}rarity",
        "{C:inactive}(up to Rare)",
        "{C:red,E:2}Corrupts all Strengths",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=1, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = {extra = { max_highlighted = 1}},

    loc_vars = function(self, info_queue, card)
        return { vars = { }}
    end,
    
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and not G.jokers.highlighted[1].ability.eternal
	end,

    use = function(self, card, area, copier)
        toupgrade = G.jokers.highlighted[1]
        local rarity = 0
        local legendary = false
        rarity = G.jokers.highlighted[1].config.center.rarity
        rarity = math.min(4, rarity + 1)
        if rarity == 1 then
        rarity = 0
        elseif rarity == 2 then
           rarity = 0.9
        elseif rarity == 3 then
           rarity = 0.9 --change to 0.99 to allow rare -> legendary
        elseif rarity == 4 then legendary = true end

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("timpani")
                    card:juice_up(0.3, 0.5)
                    toupgrade:flip()
                return true
            end
        }))
        local newcard = create_card("Joker", nil, legendary, rarity, nil, nil, nil, "IstoleThisCodeFromCryptid")
        toupgrade:set_ability(newcard.config.center.key, nil, true)
        newcard:remove()
        newcard = nil
        toupgrade:flip()
        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Strength"] = true 
        --print (G.GAME.star_corrupted_cards)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('strength',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Strength"] == true then card:set_ability("c_star_voidstrength") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidhanged_man",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Hanged Man",
    loc_txt = {
        name = "Void Hanged Man",
        text={
        "Create {C:attention}#1#{} copy of",
        "{C:attention}#2#{} selected card",
        "in your hand",
        "{C:red,E:2}Corrupts all Hanged Men",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=2, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { max_highlighted = 1, extra = { cards = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards, card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted == 1 --and #G.hand.highlighted <= card.ability.extra.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                _first_dissolve = false
                local _card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.hand:emplace(_card)
                _card:start_materialize(nil, _first_dissolve)
                _first_dissolve = true
                SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
                return true
            end
        }))

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Hanged Man"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('hanged_man',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Hanged Man"] == true then card:set_ability("c_star_voidhanged_man") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voiddeath",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Death",
    loc_txt = {
        name = "Void Death",
        text={
        "Destroy {C:attention}#1#{} random {C:attention}Joker{},",
        "permanently gain {C:red}+#2#{} discard",
        "each round if destroyed",
        "{C:red,E:2}Corrupts all Deaths",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=3, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { destroyed = 1, bonus = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.destroyed, card.ability.extra.bonus } }
    end,
    
    use = function(self, card, area, copier)
        local destroyable_jokers = {}
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then
                destroyable_jokers[#destroyable_jokers + 1] = G.jokers.cards[i]
            end
        end
        local joker_to_destroy = pseudorandom_element(destroyable_jokers, 'star_voiddeath')
        if joker_to_destroy then
            joker_to_destroy.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("timpani")
                    card:juice_up(0.3, 0.5)
                    joker_to_destroy:start_dissolve()
                    return true
                end
            }))
            delay(0.6)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.bonus
            ease_discard(card.ability.extra.bonus)
        end
        
        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Death"] = true 
       --print (G.GAME.star_corrupted_cards)
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards > 0
	end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('death',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Death"] == true then card:set_ability("c_star_voiddeath") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidtemperance",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Temperance",
    loc_txt = {
        name = "Void Temperance",
        text={
        "Select {C:attention}1 Joker{} to sell",
        "for {C:attention}#1#X{} it's sell value",
        "{C:red,E:2}Corrupts all Temperances",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=4, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = {extra = { max_highlighted = 1, sellmult = 10, money = 0}},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sellmult, card.ability.extra.money}}
    end,
    
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and not G.jokers.highlighted[1].ability.eternal
	end,

    use = function(self, card, area, copier)
        card.ability.extra.money = G.jokers.highlighted[1].sell_cost * card.ability.extra.sellmult
          G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
              play_sound("timpani")
              card:juice_up(0.3, 0.5)
              ease_dollars((card.ability.extra.money), true)
              return true
          end
        }))
        G.jokers.highlighted[1]:start_dissolve(nil, false)
        if not G.GAME.star_corrupted_cards then
			G.GAME.star_corrupted_cards = {}
		end
        G.GAME.star_corrupted_cards["Temperance"] = true 
        --print (G.GAME.star_corrupted_cards)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('temperance',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Temperance"] == true then card:set_ability("c_star_voidtemperance") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voiddevil",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Devil",
    loc_txt = {
        name = "Void Devil",
        text={
        "Converts {C:attention}#1#{} random",
        "cards into {C:attention}Gold Cards",
        "{C:red,E:2}Corrupts all Devils"
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=5, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { converted = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.converted} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        --tochange = pickrandomfromhand(card.ability.extra.converted)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        changerandomcards(card.ability.extra.converted, 'm_gold')
        delay(0.5)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Devil"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('devil',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Devil"] == true then card:set_ability("c_star_voiddevil") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidtower",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Tower",
    loc_txt = {
        name = "Void Tower",
        text={
        "Converts {C:attention}#1#{} random",
        "cards into {C:attention}Stone Cards",
        "{C:red,E:2}Corrupts all Towers"
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=6, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { converted = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.converted} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        --tochange = pickrandomfromhand(card.ability.extra.converted)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        changerandomcards(card.ability.extra.converted, 'm_stone')
        delay(0.5)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Tower"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('tower',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Tower"] == true then card:set_ability("c_star_voidtower") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidstar",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Star",
    loc_txt = {
        name = "Void Star",
        text={
        "Add {C:attention}#1#{} random",
        "{C:attention}Enhanced Diamond{} cards",
        "to your hand",
        "{C:red,E:2}Corrupts all Stars",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=7, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { created = 3 } },
loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.created,} }
end,

can_use = function(self, card)
    return G.hand and #G.hand.cards > 1
end,

use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = function()
            local cards = {}
            for i = 1, card.ability.extra.created do
                local _cards = {}
                for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                    local rank = SMODS.Ranks[rank_key]
                    table.insert(_cards, rank) 
                end
                local _rank = pseudorandom_element(_cards, 'voidstar2').card_key
                local cen_pool = {}
                for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                        cen_pool[#cen_pool + 1] = enhancement_center
                    end
                end
                local enhancement = pseudorandom_element(cen_pool, 'voidstar')
                cards[i] = SMODS.add_card { set = "Base", rank = _rank, suit= 'Diamonds', enhancement = enhancement.key }
            end
            SMODS.calculate_context({ playing_card_added = true, cards = cards })
            return true
        end
    }))
    delay(0.3)

    if not G.GAME.star_corrupted_cards then
	    G.GAME.star_corrupted_cards = {}
    end
    G.GAME.star_corrupted_cards["Star"] = true 
   --print (G.GAME.star_corrupted_cards)

    delay(0.6)
end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('star',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Star"] == true then card:set_ability("c_star_voidstar") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidmoon",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Moon",
    loc_txt = {
        name = "Void Moon",
        text={
        "Add {C:attention}#1#{} random",
        "{C:attention}Enhanced Club{} cards",
        "to your hand",
        "{C:red,E:2}Corrupts all Moons",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=8, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { created = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.created,} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra.created do
                    local _cards = {}
                    for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                        local rank = SMODS.Ranks[rank_key]
                        table.insert(_cards, rank) 
                    end
                    local _rank = pseudorandom_element(_cards, 'voidmoon2').card_key
                    local cen_pool = {}
                    for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = enhancement_center
                        end
                    end
                    local enhancement = pseudorandom_element(cen_pool, 'voidmoon')
                    cards[i] = SMODS.add_card { set = "Base", rank = _rank, suit= 'Clubs', enhancement = enhancement.key }
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Moon"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('moon',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Moon"] == true then card:set_ability("c_star_voidmoon") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidsun",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Sun",
    loc_txt = {
        name = "Void Sun",
        text={
        "Add {C:attention}#1#{} random",
        "{C:attention}Enhanced Heart{} cards",
        "to your hand",
        "{C:red,E:2}Corrupts all Suns",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=9, y= 1},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { created = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.created,} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra.created do
                    local _cards = {}
                    for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                        local rank = SMODS.Ranks[rank_key]
                        table.insert(_cards, rank) 
                    end
                    local _rank = pseudorandom_element(_cards, 'voidsun2').card_key
                    local cen_pool = {}
                    for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = enhancement_center
                        end
                    end
                    local enhancement = pseudorandom_element(cen_pool, 'voidsun')
                    cards[i] = SMODS.add_card { set = "Base", rank = _rank, suit= 'Hearts', enhancement = enhancement.key }
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["Sun"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('sun',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Sun"] == true then card:set_ability("c_star_voidsun") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidjudgement",
    set = "star_void",
    object_type = "Consumable",
    name = "Void Judgement",
    loc_txt = {
        name = "Void Judgement",
        text={
        "Creates a random",
        "{C:attention}Skip Tag",
        "{C:red,E:2}Corrupts all Judgements"
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=0, y= 2},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    add_to_deck = function(self, card, from_debuff)
        --print("lmao")
    end,
    
    use = function(self, card, area, copier)
        local tag_pool = get_current_pool('Tag')
            G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                    local tag_pool = get_current_pool('Tag')
                        local selected_tag = pseudorandom_element(tag_pool, pseudoseed('star_voidjudgement'))
                        local it = 1
                        while selected_tag == 'UNAVAILABLE' do
                            it = it + 1
                            selected_tag = pseudorandom_element(tag_pool, pseudoseed('star_voidjudgement'..it))
                        end
                add_tag(Tag(selected_tag, false, 'Small'))
                if not G.GAME.star_corrupted_cards then
			        G.GAME.star_corrupted_cards = {}
		        end
                G.GAME.star_corrupted_cards["Judgement"] = true 
            return true
            end
         }))
         delay(0.6)
    end,

    can_use = function(self, card)
        return true
	end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('judgement',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["Judgement"] == true then card:set_ability("c_star_voidjudgement") end
    end
    },
    true
)

------------------------------------
SMODS.Consumable({
    key = "voidworld",
    set = "star_void",
    object_type = "Consumable",
    name = "Void World",
    loc_txt = {
        name = "Void World",
        text={
        "Add {C:attention}#1#{} random",
        "{C:attention}Enhanced Spade{} cards",
        "to your hand",
        "{C:red,E:2}Corrupts all Worlds",
        },
    },
	
    pools = { ["star_void"] = true},
	
    hidden = true,
    soul_set = 'Tarot',
    soul_rate = 0.003,

	pos = {x=1, y= 2},
	--order = 99,
	atlas = "voidtarots",
    unlocked = true,
    cost = 4,

    config = { extra = { created = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.created,} }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra.created do
                    local _cards = {}
                    for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                        local rank = SMODS.Ranks[rank_key]
                        table.insert(_cards, rank) 
                    end
                    local _rank = pseudorandom_element(_cards, 'voidworld2').card_key
                    local cen_pool = {}
                    for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = enhancement_center
                        end
                    end
                    local enhancement = pseudorandom_element(cen_pool, 'voidworld')
                    cards[i] = SMODS.add_card { set = "Base", rank = _rank, suit= 'Spades', enhancement = enhancement.key }
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)

        if not G.GAME.star_corrupted_cards then
		    G.GAME.star_corrupted_cards = {}
	    end
        G.GAME.star_corrupted_cards["World"] = true 
       --print (G.GAME.star_corrupted_cards)

        delay(0.6)
    end,

    in_pool = function(self, args)
        return true
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
})
SMODS.Consumable:take_ownership('world',
    { -- table of properties to change from the existing object
    set_ability = function(self, card, initial, delay_sprites)
        if G.GAME.star_corrupted_cards and G.GAME.star_corrupted_cards["World"] == true then card:set_ability("c_star_voidworld") end
    end
    },
    true
)

function changerandomcards(num, enhancement)
    local tochange = pickrandomfromhand(num)
    for i = 1, #tochange do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                tochange[i]:flip()
                play_sound('card1')
                tochange[i]:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
    delay(0.2)
    for i = 1, #tochange do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                tochange[i]:set_ability(enhancement)
                return true
            end
        }))
    end
    for i = 1, #tochange do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                tochange[i]:flip()
                play_sound('tarot2')
                tochange[i]:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
end

function pickrandomfromhand(num)
    G.hand:unhighlight_all()
    local hand = {}
    local chosencards = {}
    for i, v in ipairs(G.hand.cards) do
        hand[i] = v
    end
    for i = 1, math.min(num, #hand) do
        chosen = math.random(#hand)
        table.insert(chosencards, hand[chosen])
        table.remove(hand, chosen)
    end
    return chosencards --returns cards in list
end

