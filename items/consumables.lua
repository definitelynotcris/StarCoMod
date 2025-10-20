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
    hidden = true,
    
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