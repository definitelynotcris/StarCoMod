--- STEAMODDED HEADER
--- MOD_NAME: StarCoMod
--- MOD_ID: StarCoMod
--- MOD_AUTHOR: [definitely not cris]
--- MOD_DESCRIPTION: gamign
--- PREFIX: star
----------------------------------------------
------------MOD CODE -------------------------

function getdate()
    local reference_time = os.time({year=2020, month=8, day=20, hour=0, min=0, sec=0})
    local current_time = os.time()
    local seconds_diff = os.difftime(current_time, reference_time)
    G.days = math.floor(seconds_diff / 86400)
    print(G.days)
    return G.days
end
getdate()

function playEffect(effect,posx,posy)
    if effect == "foxy" then
        --play_sound("star_jumpscare")
        neweffect = 
            {
            name = "foxy",
            duration = 36,

            frame = 1,
            maxframe = 14,
            fps = 36,
            tfps = 0, -- ticks per frame per second

            xpos = posx,
            ypos = posy,
            xvel = 0,
            yvel = 0,
            }end
    table.insert(G.effectmanager,{neweffect})
end



G.desctab = 0
function decrementingTickEvent(type,tick)
    if type == "G.scptimer" and math.fmod(StarCoMod.ticks,100) == 0 then --1/second, ignores gamespeed
        if G.scptimer >= 1 then
            G.scptimer = G.scptimer - 1 
        end
    end

    if type == "G.goldenfreddytimer" and math.fmod(StarCoMod.ticks,100) == 0 then --1/second, ignores gamespeed
        if G.goldenfreddytimer >= 1 then
            G.goldenfreddytimer = G.goldenfreddytimer - 1 
        end 
        if G.goldenfreddytimer == 0 then SMODS.restart_game() end
    end

    if type == "j_star_foxy" and math.fmod(StarCoMod.ticks,100) == 0 then --1/second, ignores gamespeed
        if SMODS.pseudorandom_probability(nil, 'seed', 1, 1000, 'identifier') then 
        play_sound("star_jumpscare", 1, 0.7)
        playEffect("foxy",0,0) 
        end
    end

    --event manager
    if type == "G.effectmanager" then
        for i = 1, #G.effectmanager do
            if G.effectmanager[i] and G.effectmanager[i][1] then
                if G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration >= -1 then
                    _eff = G.effectmanager[i][1]

                    _eff.tfps = _eff.tfps + 1
                    _eff.duration = _eff.duration - 1
                    
                    if _eff.tfps > 100/_eff.fps and _eff.fps ~= 0 then
                        _eff.frame = _eff.frame + 1
                        _eff.tfps = 0
                    end
                    if _eff.frame > _eff.maxframe then
                        _eff.frame = 1
                    end
                elseif G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration <= 0 then
                    G.effectmanager[i] = nil
                end
            end
        end
    end

end

local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    
    -- tick based events
    if StarCoMod.ticks == nil then StarCoMod.ticks = 0 end
    if StarCoMod.dtcounter == nil then StarCoMod.dtcounter = 0 end
    StarCoMod.dtcounter = StarCoMod.dtcounter+dt
    StarCoMod.dt = dt

    while StarCoMod.dtcounter >= 0.010 do
        StarCoMod.ticks = StarCoMod.ticks + 1
        StarCoMod.dtcounter = StarCoMod.dtcounter - 0.010

        if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.in_blind and G.GAME.blind.name == 'boss_onepiece' then
            G.SETTINGS.GAMESPEED = 0.5
            else
            if G.GAME.normalgamespeed == nil and G.SETTINGS.GAMESPEED ~= 0.5 then G.GAME.normalgamespeed = G.SETTINGS.GAMESPEED end
        end

        if G.tigerdropped and G.tigerdropped > 0 then 
            G.tigerdropped = G.tigerdropped - 1 
        end
        if G.boowomped and G.boowomped > 0 then 
            G.boowomped = G.boowomped - 1 
        end
        if G.fourpixels and G.fourpixels > 0 then 
            G.fourpixels = G.fourpixels - 1 
        end

        if G.STAGE == G.STAGES.RUN and G.scptimer and (G.scptimer > 0) then decrementingTickEvent("G.scptimer",0) end 

        if G.goldenfreddytimer and G.goldenfreddytimer > 0 then
            --print("was that the bite of 87: " .. G.goldenfreddytimer)
            decrementingTickEvent("G.goldenfreddytimer",0) 
        end 
        
        if G.scptimer ~= nil then 
            if G.lastante == nil then G.lastante = G.GAME.round_resets.ante end
            if G.lastante < G.GAME.round_resets.ante then
                G.scptimer = G.scptimer + 180
                G.lastante = G.GAME.round_resets.ante
            end
        end

        if G.scptimer == 0 then 
            G.STATE = G.STATES.GAME_OVER
            G.STATE_COMPLETE = false
            G.scptimer = nil
        end

        if G.GAME.round == 0 then G.scptimer = nil end

        if jokerExists("j_star_foxy") then decrementingTickEvent("j_star_foxy",0) end

        if #G.effectmanager > 0 then decrementingTickEvent("G.effectmanager",0) end

        
    end   
end

SMODS.Sound({key = "096scream", path = "096scream.ogg",})
local _modulate_sound = modulate_sound
function modulate_sound(dt)
    _modulate_sound(dt)
    G.ARGS.ambient_sounds.star_096scream = {
        volfunc = function(_prevvolume)
            if G.STAGE ~= G.STAGES.RUN then return 0 end
            if G.scptimer ~= nil and G.scptimer ~= 0 then 
            return ( (1/G.scptimer))
            else return 0 end
        end,
    }
end

local drawhook = love.draw
function love.draw()
    drawhook()

    function loadThatFuckingImage(fn)
        local full_path = (StarCoMod.path 
        .. "customimages/" .. fn)
        local file_data = assert(NFS.newFileData(full_path),("Epic fail"))
        local tempimagedata = assert(love.image.newImageData(file_data),("Epic fail 2"))
        --print ("LTFNI: Successfully loaded " .. fn)
        return (assert(love.graphics.newImage(tempimagedata),("Epic fail 3")))
    end

    function loadThatFuckingImageSpritesheet(fn,px,py,subimg,orientation)
        local full_path = (StarCoMod.path 
        .. "customimages/" .. fn)
        local file_data = assert(NFS.newFileData(full_path),("Epic fail"))
        local tempimagedata = assert(love.image.newImageData(file_data),("Epic fail 2"))

        local tempimg = assert(love.graphics.newImage(tempimagedata),("Epic fail 3"))

        local spritesheet = {}
        for i = 1, subimg do
            if orientation == 0 then -- 0 = downwards spritesheet
                table.insert(spritesheet,love.graphics.newQuad(0, (i-1)*py, px, py, tempimg))
            end
            if orientation == 1 then -- 1 = rightwards spritesheet
                table.insert(spritesheet,love.graphics.newQuad((i-1)*px, 0, px, py, tempimg))
            end
        end
        --print ("LTFNIS: Successfully loaded spritesheet " .. fn)

        return (spritesheet)
    end

    local _xscale = love.graphics.getWidth() / 1920
    local _yscale = love.graphics.getHeight() / 1080

    -- tiger dropped
    if G.tigerdropped and (G.tigerdropped > 0) then
        if StarCoMod.kiryuflashbang == nil then StarCoMod.kiryuflashbang = loadThatFuckingImage("tigerdropped.png") end
        local alpha = math.min(1, G.tigerdropped / 100)
        love.graphics.setColor(1, 1, 1, alpha) 
        love.graphics.draw(StarCoMod.kiryuflashbang, 0, 0, 0, _xscale, _yscale)
    end

    --boowomped
    if G.boowomped and (G.boowomped > 0) then
        if StarCoMod.kiryusad == nil then StarCoMod.kiryusad = loadThatFuckingImage("boowomped.png") end
        local alpha = math.min(1, G.boowomped / 100)
        love.graphics.setColor(1, 1, 1, alpha) 
        love.graphics.draw(StarCoMod.kiryusad, 0, 0, 0, _xscale, _yscale)
    end

    --096'ed
    if G.fourpixels and (G.fourpixels > 0) then
        if StarCoMod.fourfuckingpixels == nil then StarCoMod.fourfuckingpixels = loadThatFuckingImage("fourfuckingpixels.png") end
        local alpha = math.min(1, G.fourpixels / 500)
        love.graphics.setColor(1, 1, 1, alpha) 
        love.graphics.draw(StarCoMod.fourfuckingpixels, 0, 0, 0, _xscale, _yscale)
    end

    --golden freddy'd
    if G.goldenfreddytimer then
        if StarCoMod.gfred == nil then StarCoMod.gfred = loadThatFuckingImage("goldenfreddy.png") end
        local alpha = 1
        love.graphics.setColor(1, 1, 1, alpha) 
        love.graphics.draw(StarCoMod.gfred, 0, 0, 0, _xscale, _yscale)
    end
    
    if G.effectmanager then
        --print("Effect manager has "..#G.effectmanager)
        for i = 1, #G.effectmanager do
            local _xscale = love.graphics.getWidth()/1920
            local _yscale = love.graphics.getHeight()/1080
            if G.effectmanager[i] ~= nil then
                --foxy jumpscare--
                if G.effectmanager[i][1].name == "foxy" then
                    if StarCoMod.imagecrack == nil then StarCoMod.imagecrack = loadThatFuckingImage("foxy.png") end 
                    if StarCoMod.imagecracksprite == nil then StarCoMod.imagecracksprite = loadThatFuckingImageSpritesheet("foxy.png",1024,768,14,0) end
                    imagetodraw = StarCoMod.imagecrack
                    quadtodraw = StarCoMod.imagecracksprite
                    _imgindex = G.effectmanager[i][1].frame
                    --print("_imgindex".. _imgindex)
                    _xpos = G.effectmanager[i][1].xpos
                    _ypos = G.effectmanager[i][1].ypos
                    _xscale = _xscale * 1.875
                    _yscale = _yscale * 1.875
                    love.graphics.setColor(1, 1, 1, 1)
                end
                --foxy jumpscare--
                love.graphics.draw(imagetodraw, quadtodraw[_imgindex], _xpos, _ypos, 0 ,_xscale,_yscale)
            end
        end
    end
end


--for cycling leisault description
local starcomodkey = love.keypressed
function love.keypressed(key)
    if key == "c" then
        --print(G.desctab)
        G.desctab = G.desctab + 1        
    end
    if key == "f5" then SMODS.restart_game() end
    return starcomodkey(key)
end


------------BOLT------------
SMODS.Atlas{
    key = 'bolt', --atlas key
    path = 'bolt.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'bolt', --joker key
    loc_txt = { -- local text
        name = 'Bolt',
        text = {
          "Each {C:attention}Stone Card{}",
          "held in hand",
          "gives {X:mult,C:white} X#1# {} Mult",
        },
    },
        config = {
        extra = {
            Xmult = 2
            }
        },

    atlas = 'bolt',
    pos = {x = 0, y = 0},

    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,

    calculate = function(self,card,context)
        if context.cardarea == G.hand and context.individual and not context.end_of_round and context.other_card.ability.name == 'Stone Card' then
            delay(0.15)
                return {
                    Xmult_mod = card.ability.extra.Xmult,
                    message = "X" .. card.ability.extra.Xmult .. " Mult",
                    card = context.other_card
                    
                }
        end
    end
}
------------BOLT------------

------------SANTA------------
SMODS.Atlas{
    key = 'santa', --atlas key
    path = 'bolt.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'santa', --joker key
    loc_txt = { -- local text
        name = 'Santalouis',
        text = {
          "{C:red}+#1#{} Mult and {C:blue}+#2#{} Chips",
          "if played hand contains",
          "two {C:attention}Queens{}"
        },
    },
        config = {
        extra = {
            mult = 9, 
            chips = 21
            }
        },

    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, center.ability.extra.chips }  }
	end,

    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.joker_main then
            if calculate_queen_amount() >= 2 then
                delay(0.15)
                return{
                    message = "+".. card.ability.extra.mult .. " Mult",
                    message = "+".. card.ability.extra.chips .. " Chips",
                    chip_mod = card.ability.extra.chips,
                    mult_mod = card.ability.extra.mult,
                }
            end
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}

------------SANTA------------
  
------------fuckass starscape player stations joker----------
getdate()

SMODS.Atlas{
    key = 'ZolarKeth', --atlas key
    path = 'ZolarKeth.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'ZolarKeth', --joker key
    loc_txt = { -- local text
        name = 'ZolarKeth',
        text = {
          "{C:blue}+#1#{} Chips for every",
          "{C:attention}10 days{} since Keth",
          "started working on",
          "{C:attention}player stations{}",
          "{C:inactive}(Currently {C:blue}+#2#{} {C:inactive}Chips)"
        },
    },
        config = {
        extra = {
            tendays = 1,
            decadays = G.days / 10
            }
        },
            
    atlas = 'ZolarKeth',
    pos = {x = 0, y = 0},

    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
		return { vars = {center.ability.extra.tendays, center.ability.extra.decadays }  }
	end,

    calculate = function(self,card,context)
     
        card.ability.extra.decadays = math.floor(G.days / 10)
        if context.cardarea == G.jokers and context.joker_main then
                return{
                   
                    message = "+".. card.ability.extra.decadays .. " Chips",
                    chip_mod = card.ability.extra.decadays,
                }
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}


------------fuckass starscape player stations joker----------

------------togif------------
SMODS.Atlas{
    key = 'togif', --atlas key
    path = 'togif.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'togif',
        loc_txt = { -- local text
        name = 'togif',
        text = {
          "Retriggers the {C:attention}Joker{}",
          "to the right,",
          "{C:green}#1# in #2#{} chance to",
          "retrigger the",
          "{C:attention}Joker{} to the right",
          "up to {C:attention}4{} additional times"
        },
    },
    config = { extra = { mainodds = 1, totalodds = 2, bptarget = 0 } },

    loc_vars = function(self, info_queue, center)
        local numerator, denominator = SMODS.get_probability_vars(card, center.ability.extra.mainodds, center.ability.extra.totalodds, 'togif')    
        return {vars = {numerator, denominator}}
	end,

    atlas = 'togif',
    pos = {x = 0, y = 0},

    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    update = function(self, card, front)
        local _myid = getJokerID(card)
        if G.jokers and G.jokers.cards[_myid + 1] then card.ability.extra.bptarget = G.jokers.cards[_myid + 1] end
    end,

    calculate = function(self, card, context)
        local _myid = getJokerID(card)
        
        --end

        --and not context.retrigger_joker--
        --and context.retrigger_check--

        if context.retrigger_joker then 
        --print(winstreak)
            return{
                repetitions = winstreak,
                retrigger_joker = retrigger_card
            }
        end

        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
            --print("retrigger")
            if context.other_card == G.jokers.cards[getJokerID(card) + 1] then
            local winstreak = 1
            if SMODS.pseudorandom_probability(card, 'togif', card.ability.extra.mainodds, card.ability.extra.totalodds, 'togif') then
                winstreak = 2
                if SMODS.pseudorandom_probability(card, 'togif', card.ability.extra.mainodds, card.ability.extra.totalodds, 'togif') then
                    winstreak = 3
                    if SMODS.pseudorandom_probability(card, 'togif', card.ability.extra.mainodds, card.ability.extra.totalodds, 'togif') then
                        winstreak = 4
                        if SMODS.pseudorandom_probability(card, 'togif', card.ability.extra.mainodds, card.ability.extra.totalodds, 'togif') then
                            winstreak = 5
                        --putting any sort of while loop in here just makes the game LAG (not crash) so uh lol lmao
                        end
                    end
                end         
            else 
               
                winstreak = 1
            end
            --print(winstreak)
                if context.other_card.bptarget and context.other_card.bptarget ~= 0 then
                    return {
                        message = ":togif:",
                        repetitions = winstreak,
                        card = context.other_card.bptarget,
                    }
                else
                    return {
                        message = ":togif:",
                        repetitions = winstreak,
                        --card = card,
                    }
                end
            else
                return nil, true 
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}


------------Potential Joker------------
SMODS.Atlas{
    key = 'potentialman', --atlas key
    path = 'potentialman.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'potentialman', --joker key
    loc_txt = { -- local text
        name = 'Potential Joker',
        text = {
          "Halves all {C:attention}listed{}",
          "{C:green,E:1}probabilities{}",
          "{C:inactive}(ex: {}{C:green}2 in 3{}{C:inactive} -> {}{C:green}1 in 3{}{C:inactive})",
        },
    },
        config = {
        extra = {
            oddsmodifier = 0.5,
            temp = 0,
            }
        },

    atlas = 'potentialman',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },

    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.oddsmodifier}}
    end,


    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                denominator = context.denominator / card.ability.extra.oddsmodifier
            }
        end
    end,

        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Potential Joker------------

------------Emuz Planet 4------------
SMODS.Atlas{
    key = 'emuz', --atlas key
    path = 'emuz.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'emuz', --joker key
    loc_txt = { -- local text
        name = 'Emuz Planet 4',
        text = {
          "{C:attention}+#1#{} hand size,",
          "{C:attention}+#2#{} consumable slots",
          "{C:money}$#3#{} rent at round start"
          
        },
    },
        config = {
        extra = {
            handsize = 2,
            consumableslots = 2,
            rent = 3,
            }
        },

    atlas = 'emuz',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },

    cost = 1,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.handsize, center.ability.extra.consumableslots, center.ability.extra.rent}}
    end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.handsize * 1)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumableslots
        
        --9/11 check
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == 'j_star_horizon' then
                old_music_volume = G.SETTINGS.SOUND.music_volume
                --print(old_music_volume)
                G.SETTINGS.SOUND.music_volume = 0
                        G.FUNCS.overlay_menu{
                            definition = create_UIBox_custom_video1("ripemuz","never forget."),
                            config = {no_esc = true}
                        }
                destroyCard(G.jokers.cards[i])
                destroyCard(card)
                G.E_MANAGER:add_event(Event {
                  trigger = "after",
                  delay = 28, 
                  func = function()
                        G.SETTINGS.SOUND.music_volume = old_music_volume
                    return true
                  end,
                })
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.handsize * -1)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumableslots
	end,

    calculate = function(self, card, context)
        if context.setting_blind then
            if G.GAME.dollars < 3 then 
            return{
                message = "No rent!",
                card:start_dissolve(),
                card = nil
                }
            end
            play_sound('chips2')    
            return {
                    dollars = (card.ability.extra.rent * -1),
                }
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}

------------Emuz Planet 4------------

------------Horizon------------
SMODS.Atlas{
    key = 'horizon', --atlas key
    path = 'horizon.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'horizon', --joker key
    loc_txt = { -- local text
        name = 'Horizon',
        text = {
                "{X:mult,C:white}X#1#{} Mult after warping in",
                "{C:inactive}(Warps in after {}{C:red}(#3#/#2#){}{C:inactive} hands){}"
        },
    },
        config = {
        extra = {
            xmult = 1.5,
            warptime = 1,
            warpcount = 1,
            }
        },

    atlas = 'horizon',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },
    pools = {["starscape"] = true},

    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult, center.ability.extra.warptime, center.ability.extra.warpcount}}
    end,

    add_to_deck = function(self, card, from_debuff)
        --9/11 check
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == 'j_star_emuz' then
                old_music_volume = G.SETTINGS.SOUND.music_volume
                --print(old_music_volume)
                G.SETTINGS.SOUND.music_volume = 0
                        G.FUNCS.overlay_menu{
                            definition = create_UIBox_custom_video1("ripemuz","THEY HIT TOWER B"),
                            config = {no_esc = true}
                        }
                G.E_MANAGER:add_event(Event {
                  trigger = "after",
                  delay = 28, 
                  func = function()
                        G.SETTINGS.SOUND.music_volume = old_music_volume
                    return true
                  end,
                })
                destroyCard(G.jokers.cards[i])
                destroyCard(card)
            end
        end
    end,

    calculate = function(self, card, context)
        --reset warp at start of blind
        if context.end_of_round then  
            card.ability.extra.warpcount = card.ability.extra.warptime
  
        end

        --shit to do when its in
        if context.joker_main and card.ability.extra.warpcount == 0 then
            return{
                card = card,
                Xmult_mod = card.ability.extra.xmult,
                message = 'X' .. card.ability.extra.xmult .. ' Mult',
                colour = G.C.MULT
                }    
        end

        --charge warp
        if context.after and card.ability.extra.warpcount > 0 and not context.blueprint and not context.retrigger_joker then
            
            if card.ability.extra.warpcount == 1 then
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Ready!"}, card)

            elseif card.ability.extra.warpcount == 2 then 
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Warping!"}, card)

            else
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Charging!"}, card)
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Horizon------------

------------Edict------------
SMODS.Atlas{
    key = 'edict', --atlas key
    path = 'edict.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'edict', --joker key
    loc_txt = { -- local text
        name = 'Edict',
        text = {
                "When out of hands,",
                "{C:red}destroy{} all held",
                "{C:attention}consumables{} and convert",
                "them into more hands",
                "{C:inactive}(Warps in after {}{C:red}(#3#/#2#){}{C:inactive} hands){}"
        },
    },
        config = {
        extra = {
            xmult = 1.5,
            warptime = 2,
            warpcount = 2,
            }
        },

    atlas = 'edict',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },
    pools = {["starscape"] = true},

    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult, center.ability.extra.warptime, center.ability.extra.warpcount}}
    end,

    calculate = function(self, card, context)
        --reset warp at start of blind
        if context.end_of_round then  
            card.ability.extra.warpcount = card.ability.extra.warptime
        end

        --shit to do when its in
        if context.final_scoring_step and card.ability.extra.warpcount == 0 then
            if G.GAME.current_round.hands_left == 0 and G.GAME.chips < G.GAME.blind.chips then
                for i = 1, #G.consumeables.cards do 
                    destroyCard(G.consumeables.cards[i])
                    G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
                end
                SMODS.calculate_effect({message = "Tackled!"}, card)
            end
        end

        --charge warp
        if context.after and card.ability.extra.warpcount > 0 and not context.blueprint and not context.retrigger_joker then
            
            if card.ability.extra.warpcount == 1 then
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Ready!"}, card)

            elseif card.ability.extra.warpcount == 2 then 
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Warping!"}, card)

            else
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Charging!"}, card)
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Edict------------

------------Yukon------------
SMODS.Atlas{
    key = 'yukon', --atlas key
    path = 'yukon.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'yukon', --joker key
    loc_txt = { -- local text
        name = 'Yukon',
        text = {
                "Destroy all cards in the {C:attention}next discard{}",
                "{C:inactive}(Warps in after {}{C:red}(#3#/#2#){}{C:inactive} hands){}"
        },
    },
        config = {
        extra = {
            triggered = false,
            warptime = 4,
            warpcount = 4,
            }
        },

    atlas = 'yukon',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },
    pools = {["starscape"] = true},

    cost = 3,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.triggered, center.ability.extra.warptime, center.ability.extra.warpcount}}
    end,

    calculate = function(self, card, context)
        --reset warp at start of blind
        if context.end_of_round then  
            card.ability.extra.warpcount = card.ability.extra.warptime
        end

        --shit to do when its in
            if context.discard and card.ability.extra.warpcount == 0 and card.ability.extra.triggered == false then
                for i = 1, #G.hand.highlighted do 
                    destroyCard(G.hand.highlighted[i])
                end
                card.ability.extra.triggered = true
            end

        --charge warp
        if context.after and card.ability.extra.warpcount > 0 and not context.blueprint and not context.retrigger_joker then
            
            if card.ability.extra.warpcount == 1 then
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Ready!"}, card)

            elseif card.ability.extra.warpcount == 2 then 
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Warping!"}, card)

            else
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Charging!"}, card)
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Yukon------------

------------Knifejaw------------
SMODS.Atlas{
    key = 'knifejaw', --atlas key
    path = 'knifejaw.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'knifejaw', --joker key
    loc_txt = { -- local text
        name = 'Knifejaw',
        text = {
                "{X:mult,C:white}X#1#{} Mult after warping in",
                "Can't be {C:attention}debuffed!{}",
                "{C:inactive}(Warps in after {}{C:red}(#3#/#2#){}{C:inactive} hands){}"
        },
    },
        config = {
        extra = {
            xmult = 2.5,
            warptime = 2,
            warpcount = 2,
            }
        },

    atlas = 'knifejaw',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },
    pools = {["starscape"] = true},

    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult, center.ability.extra.warptime, center.ability.extra.warpcount}}
    end,

    

    calculate = function(self, card, context)
        SMODS.debuff_card(card, 'prevent_debuff', card)
        --reset warp at start of blind
        if context.end_of_round then  
            card.ability.extra.warpcount = card.ability.extra.warptime
        end

        --shit to do when its in
        if context.joker_main and card.ability.extra.warpcount == 0 then
            return{
                card = card,
                Xmult_mod = card.ability.extra.xmult,
                message = 'X' .. card.ability.extra.xmult .. ' Mult',
                colour = G.C.MULT
                }    
        end

        --charge warp
        if context.after and card.ability.extra.warpcount > 0 and not context.blueprint and not context.retrigger_joker then
            
            if card.ability.extra.warpcount == 1 then
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Ready!"}, card)

            elseif card.ability.extra.warpcount == 2 then 
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Warping!"}, card)

            else
            card.ability.extra.warpcount = card.ability.extra.warpcount - 1
            SMODS.calculate_effect({message = "Charging!"}, card)
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Knifejaw------------

------------Reroll Button------------
SMODS.Atlas{
    key = 'reroll', --atlas key
    path = 'reroll.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'reroll', --joker key
    loc_txt = { -- local text
        name = 'Reroll Button',
        text = {
          "All cards and packs",
          "in shop are {C:attention}75% off",
          "{C:red,E:2}No rerolls{}" 
        },
    },
        config = {
        extra = {
            discount = 75,
            }
        },

    atlas = 'reroll',
    pos = {x=0, y= 0},

    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.discount}}
    end,
    
    calculate = function(self, card, context)
        --print(G.GAME.discount_percent)
        if context.cardarea ~= G.play then
        if self.add_to_deck then
            G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = card.ability.extra.discount
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
        elseif self.remove_from_deck then
        refresh_discounts()
            G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
        end
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        self.added_to_deck = true
        if G.GAME.discount_percent < 75 then
            --G.shop.children[1].children[1].children[1](etc):remove()
            G.GAME.rerollbuttonlock = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.discount_percent = card.ability.extra.discount
                    for _, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                    return true
                end
            }))
        end
    end,

    --TODO: selling reroll button removes the discounts from vouchers if you have them
    remove_from_deck = function(self, card, from_debuff)
        self.added_to_deck = false
        refresh_discounts()
            G.GAME.rerollbuttonlock = false
            G.E_MANAGER:add_event(Event({
                func = function()
                
                    --check for sale vouchers
                    for _, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                    return true
                end
            }))
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}
------------Reroll Button------------

------------Random Crit------------
SMODS.Sound({key = "jokercrit", path = "jokercrit.ogg",})

SMODS.Atlas{
    key = 'randomcrits', --atlas key
    path = 'randomcrits.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'randomcrits', --joker key
    loc_txt = { -- local text
        name = 'Random Crit',
        text = {
          "{C:green}#1# in #2#{} chance",
          "to give {X:mult,C:white} X#3# {} Mult,",
          "chance increases by",
          "{C:attention}#4#{} per hand played",
        },
    },
        config = {
        extra = {
            mainodds = 1,
            totalodds = 50,
            xmult = 3,
            increment = 1,
            }
        },

    atlas = 'randomcrits',
    pos = {x=0, y= 0},

    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)
        local numerator, denominator = SMODS.get_probability_vars(card, center.ability.extra.mainodds, center.ability.extra.totalodds, 'randomcrit')    
        return {vars = {numerator, denominator, center.ability.extra.xmult, center.ability.extra.increment}}
    end,

    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.joker_main then
            if SMODS.pseudorandom_probability(card, 'randomcrit', card.ability.extra.mainodds, card.ability.extra.totalodds, 'randomcrit') then
            SMODS.calculate_effect({message = "CRIT!", colour = G.C.GREEN, sound = 'star_jokercrit', pitch = 1, volume = 0.7,}, card)
            return{
                card = card,
                message = 'X' .. card.ability.extra.xmult .. ' Mult',
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.MULT
            }    
            end
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.mainodds < 50 then
            card.ability.extra.mainodds = card.ability.extra.mainodds + 1
            return{
                card = card,
                message = card.ability.extra.mainodds .. '/' ..card.ability.extra.totalodds,
                colour = G.C.GREEN
            }
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}

------------Random Crit------------

------------The Thirteenth Toll------------
SMODS.Sound({key = "tolls", path = "tolls.ogg",})

SMODS.Atlas{
    key = 'toll', --atlas key
    path = 'toll.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'toll', --joker key
    loc_txt = { -- local text
        name = 'The Thirteenth Toll',
        text = {
          "Played cards give {X:mult,C:white}X#1#{} Mult ",
          "when scored, after {C:attention}13{} cards",
          "have been scored",
        },
    },
        config = {
        extra = {
            xmult = 13,
            count = 0,
            }
        },

    atlas = 'toll',
    pos = {x=0, y= 0},

    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult, center.ability.extra.count }  }
	end,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.count = 0
        end
        if context.individual and context.cardarea == G.play then
            if not context.blueprint then
                card.ability.extra.count = card.ability.extra.count + 1
            end
            if card.ability.extra.count >= 13 then
            SMODS.calculate_effect({message = card.ability.extra.count .. "!", colour = G.C.GREEN, sound = 'star_tolls', pitch = 1, volume = 0.7,}, card)
            return{
                card = card,
                message = 'X' .. card.ability.extra.xmult .. ' Mult',
                xmult = card.ability.extra.xmult,
                colour = G.C.MULT
            }    
            elseif not context.blueprint then
            SMODS.calculate_effect({message = card.ability.extra.count .. "...", colour = G.C.SUITS.Clubs, }, card)
            end
        end
        
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}

------------The Thirteenth Toll------------

------------fucking stupid calculator------------
SMODS.Sound({key = "calculator", path = "calculator.ogg",})

SMODS.Atlas{
    key = 'calc', --atlas key
    path = 'calculator.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'calc', --joker key
    loc_txt = { -- local text
        name = 'Calculator',
        text = {
          "{C:red}+#2#{} Mult",
          "{C:red}-#2#{} Mult"
        },
    },
        config = {
        extra = {
            mult = 8, 
            fakemult = 10000,
            activated = 0,
            }
        },
    atlas = 'calc',
    pos = {x=0, y= 0},
    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.mult, center.ability.extra.fakemult, center.ability.extra.activated }  }
    end,

    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.joker_main then
        
            if card.ability.extra.activated == 0 then
                card.ability.extra.activated = 1
                
                return {
                  sound = "star_calculator",
                  --pitch = 1,
                  volume = 2,
                  message = '+' .. card.ability.extra.fakemult .. ' Mult',
                  mult_mod = 10000,
                  delay = 1.5 * G.SETTINGS.GAMESPEED,
                  extra = {
                      message = '-' .. card.ability.extra.fakemult .. ' Mult',
                      mult_mod = -10000,
                      delay = 1.5 * G.SETTINGS.GAMESPEED,
                      extra = {
                          message = '+' .. card.ability.extra.mult .. ' Mult',
                          mult_mod = card.ability.extra.mult,
                          delay = 1 * G.SETTINGS.GAMESPEED
                      }
                    }
                  }
            else 
                return{
                    message = '+' .. card.ability.extra.mult .. ' Mult',
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}

------------fucking stupid calculator------------

------------weed soldier------------
SMODS.Atlas{
    key = 'weedsoldier', --atlas key
    path = 'weedsoldier.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker {
    key = 'weedsoldier', --joker key
    loc_txt = { -- local text
        name = 'Weed Soldier',
        text = {
          "All played {C:attention}face{} cards",
          "become {C:attention}stone{} cards",
          "when scored"
        },
    },
        config = {
        extra = {

            }
        },
    atlas = 'weedsoldier', --MAKE IT WEED SOLDIER
    blueprint_compat = false,
    rarity = 2,
    cost = 5,
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() and not scored_card.debuff then
                    faces = faces + 1
                    scored_card:set_ability('m_stone', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = 'Stoned!',
                    colour = G.C.GREEN
                }
            end
        end
    end,
        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}

------------weed soldier------------

------------Furnace------------
SMODS.Atlas{
    key = 'furnace', --atlas key
    path = 'furnace.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker {
    key = 'furnace', --joker key
    loc_txt = { -- local text
        name = 'Furnace',
        text = {
          "All played {C:attention}stone{} cards",
          "become {C:attention}glass{} cards",
          "when scored"
        },
    },
        config = {
        extra = {

            }
        },
    atlas = 'furnace',
    blueprint_compat = false,
    rarity = 2,
    cost = 5,
    pos = { x = 0, y = 0 },
    pixel_size = { w = 71, h = 71 },
    display_size = {w = 71*1, h = 71*1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local stones = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(scored_card, "m_stone") and not scored_card.debuff then
                    stones = stones + 1
                    scored_card:set_ability('m_glass', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if stones > 0 then
                return {
                    message = 'Smelted!'
                }
            end
        end
    end,

        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}

------------Furnace------------

------------Table------------

SMODS.Sound({key = "itsbroken", path = "itsbroken.ogg",})

SMODS.Atlas{
    key = 'table', --atlas key
    path = 'table.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker {
    key = 'table', 
    loc_txt = { 
        name = 'Table',
        text = {
          "Retriggers played {C:attention}Glass Cards{}",
          "{C:green}#1# in #2#{} chance to", --1 in 8 chance
          "{C:red}break{} all played {C:attention}Glass Cards{}"
        },
    },
        config = {
        extra = {
            mainodds = 1,
            totalodds = 8,
            repetitions = 1,
            }
        },
    atlas = 'table',
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.mainodds, card.ability.extra.totalodds, 'table')    
        return {vars = {numerator, denominator, card.ability.extra.repetitions}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then --and not context.repetition_only then
          
          if context.other_card.config.center == G.P_CENTERS.m_glass  then
            
            return {
                
              --message = 'Again!',
              repetitions = card.ability.extra.repetitions,
              --card =  context.blueprint_card or card
            }
          end
        end

        if context.final_scoring_step  then
            --print('rolling')
            if SMODS.pseudorandom_probability(card, 'table', card.ability.extra.mainodds, card.ability.extra.totalodds, 'table') then
            --print ("ourtable")
            --play_sound('star_jokercrit')  
                G.E_MANAGER:add_event(Event {
                  trigger = "after",
                  delay = 0, 
                  func = function()
                        play_sound("star_itsbroken")
                        for _, scored_card in ipairs(context.scoring_hand) do
                            if scored_card.config.center == G.P_CENTERS.m_glass then
                                scored_card:shatter() --Destroy the card
                            end
                        end
                    return true
                  end,
                })
                
            end
        end
    end,

        check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Table------------

------------Tiger Drop------------
SMODS.Sound({key = "dayum", path = "dayum.ogg",})
SMODS.Sound({key = "boowomp", path = "boowomp.ogg",})

SMODS.Atlas{
    key = 'tigerdrop', --atlas key
    path = 'tigerdrop.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'tigerdrop', --joker key
    loc_txt = { -- local text
        name = 'Tiger Drop',
        text = {
          "This Joker gains {X:mult,C:white} X#2# {} Mult per",
          "{C:attention}consecutive{} hand played if it",
          "is your most played {C:attention}poker hand",
          "{C:inactive}(Currently{} {X:mult,C:white} X#1# {} {C:inactive}Mult){}",
          
        },
    },
        config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 0.1,
            }
        },

    atlas = 'tigerdrop',
    pos = {x=0, y= 0},

    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.Xmult, center.ability.extra.Xmult_gain }  }
	end,
    --this is literally just VanillaRemades obelisk but fucked up and evil
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local reset = false
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for handname, values in pairs(G.GAME.hands) do
                if handname ~= context.scoring_name and values.played >= play_more_than and SMODS.is_poker_hand_visible(handname) then
                    reset = true
                    break
                end
            end
            if reset then
                if card.ability.extra.Xmult > 1 then
                    card.ability.extra.Xmult = 1
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            end
        end 
        if context.cardarea == G.jokers and context.joker_main then
        
            return {
                Xmult_mod = card.ability.extra.Xmult
            }
        end
        if context.post_trigger and context.other_card == card then
            if card.ability.extra.Xmult > 1 then
            G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("star_dayum", 1, 0.7)
                        G.tigerdropped = 120
                        return true
                    end
                }))
            else 
            G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("star_boowomp", 1, 0.7)
                        G.boowomped = 120
                        return true
                    end
                }))
            end
        end

    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}

------------Tiger Drop------------

------------Fell For It Again Award------------

SMODS.Atlas{
    key = 'award', --atlas key
    path = 'fellforitagain.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'award', --joker key
    loc_txt = { -- local text
        name = 'Fell For it Again Award',
        text = {
          "This Joker gains {X:mult,C:white} X#2# {} Mult",
          "when failing a {C:attention}Wheel of Fortune{}",
          "{C:inactive}(Currently{} {X:mult,C:white} X#1# {} {C:inactive}Mult){}",
        },
    },
        config = {
        extra = {
            xmult = 1,
            Xmult_gain = 0.25,
            }
        },

    atlas = 'award',
    pos = {x=0, y= 0},

    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)
        local numerator, denominator = SMODS.get_probability_vars(nil, 1, 4, "wheel_of_fortune")
		--info_queue[#info_queue + 1] = { key = "wheel_of_fortune", set = "Other", specific_vars = { numerator, denominator } }
		return { vars = { center.ability.extra.xmult, center.ability.extra.Xmult_gain }  }
	end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return{ 
                card = card,
                Xmult_mod = card.ability.extra.xmult,
                message = 'X' .. card.ability.extra.xmult .. ' Mult',
                colour = G.C.MULT
            }  
		end
		if context.pseudorandom_result and not context.result then
			if context.identifier and context.identifier == "wheel_of_fortune" then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_value = "Xmult_gain",
					scaling_message = {
	                    message = "Fell for it again!",
	                    colour = G.C.RED
                    }
				})
				return nil, true
			end
		end
        if context.forcetrigger then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "xmult",
				scalar_value = "extra",
				message_key = "a_xmult",
				message_colour = G.C.RED,
			})
		end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}

------------Fell For It Again Award------------

------------Not Reading Allat------------
SMODS.Sound({key = "coinheads", path = "coinheads.wav",})
SMODS.Sound({key = "cointails", path = "cointails.wav",})
SMODS.Sound({key = "tremorburst", path = "tremorburst.ogg",})

SMODS.Atlas{
    key = 'notreadingallat', --atlas key
    path = 'leisault.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'notreadingallat', --joker key
    loc_txt = { -- local text
        name = 'Not Reading Allat',
        text = {
        },
    },
        config = {
        extra = {
            mainodds = 50,              --1
            totalodds = 100,
            sanity = 0,
            startingammo = 12,
            ammo = 12,                  --5
            specialammo = 0,            
            unrelenting = 0,
            unrelentingshin = 0,
            overheat = 0,
            tremor = 0,                 --10
            tremorcount = 0,
            burn = 0,       
            burncount = 0,
            skill = 0,
            power = 0,
            coinpower = 0,
            ammospent = 0,
            tremortype = 0, --  0 for base, 1 for scorch
            triggered = false,
            }
        },

    atlas = 'notreadingallat',
    pos = {x=0, y= 0},
    soul_pos = { x = 0, y = 1 },

    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, center)

        local numerator, denominator = SMODS.get_probability_vars(card, center.ability.extra.mainodds, center.ability.extra.totalodds, 'randomcrit')    

        return {
                    key = ( "j_star_notreadingallat_" .. G.desctab % 7),
                    vars = {numerator, denominator, center.ability.extra.sanity, 
                        center.ability.extra.startingammo, center.ability.extra.ammo, 
                        center.ability.extra.specialammo, center.ability.extra.unrelenting,
                        center.ability.extra.unrelentingshin, center.ability.extra.overheat,
                        center.ability.extra.tremor, center.ability.extra.tremorcount,
                        center.ability.extra.burn, center.ability.extra.burncount,
                        center.ability.extra.skill, center.ability.extra.power,
                        center.ability.extra.coinpower, center.ability.extra.triggered,
                        center.ability.extra.ammospent, center.ability.extra.tremortype,
                        colours = { HEX('8A3808'), HEX('80C9FF'), HEX('8EE63D'), HEX('E20000'), }        
                }}
	end,

    calculate = function(self, card, context)
        if context.end_of_round and (G.GAME.blind:get_type() == 'Boss') then --resetting things at start of ante
            if card.ability.extra.ammospent > 0 then SMODS.calculate_effect({message = localize('k_reset')}, card) end
            --print("resetting")
            card.ability.extra.ammo = card.ability.extra.startingammo  
            card.ability.extra.specialammo = 0            
            card.ability.extra.unrelenting = 0
            card.ability.extra.unrelentingshin = 0
            card.ability.extra.overheat = 0 
            card.ability.extra.tremor = 0 
            card.ability.extra.tremorcount = 0
            card.ability.extra.burn = 0  
            card.ability.extra.burncount = 0
            card.ability.extra.ammospent = 0
            card.ability.extra.tremortype = 0
        end

        --pick skills here
        if context.individual and context.cardarea == G.play and card.ability.extra.triggered == false then
            card.ability.extra.triggered = true
            card.ability.extra.skill = (math.random(1, 3))
            if card.ability.extra.skill == 1 then --double slash-----------------
                SMODS.calculate_effect({message = "Double Slash - Blast"}, card)
                
                local bonus = math.floor((card.ability.extra.burn + card.ability.extra.tremor) / 4) --final power bonus
                if bonus > 3 then bonus = 3 end
                card.ability.extra.power = 4 + bonus
                card.ability.extra.coinpower = 4

                --COIN 1--
                rollCoin(card, 1)
                --inflict 1 tremor
                applyTremor(card,1,0)
                if card.ability.extra.unrelenting == 1 then applyTremor(card,1,0) end
                if card.ability.extra.unrelentingshin == 1 then applyTremor(card,2,0) end
                --COIN 2--    
                if card.ability.extra.ammo > 0 then rollCoin(card, 1.1, 1)
                elseif card.ability.extra.specialammo > 0 then rollCoin(card,1.3,2)
                else rollCoin(card,1) end
                --spend round to inflict 2 tremor and 2 burn
                applyTremor(card,2,0)
                if card.ability.extra.unrelenting == 1 then applyTremor(card,1,0) end
                if card.ability.extra.unrelentingshin == 1 then applyTremor(card,2,0) end
                if card.ability.extra.ammo > 0 then
                    card.ability.extra.ammo = card.ability.extra.ammo - 1
                    card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                    applyBurn(card,2,0)
                elseif card.ability.extra.specialammo > 0 then
                    card.ability.extra.specialammo = card.ability.extra.specialammo - 1
                    card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                    applyBurn(card,2,0)
                    if card.ability.extra.specialammo > 0 then applyBurn(card,2,0) end
                end
                
            elseif card.ability.extra.skill == 2 then --triple slash------------------------------------------
                SMODS.calculate_effect({message = "Triple Slash - Blast"}, card)

                local bonus = math.floor((card.ability.extra.burn + card.ability.extra.tremor) / 4) --final power bonus
                if bonus > 4 then bonus = 4 end
                card.ability.extra.power = 4 + bonus
                card.ability.extra.coinpower = 4

                --COIN 1--
                rollCoin(card, 1)
                --inflict 1 tremor
                applyTremor(card,1,0)
                if card.ability.extra.unrelenting == 1 then applyTremor(card,1,0) end
                if card.ability.extra.unrelentingshin == 1 then applyTremor(card,2,0) end
                if card.ability.extra.tremorcount == 0 then card.ability.extra.tremorcount = 1 end
                --COIN 2--    
                if card.ability.extra.ammo > 0 then rollCoin(card, 1.1, 1)
                elseif card.ability.extra.specialammo > 0 then rollCoin(card,1.3,2)
                else rollCoin(card,1) end
                --inflict 2 tremor and 2 burn
                applyTremor(card,2,0)
                if card.ability.extra.unrelenting == 1 then applyTremor(card,1,0) end
                if card.ability.extra.unrelentingshin == 1 then applyTremor(card,2,0) end
                if card.ability.extra.ammo > 0 then
                    card.ability.extra.ammo = card.ability.extra.ammo - 1
                    card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                    applyBurn(card,2,0)
                elseif card.ability.extra.specialammo > 0 then
                    card.ability.extra.specialammo = card.ability.extra.specialammo - 1
                    card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                    applyBurn(card,2,0)
                    if card.ability.extra.specialammo > 0 then applyBurn(card,2,0) end
                end
                
                --COIN 3--
                if card.ability.extra.ammo > 0 then rollCoin(card, 1.1, 1)
                elseif card.ability.extra.specialammo > 0 then rollCoin(card,1.3,2)
                else rollCoin(card,1) end
                --inflict 2 tremor count and 2 burn count
                applyTremor(card,0,2)
                if card.ability.extra.unrelenting == 1 then applyTremor(card,0,1) end
                if card.ability.extra.unrelentingshin == 1 then applyTremor(card,0,2) end
                if card.ability.extra.ammo > 0 then
                    card.ability.extra.ammo = card.ability.extra.ammo - 1
                    card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                    applyBurn(card,0,2)
                elseif card.ability.extra.specialammo > 0 then
                    card.ability.extra.specialammo = card.ability.extra.specialammo - 1
                    card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                    applyBurn(card,0,2)
                    if card.ability.extra.specialammo > 0 then applyBurn(card,0,2) end
                end
                --trigger tremor burst
                if card.ability.extra.tremorcount >= 3 then
                    tremorBurst(card)
                end

            else 
                if card.ability.extra.specialammo == 0 then --tanglecleaver
                    SMODS.calculate_effect({message = "Tanglecleaver"}, card)

                    local bonus = math.floor((card.ability.extra.burn + card.ability.extra.tremor) / 8) --final power bonus
                    if bonus > 2 then bonus = 2 end
                    card.ability.extra.power = 5
                    card.ability.extra.coinpower = 4 + bonus

                    --COIN 1--    
                    if card.ability.extra.ammo > 0 then rollCoin(card, 1.1, 1)
                    else rollCoin(card,1) end
                    --spend round to inflict 3 tremor and 3 burn
                    applyTremor(card,3,0)
                    if card.ability.extra.unrelenting == 1 then applyTremor(card,1,0) end
                    if card.ability.extra.unrelentingshin == 1 then applyTremor(card,2,0) end
                    if card.ability.extra.ammo > 0 then
                        card.ability.extra.ammo = card.ability.extra.ammo - 1
                        card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                        applyBurn(card,3,0)
                    end

                    --COIN 2--    
                    if card.ability.extra.ammo > 0 then rollCoin(card, 1.1, 1)
                    else rollCoin(card,1) end
                    --spend round to inflict 3 tremor count and 3 burn count
                    applyTremor(card,0,3)
                    if card.ability.extra.unrelenting == 1 then applyTremor(card,0,1) end
                    if card.ability.extra.unrelentingshin == 1 then applyTremor(card,0,2) end
                    if card.ability.extra.ammo > 0 then
                        card.ability.extra.ammo = card.ability.extra.ammo - 1
                        card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                        applyBurn(card,0,3)
                    end

                    --COIN 3--
                    if card.ability.extra.ammo > 0 then rollCoin(card, 1.6, 1)
                    else rollCoin(card,1) end
                    card.ability.extra.tremortype = 1
                    tremorBurst(card)
                    if card.ability.extra.ammo > 0 then
                        card.ability.extra.ammo = card.ability.extra.ammo - 1
                        card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                        tremorBurst(card)
                        tremorBurst(card)
                    end                    

                else --savage tigerslayer------------------------------------
                    SMODS.calculate_effect({message = "Savage Tigerslayer's Perfected Flurry of Blades"}, card)
                    local bonus = math.floor((card.ability.extra.burn + card.ability.extra.tremor) / 8) --final power bonus
                    if bonus > 2 then bonus = 2 end
                    card.ability.extra.power = 3
                    card.ability.extra.coinpower = 3 + bonus
                    --COIN 1--
                    rollCoin(card, 1)
                    applyTremor(card,3,0)
                    if card.ability.extra.unrelenting == 1 then applyTremor(card,1,0) end
                    if card.ability.extra.unrelentingshin == 1 then applyTremor(card,2,0) end
                    --COIN 2--
                    rollCoin(card, 1)
                    applyTremor(card,0,3)
                    if card.ability.extra.unrelenting == 1 then applyTremor(card,0,1) end
                    if card.ability.extra.unrelentingshin == 1 then applyTremor(card,0,2) end
                    --COIN 3--
                    if card.ability.extra.specialammo > 0 then rollCoin(card,1.3,2)
                    else rollCoin(card,1) end
                    if card.ability.extra.specialammo > 0 then
                        card.ability.extra.specialammo = card.ability.extra.specialammo - 1
                        card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                        applyBurn(card,3,0)
                        if card.ability.extra.specialammo > 0 then applyBurn(card,2,0) end
                    end    
                    --COIN 4--
                    if card.ability.extra.specialammo > 0 then rollCoin(card,1.3,2)
                    else rollCoin(card,1) end
                    if card.ability.extra.specialammo > 0 then
                        card.ability.extra.specialammo = card.ability.extra.specialammo - 1
                        card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                        applyBurn(card,0,3)
                        if card.ability.extra.specialammo > 0 then applyBurn(card,0,2) end
                    end    
                    --COIN 5--
                    if card.ability.extra.specialammo > 0 then rollCoin(card,1.3,2)
                    else rollCoin(card,1) end
                    card.ability.extra.tremortype = 1
                    tremorBurst(card)
                    if card.ability.extra.specialammo > 0 then
                        card.ability.extra.specialammo = card.ability.extra.specialammo - 1
                        card.ability.extra.ammospent = card.ability.extra.ammospent + 1
                        tremorBurst(card)
                        tremorBurst(card)
                    end      
                end
            end
        end

        ----SANITY MANAGEMENT AND BURN and tremor and passives ig----
        if context.final_scoring_step then
            card.ability.extra.triggered = false 
            --tremor decrease 
            if card.ability.extra.tremorcount > 0 then
                card.ability.extra.tremorcount = card.ability.extra.tremorcount - 1
                if card.ability.extra.tremorcount == 0 then 
                    card.ability.extra.tremor = 0 
                    card.ability.extra.tremortype = 0
                end
            end
            --burn tick
            if card.ability.extra.burncount > 0 then
                SMODS.calculate_effect({Xmult_mod = card.ability.extra.burn, message = ""..card.ability.extra.burn.." Burn!", colour = G.C.RED },  card)
                card.ability.extra.burncount = card.ability.extra.burncount - 1
                if card.ability.extra.burncount == 0 then card.ability.extra.burn = 0 end
            end
            --sanity
            if G.GAME.chips + (hand_chips * mult) >= G.GAME.blind.chips then
                local sanitydiff = 20 + (G.GAME.current_round.hands_left * 2)
                card.ability.extra.sanity = card.ability.extra.sanity + sanitydiff
                SMODS.calculate_effect({message = "+"..sanitydiff.." SP", colour = G.C.BLUE}, card)
            else 
                card.ability.extra.sanity = card.ability.extra.sanity - 10
                SMODS.calculate_effect({message = "-10 SP", colour = G.C.BLUE}, card)
            end
            if card.ability.extra.sanity > 45 then card.ability.extra.sanity = 45 end
            if card.ability.extra.sanity < -45 then card.ability.extra.sanity = -45 end

            --ammo/unrelenting/overheat management
            if card.ability.extra.ammo == 0 and card.ability.extra.unrelenting == 0 and card.ability.extra.unrelentingshin == 0 then
                card.ability.extra.specialammo = 8
                card.ability.extra.unrelenting = 1
            end
            if card.ability.extra.unrelenting == 1 and card.ability.extra.ammospent >= 8 then  
                card.ability.extra.unrelenting = 0 
                card.ability.extra.unrelentingshin = 1
                card.ability.extra.ammo = 0
            end
            if card.ability.extra.ammo == 0 and card.ability.extra.specialammo == 0 and card.ability.extra.unrelentingshin == 1 then
                card.ability.extra.overheat = 1
            end
        end
        
        
        
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

}

------------Not Reading Allat------------

------------Ashe------------
SMODS.Sound({key = "laugh", path = "laugh.wav",})

SMODS.Atlas{
    key = 'ashe', --atlas key
    path = 'ashe.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'ashe', --joker key
    loc_txt = { -- local text
        name = 'Ashe',
        text = {
          "No cards are",
          "considered",
          "{C:attention}face{} cards",
        },
    },
        config = {
        extra = {

            }
        },

    atlas = 'ashe',
    pos = {x=0, y= 0},

    cost = 5,
    rarity = 2,
    blueprint_compat = false,   
    eternal_compat = true,
    perishable_compat = true,

    add_to_deck = function(self, card, from_debuff)
        
        play_sound("star_laugh", 1, 0.7)
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.joker_main then
        
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    if next(SMODS.find_card("j_star_ashe")) then return false end
    return card_is_face_ref(self, from_boss) 
end
------------Ashe------------

------------Withered Foxy------------
SMODS.Sound({key = "jumpscare", path = "jumpscare.ogg",})

SMODS.Atlas{
    key = 'foxy', --atlas key
    path = 'foxy.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'foxy', --joker key
    loc_txt = { -- local text
        name = 'Withered Foxy',
        text = {
          "This Joker gains {C:blue}+#4#{} Chips per hand played",
          "{C:inactive}(Currently {C:blue}+#3#{} {C:inactive}Chips)",
          "{C:green}#1# in #2#{} chance to",
          "do a jumpscare every second",
        },
    },
    config = { extra = { mainodds = 1, totalodds = 1000, chips = 0, chipgain = 3} },

    loc_vars = function(self, info_queue, center)
        local numerator, denominator = SMODS.get_probability_vars(card, center.ability.extra.mainodds, center.ability.extra.totalodds, 'foxy')    
        return {vars = {numerator, denominator, center.ability.extra.chips, center.ability.extra.chipgain}}
	end,

    atlas = 'foxy',
    pos = {x=0, y= 0},

    cost = 5,
    rarity = 1,
    blueprint_compat = false,   
    eternal_compat = true,
    perishable_compat = true,

    add_to_deck = function(self, card, from_debuff)
        playEffect("foxy",10000,10000) 
    end,

    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.joker_main then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipgain
            return {
                message = "+".. card.ability.extra.chips .. " Chips",
                chip_mod = card.ability.extra.chips,
            }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}

------------Withered Foxy------------

------------Salami Lid------------

SMODS.Atlas{
    key = 'salamilid', --atlas key
    path = 'salamilid.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'salamilid', --joker key
    loc_txt = { -- local text
        name = 'Salami Lid',
        text = {
          "{C:dark_edition}-#2#{} Joker slot",
          "Retrigger all played",
          "cards {C:attention}1{} time",
          "Retrigger an additional",
          "time if it don't fit",
          
        },
    },
        config = {
        extra = {
                retriggers = 1,
                jokerslots = 1,
            }
        },
    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.retriggers, center.ability.extra.jokerslots}  }
	end,

    atlas = 'salamilid',
    pos = {x=0, y= 0},

    cost = 5,
    rarity = 2,
    blueprint_compat = true,   
    eternal_compat = true,
    perishable_compat = true,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.jokerslots
    end,

    remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jokerslots
	end,

    calculate = function(self,card,context)
        if context.before then
            if jokerCount() > G.jokers.config.card_limit then card.ability.extra.retriggers = 2
            else card.ability.extra.retriggers = 1 end
        end
        if context.repetition then
			if context.cardarea == G.play then
				return {
					message = ("Again!"),
					repetitions = card.ability.extra.retriggers,
					card = card,
				}
			end
		end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}

------------Salami Lid------------

------------Neighbour------------
SMODS.Sound({key = "hello", path = "hello.ogg",})
SMODS.Sound({key = "goodbye", path = "goodbye.ogg",})

SMODS.Atlas{
    key = 'neighbour', --atlas key
    path = 'neighbour.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'neighbour', --joker key
    loc_txt = { -- local text
        name = 'Neighbour',
        text = {
          "{C:attention}+#1#{} card slot",
          "available in shop",
        },
    },
        config = {
        extra = {
                shop_size = 1,
            }
        },
    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.shop_size}  }
	end,

    atlas = 'neighbour',
    pos = {x=0, y= 0},

    cost = 5,
    rarity = 1,
    blueprint_compat = false,   
    eternal_compat = true,
    perishable_compat = true,

    add_to_deck = function(self, card, from_debuff)
        play_sound("star_hello", 1, 0.7)
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(card.ability.extra.shop_size)
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        play_sound("star_goodbye", 1, 0.7)
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(card.ability.extra.shop_size * -1)
                return true
            end
        }))
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
}
------------Neighbour------------

------------Golden Freddy------------
SMODS.Sound({key = "goldenfreddyjumpscare", path = "goldenfreddyjumpscare.ogg",})

SMODS.Atlas{
    key = 'goldenfreddy', --atlas key
    path = 'goldenfreddy.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'goldenfreddy', --joker key
    loc_txt = { -- local text
        name = 'Golden Freddy',
        text = {
          "Each played {C:attention}Ace{},",
          "{C:attention}9{}, {C:attention}8{}, or {C:attention}7{} gives",
          "{C:red}+#1#{} Mult when scored"
        },
    },
        config = {
        extra = {
                mult = 10,
            }
        },
    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult}  }
	end,

    atlas = 'goldenfreddy',
    pos = {x=0, y= 0},

    cost = 5,
    rarity = 1,
    blueprint_compat = false,   
    eternal_compat = true,
    perishable_compat = true,

    calculate = function(self, card, context)

        --1987 check (crash game)
        if context.joker_main then
            local biteof87 = {0,0,0,0}
            for i = 1, #context.scoring_hand do
                if context.full_hand[i]:get_id() == 14 then biteof87[1] = 1 end
                if context.full_hand[i]:get_id() == 9 then biteof87[2] = 1 end
                if context.full_hand[i]:get_id() == 8 then biteof87[3] = 1 end
                if context.full_hand[i]:get_id() == 7 then biteof87[4] = 1 end
            end
            if arrayEqual(biteof87, {1,1,1,1}) then 
                play_sound("star_goldenfreddyjumpscare", 1, 0.7)
                G.goldenfreddytimer = 2
            end
        end

        if context.individual and context.cardarea == G.play then
            --if not crashing
            if context.other_card:get_id() == 14 or
                context.other_card:get_id() == 9 or
                context.other_card:get_id() == 8 or
                context.other_card:get_id() == 7 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then
            unlock_card(self)
        end
        unlock_card(self)
    end
}
------------Golden Freddy------------

------FUNCTIONS------

function calculate_queen_amount()
    local count = 0
    for _, card in ipairs(G.play.cards) do
        local rank = card.base.value
        if rank == "Queen" then
            count = count + 1
        end
    end
    return count
end

function destroyCard(card)
    --insert vfx/sfx
    card:start_dissolve()
    card = nil
end

function addPotentialMan()
    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_star_potentialman', nil)
    card.sell_cost = 0
    card:add_to_deck()
    G.jokers:emplace(card)
    card.ability.eternal = true
end
    
--i have no fucking clue how these two work shoutouts to lob corp mod
local can_rerollref = G.FUNCS.can_reroll
function G.FUNCS.can_reroll(e)
    if G.GAME.rerollbuttonlock then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return
    end
    return can_rerollref(e)
end

function can_reroll(e)
    if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then 
        e.config.colour = G.C.UI.TRANSPARENT_DARK
        config.visible = false
        e.config.button = nil
        --e.children[1].children[1].config.shadow = false
        --e.children[2].children[1].config.shadow = false
        --e.children[2].children[2].config.shadow = false
    else
        e.config.colour = G.C.GREEN
        config.visible = true
        e.config.button = 'reroll_shop'

        --e.children[1].children[1].config.shadow = true
        --e.children[2].children[1].config.shadow = true
        --e.children[2].children[2].config.shadow = true
    end
end

function refresh_discounts()
    local discount = false
    --for i = 1, #G.GAME.used_vouchers do
        if G.GAME.used_vouchers["v_clearance_sale"] then
        --print ("i have this one bumass")
        discount = true
        G.GAME.discount_percent = 25
        end
        if G.GAME.used_vouchers["v_liquidation"] then
        --print ("i also  have this one bumass")
        discount = true
        G.GAME.discount_percent = 50
        end
    --end
    if discount == false then G.GAME.discount_percent = 0 end
end

-- get id of joker (yet another theft from yahiamice)
function getJokerID(card)
    if G.jokers then
        local _selfid = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then _selfid = i end
        end
        return _selfid
    end
end

function jokerExists(abilityname)
    local _check = false
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == abilityname then _check = true end
        end
    end
    return _check
end

function jokerCount()
    if G.jokers then
        local count = 0
        for i = 1, #G.jokers.cards do
            count = count + 1
        end
        --print(count)
        return count
    end
end

function rollCoin(card, multiplier, bonuspower)
    if bonuspower == nil then bonuspower = 0 end
    local overheatbonus = (1 - (G.GAME.current_round.hands_left/(G.GAME.current_round.hands_left+G.GAME.current_round.hands_played)))
    if overheatbonus > 0.5 then overheatbonus = 0.5 end
    if card.ability.extra.overheat == 1 then multiplier = multiplier + overheatbonus end
    if SMODS.pseudorandom_probability(card, 'coinroll', card.ability.extra.mainodds + card.ability.extra.sanity, card.ability.extra.totalodds, 'coinroll') then
    SMODS.calculate_effect({message = "Heads!", sound = 'star_coinheads', pitch = 1, volume = 0.7,}, card)
    card.ability.extra.power = card.ability.extra.power + card.ability.extra.coinpower + bonuspower
    else SMODS.calculate_effect({message = "Tails!", sound = 'star_cointails', pitch = 1, volume = 0.7,}, card) end
    SMODS.calculate_effect({mult_mod = (card.ability.extra.power * multiplier), message = "+".. (card.ability.extra.power * multiplier) .. " Mult", colour = G.C.RED },  card)
    SMODS.calculate_effect({chip_mod = (card.ability.extra.power * multiplier), message = "+".. (card.ability.extra.power * multiplier) .. " Chips", colour = G.C.BLUE },  card)
end

function applyTremor(card, potency, count)
    card.ability.extra.tremor = card.ability.extra.tremor + potency
    card.ability.extra.tremorcount = card.ability.extra.tremorcount + count
    if card.ability.extra.tremor == 0 then card.ability.extra.tremor = 1 end
    if card.ability.extra.tremorcount == 0 then card.ability.extra.tremorcount = 1 end
end

function applyBurn(card, potency, count)
    card.ability.extra.burn = card.ability.extra.burn + potency
    card.ability.extra.burncount = card.ability.extra.burncount + count
    if card.ability.extra.burn == 0 then card.ability.extra.burn = 1 end
    if card.ability.extra.burncount == 0 then card.ability.extra.burncount = 1 end
end

function tremorBurst(card)
    if card.ability.extra.tremortype == 0 then --default
        SMODS.calculate_effect({message = "Tremor Burst!", sound = 'star_tremorburst', pitch = 1, volume = 0.7,}, card)
    else  --scorch
        SMODS.calculate_effect({Xmult_mod = ((card.ability.extra.burn + card.ability.extra.tremor) / 2), message = "Tremor Burst!", sound = 'star_tremorburst', colour = G.C.RED, pitch = 1, volume = 0.7,}, card)
        if card.ability.extra.burncount > 0 then card.ability.extra.burncount = card.ability.extra.burncount - 1 end
        if card.ability.extra.burncount == 0 then card.ability.extra.burn = 0 end
    end
    G.GAME.blind.chips = G.GAME.blind.chips * (1-(card.ability.extra.tremor/100))
    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    --tremor decrease 
    card.ability.extra.tremorcount = card.ability.extra.tremorcount - 1
    if card.ability.extra.tremorcount == 0 then 
        card.ability.extra.tremor = 0 
        card.ability.extra.tremortype = 0
    end
end

function arrayEqual(a1, a2)
  if #a1 ~= #a2 then
    return false
  end
  for i, v in ipairs(a1) do
    if v ~= a2[i] then
      return false
    end
  end
  return true
end



--2025-06-04 21:31:05


----------------------------------------------
------------MOD CODE END----------------------
    
