print('hands dot lua file')
SMODS.Atlas({
	key = "poker_hands",
	path = "hands.png",
	px = 53,
	py = 13,
})

--for when your only played card is destroyed on the don boss
--SMODS.PokerHand({
--	key = "nothing",
--	visible = false,
--	chips = 0,
--	mult = 0,
--	l_chips = 5,
--	l_mult = 0.5,
--	loc_txt= {
 --       name = 'nothing lmao',
--        description = { "nothing",
--		"lmao",
--		}
 --   },
--	example = {},
--	atlas = "poker_hands",
--	pos = { x = 0, y = 0 },
--	evaluate = function(parts, hand)
--		return { hand and #hand == 0 and G.GAME.hands["star_nothing"].visible and {} or nil }
--	end,
--})
