SMODS.Atlas {
    key = "starcoblinds",
    path = "blindsatlas.png",
    px = 34,
    py = 34,
    frames = 1,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind {
    name = "boss_3star",
    key = "boss_3star",
    atlas = "starcoblinds",
    mult = 2,
    pos = { y = 0 },
    dollars = 5,
    loc_txt = {
        name = '000 Guarantee Decaextraction Ticket',
        text = {
            'Attempts to add an',
            '{C:enhanced}eternal {}{C:attention}Potential Joker{}',
            'every hand',
        }
    },
    boss = {  min = 2 },
    boss_colour = HEX('795223'),

    press_play = function(self)
        if not G.GAME.blind.disabled then
            if #G.jokers.cards < G.jokers.config.card_limit then
                addPotentialMan()
                delay(0.7)
            end
        end
    end
}

SMODS.Blind {
    name = "boss_disruptor",
    key = "boss_disruptor",
    atlas = "starcoblinds",
    mult = 2,
    pos = { y = 1 },
    dollars = 5,
    loc_txt = {
        name = 'Warp Disruptor',
        text = {
            'Debuffs all',
            '{C:attention}starscape{} ships',
        }
    },
    boss = {  min = 1 },
    boss_colour = HEX('0f0f0f'),

    recalc_debuff = function(self, card)
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.starscape then
                G.jokers.cards[i]:set_debuff(true)
            end
        end
    end,

    disable = function(self)
       for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(false)
       end
    end,

    defeat = function(self)
       for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(false)
       end
    end,
}
------------------------------------------

SMODS.Sound({
    key = "music_receiveyou", 
    path = "music_receiveyou.ogg",
    pitch = 1,
    volume = 0.2,
    select_music_track = function()
        if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.name == 'boss_dod' then
		    return true end
	end,
})
SMODS.Sound({key = "essenceofbrawling", path = "essenceofbrawling.ogg"})

SMODS.Blind {
    name = "boss_dod",
    key = "boss_dod",
    atlas = "starcoblinds",
    mult = 3,
    pos = { y = 3 },
    dollars = 15,
    loc_txt = {
        name = 'Dragon of Dojima',
        text = {
            'Attacks when flame',
            'effects are triggered',
        }
    },
    boss = { showdown = true },
    boss_colour = HEX('fefefe'),


    set_blind = function(self, reset, silent)
        local triggered = false
        love.audio.stop()
    end,

    calculate = function(self,card,context)
       
       
       G.E_MANAGER:add_event(Event({
            func = function()
                
                --print(triggered)
                --print(G.GAME.blind.chips)
                --print(mult.. " mult and "..hand_chips)
                if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.name == 'boss_dod' then
                if G.GAME.blind.chips > 0 and context.after then
                    if (G.GAME.blind.chips < (mult*hand_chips)) then
                --if G.ARGS.chip_flames.real_intensity > 0.000001 then --and 
                        G.GAME.blind.chips = G.GAME.blind.chips + (mult*hand_chips)
                         G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        
                        beatTheEverLovingShitOutOfAJoker()
                        
                        return true
                    end
                end
                end
            end,
            blocking = false
        }))
       
    end,

}
---------------------------------------------------

SMODS.Sound({
    key = "music_maddog", 
    path = "music_maddog.ogg",
    pitch = 1,
    volume = 0.2,
    select_music_track = function()
        if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.name == 'boss_mdos' then
		    return true end
	end,
})
SMODS.Sound({key = "heatactiontrigger", path = "heatactiontrigger.ogg"})

SMODS.Blind {
    name = "boss_mdos",
    key = "boss_mdos",
    atlas = "starcoblinds",
    mult = 3,
    pos = { y = 4 },
    dollars = 15,
    loc_txt = {
        name = 'Mad Dog of Shimano',
        text = {
            'Attacks when flame',
            'effects are triggered',
        }
    },
    boss = { showdown = true },
    boss_colour = HEX('fefefe'),


    set_blind = function(self, reset, silent)
        love.audio.stop()
        local triggered = false
    end,

    calculate = function(self,card,context)
       G.E_MANAGER:add_event(Event({
            func = function()          
                --print(triggered)
                --print(G.GAME.blind.chips)
                --print(mult.. " mult and "..hand_chips)
                if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.name == 'boss_mdos' then
                if G.GAME.blind.chips > 0 and context.after then
                    if (G.GAME.blind.chips < (mult*hand_chips)) then
                --if G.ARGS.chip_flames.real_intensity > 0.000001 then --and triggered == false then
                        G.GAME.blind.chips = G.GAME.blind.chips + (mult*hand_chips)
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        sliceTheEverLovingShitOutOfYourHand()
                        return true
                    end
                end
                end
                
            end,
            blocking = false
        }))
       
    end,

}
--------------------------------------------------
SMODS.Blind {
    name = "boss_don",
    key = "boss_don",
    atlas = "starcoblinds",
    mult = 1,
    pos = { y = 2 },
    dollars = 7,
    loc_txt = {
        name = 'Don (has hammers)',
        text = {
            'Destroys 1 selected card',
            'every played hand',
        }
    },
    boss = {  min = 1 },
    boss_colour = HEX('d383f3'),

  press_play = function(self)
    
  --for k,v in pairs(G.GAME.hands) do print(k) end --checking to see if the game even recognizes my hand

    if G.GAME.blind.disabled then
      return
    end
    
    
    if table.getn(G.hand.highlighted) > 1 then
    local card = pseudorandom_element(G.hand.highlighted, pseudoseed("hammers"))
    G.E_MANAGER:add_event(Event {
      trigger = "before",
      delay = 0.5,
      func = function()
            card:start_dissolve()
            card = nil
        return true
      end,
    })
    return true
    else
    local card = pseudorandom_element(G.hand.cards, pseudoseed("fuck you i aint coding ts"))
    G.E_MANAGER:add_event(Event {
      trigger = "before",
      delay = 0.5,
      func = function()
            card:start_dissolve()
            card = nil
        return true
      end,
    })
    end
  end,
}

SMODS.Blind {
    name = "boss_elegerd",
    key = "boss_elegerd",
    atlas = "starcoblinds",
    mult = 2,
    pos = { y = 7 },
    dollars = 5,
    loc_txt = {
        name = 'elegerd',
        text = {
            'Fucks with',
            'your settings',
        }
    },
    boss = {  min = 2 },
    boss_colour = HEX('54c4ec'),


    set_blind = function(self, reset, silent)   
        self.old_colourblind_option = G.SETTINGS.colourblind_option
        self.old_play_button_pos = G.SETTINGS.play_button_pos
        self.old_screenshake = G.SETTINGS.screenshake
        self.old_texture_scaling = G.SETTINGS.GRAPHICS.texture_scaling
        self.old_crt = G.SETTINGS.GRAPHICS.crt
        self.old_bloom = G.SETTINGS.GRAPHICS.bloom
        self.old_shadows = G.SETTINGS.GRAPHICS.shadows
        self.old_vsync = G.SETTINGS.WINDOW.vsync
        self.old_gamespeed = G.SETTINGS.GAMESPEED
        self.old_volume = G.SETTINGS.SOUND.volume
        self.old_music_volume = G.SETTINGS.SOUND.music_volume
        self.old_game_sounds_volume = G.SETTINGS.SOUND.game_sounds_volume
    end,

    press_play = function(self)
        if not G.GAME.blind.disabled then


            local colorblind = math.random(1,2)
            if colorblind == 1 then G.SETTINGS.colourblind_option = true
            else G.SETTINGS.colourblind_option = false end

            G.SETTINGS.play_button_pos = math.random(1,2)

            G.SETTINGS.screenshake = math.random(0,200)

            G.SETTINGS.GRAPHICS.texture_scaling = math.random(1,2)

            G.SETTINGS.GRAPHICS.crt = math.random(0,100)

            G.SETTINGS.GRAPHICS.bloom = math.random(1,2)

            local shadows = math.random(1,2)
            if shadows == 1 then G.SETTINGS.GRAPHICS.shadows = "On"
            else G.SETTINGS.colourblind_option = "Off" end

            G.SETTINGS.WINDOW.vsync = math.random(1,2)

            local rgamespeed = math.random(1,4)
            if rgamespeed == 1 then G.SETTINGS.GAMESPEED = 0.5
            elseif rgamespeed == 2 then G.SETTINGS.GAMESPEED = 1
            elseif rgamespeed == 3 then G.SETTINGS.GAMESPEED = 2
            else G.SETTINGS.GAMESPEED = 4 end

            G.SETTINGS.SOUND.volume = math.random(0,200)
            G.SETTINGS.SOUND.music_volume = math.random(0,200)
            G.SETTINGS.SOUND.game_sounds_volume = math.random(0,200)

            --print(G.SETTINGS)
            
        end
    end,

    disable = function(self)
        G.SETTINGS.colourblind_option = self.old_colourblind_option 
        G.SETTINGS.play_button_pos = self.old_play_button_pos 
        G.SETTINGS.screenshake = self.old_screenshake 
        G.SETTINGS.GRAPHICS.texture_scaling = self.old_texture_scaling 
        G.SETTINGS.GRAPHICS.crt = self.old_crt 
        G.SETTINGS.GRAPHICS.bloom = self.old_bloom 
        G.SETTINGS.GRAPHICS.shadows = self.old_shadows 
        G.SETTINGS.WINDOW.vsync = self.old_vsync 
        G.SETTINGS.GAMESPEED = self.old_gamespeed 
        G.SETTINGS.SOUND.volume = self.old_volume 
        G.SETTINGS.SOUND.music_volume = self.old_music_volume 
        G.SETTINGS.SOUND.game_sounds_volume = self.old_game_sounds_volume 
    end,

    defeat = function(self)
        G.SETTINGS.colourblind_option = self.old_colourblind_option 
        G.SETTINGS.play_button_pos = self.old_play_button_pos 
        G.SETTINGS.screenshake = self.old_screenshake 
        G.SETTINGS.GRAPHICS.texture_scaling = self.old_texture_scaling 
        G.SETTINGS.GRAPHICS.crt = self.old_crt 
        G.SETTINGS.GRAPHICS.bloom = self.old_bloom 
        G.SETTINGS.GRAPHICS.shadows = self.old_shadows 
        G.SETTINGS.WINDOW.vsync = self.old_vsync 
        G.SETTINGS.GAMESPEED = self.old_gamespeed 
        G.SETTINGS.SOUND.volume = self.old_volume 
        G.SETTINGS.SOUND.music_volume = self.old_music_volume 
        G.SETTINGS.SOUND.game_sounds_volume = self.old_game_sounds_volume 
    end,
}

------------------------

SMODS.Sound({
    key = "music_onepiece", 
    path = "music_onepiece.ogg",
    pitch = 1,
    volume = 0.8,
    select_music_track = function()
        if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.name == 'boss_onepiece' then
		    return true end
	end,
})

SMODS.Blind {
    name = "boss_onepiece",
    key = "boss_onepiece",
    atlas = "starcoblinds",
    pos = { y = 5 },
    dollars = 10,
    loc_txt = {
        name = 'One Piece',
        text = {
            'Blind is paced like',
            'a One Piece episode',
        }
    },
    boss = {  min = 0 },
    boss_colour = HEX('ff0000'),

    set_blind = function(self, reset, silent)
        love.audio.stop()
    end,

    defeat = function(self)
        G.SETTINGS.GAMESPEED = G.GAME.normalgamespeed
        G.GAME.normalgamespeed = nil
    end,

    disable = function(self)
        G.SETTINGS.GAMESPEED = G.GAME.normalgamespeed
        G.GAME.normalgamespeed = nil
    end,
}


SMODS.Sound({key = "vineboom", path = "vineboom.ogg",})

SMODS.Blind {
    name = "boss_096",
    key = "boss_096",
    atlas = "starcoblinds",
    pos = { y = 8 },
    dollars = 5,
    loc_txt = {
        name = 'Four Fucking Pixels',
        text = {
            'Beat the blind in',
            'one hand, or else...'
        }
    },
    boss = {  min = 0 },
    boss_colour = HEX('808080'),
    mult = 2,
    set_blind = function(self, reset, silent)
        love.audio.stop()
    end,

    calculate = function(self,card,context)
        if context.final_scoring_step then
        --print("e")
            if G.GAME.chips + (hand_chips * mult) < G.GAME.blind.chips then
            G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("star_vineboom", 1, 0.7)
                        G.fourpixels = 600
                        if G.scptimer then G.scptimer = 90 end
                        return true
                    end
                }))
            end
        end
    end
}


function beatTheEverLovingShitOutOfAJoker()
    
    --print("sotrue")
    
    G.E_MANAGER:add_event(Event({
        trigger = "after", 
        delay = G.SETTINGS.GAMESPEED*0.1, 
        func = function() 
            
                        
                        G.GAME.blind:set_text()
                        G.GAME.blind:wiggle()
        play_sound("star_essenceofbrawling",1,2)
        local kuze = pseudorandom_element(G.jokers.cards, pseudoseed("DIE"))
        SMODS.calculate_effect({message = "oh no"}, kuze)
        G.E_MANAGER:add_event(Event({
        trigger = "after", 
        delay = G.SETTINGS.GAMESPEED*2.5, 
        func = function() 
            kuze:shatter()
                kuze = nil
        return true 
        end,
        blocking = true
        }))
        
    return true 
    end
    }))  
end

function sliceTheEverLovingShitOutOfYourHand()
    
    --print("sotrue")
    local redrawcount = 0
    G.E_MANAGER:add_event(Event({
        trigger = "before", 
        delay = G.SETTINGS.GAMESPEED*0.1, 
        func = function()                  
                        G.GAME.blind:set_text()
                        G.GAME.blind:wiggle()
        play_sound("star_heatactiontrigger",1,2)
        for i = 1, #G.hand.cards do
            local card = G.hand.cards[i]
            --print("sotrue2")
            redrawcount = redrawcount + 1
            G.E_MANAGER:add_event(Event {
                  trigger = "before",
                  delay = G.SETTINGS.GAMESPEED*0.03, 
                  func = function()
                        card:start_dissolve()
                        card = nil
                    return true
                  end,
            })
        end
        G.E_MANAGER:add_event(Event {
              
              func = function()
                    SMODS.draw_cards(1)
                return true
              end,
            })
    return true 
    end
    }))  
end

