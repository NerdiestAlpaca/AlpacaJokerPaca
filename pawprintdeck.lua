SMODS.Back {
        key = 'pawprint',
        loc_txt = {
			name = "Pawprint Deck",
            text = {
            "Start run with",
            "{C:attention,T:v_overstock_norm}#1#{} and",
            "{C:attention,T:v_reroll_surplus}#2#{}",
            "{C:hearts}Joker-Paca Jokers{}",
            "appear more often",
            },
		},
        config = {},
        atlas = 'deck',
        pos = { x = 0, y = 0 },    
        unlocked = true,
        discovered = true,
        config = {
            vouchers = {
                'v_overstock_norm',
                'v_reroll_surplus',
            },
        },
        loc_vars = function(self, info_queue, card)
            return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, localize{type = 'name_text', key = 'v_reroll_surplus', set = 'Voucher'}}}
        end
}

	SMODS.Back {
		key = "artistry",
		loc_txt = {
			name = "Artistry Deck",
			text = {
				"Start run with",
				"{C:attention}Active Stylus{}",
				"and {C:attention}Screen Tablet{}",
				"Winning ante is {C:attention}9"
			},
		},
        unlocked = true,
        discovered = true,
		atlas = "deck",
		pos = { x = 1, y = 0 },
		apply = function(self)
		G.GAME.win_ante = 9
			G.E_MANAGER:add_event(Event({
				func = function()
					if G.jokers then
						local stylus = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_paca_stylus")
						stylus:add_to_deck()
						stylus:start_materialize()
						G.jokers:emplace(stylus)
						
						local tablet = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_paca_tablet")
						tablet:add_to_deck()
						tablet:start_materialize()
						G.jokers:emplace(tablet)
						
						return true
					end
				end,
			}))
		end
	}