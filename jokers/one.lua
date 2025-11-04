SMODS.Joker {
	key = "roxie",
	loc_txt = {
		name = "Roxie McTerrier",
		text = {
			"Each card of {C:club}Club{}",
			"suit held in hand",
			"gives {C:chips}+#1#{} Chips"
		}
	},
	config = {
		chips = 30,
		has_scored = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = context.blueprint_card or card,
				}
			else
				return {
					chips = card.ability.chips
				}
			end
		elseif context.after and context.cardarea == G.jokers then
			card.ability.has_scored = true
        end
	end
}

SMODS.Joker {
	key = "jade",
	loc_txt = {
		name = "Jade Catkin",
		text = {
			"Each card of {C:clubs}Club{}",
			"suit held in hand",
			"gives {C:mult}+#1#{} Mult"
		}
	},
	config = {
		mult = 5,
		has_scored = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = context.blueprint_card or card,
				}
			else
				return {
					mult = card.ability.mult
				}
			end
		elseif context.after and context.cardarea == G.jokers then
			card.ability.has_scored = true
        end
	end
}

SMODS.Joker {
	key = "tripquincy",
	loc_txt = {
		name = "Trip & Quincy",
		text = {
			"Retrigger each played",
			"{C:attention}6{}, {C:attention}7{}, {C:attention}8{}, {C:attention}9{}, or {C:attention}10{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
            if context.other_card.base.value == "6" or context.other_card.base.value == "7" or context.other_card.base.value == "8" or context.other_card.base.value == "9" or context.other_card.base.value == "10" then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
			end
		end
	end
}

SMODS.Joker {
	key = "edie",
	loc_txt = {
		name = "Edie Von Keet",
		text = {
			"Gains {C:mult}+#1#{} Mult for",
			"every card {C:attention}discarded{}",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	config = {
		mult_per_card = 0.5,
		mult = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_per_card, card.ability.mult } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 3, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.discard and not context.other_card.debuff and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_per_card
			return {
				message = localize { type = 'variable', key = 'a_mult',vars = { card.ability.mult }},
				colour = G.C.RED,
				delay = 0.45, 
				card = card
			}
        end
	end
}

SMODS.Joker {
	key = "bev",
	loc_txt = {
		name = "Bev Gilturtle",
		text = {
			"{C:green}#1# in #2#{} chance for {C:mult}+#4#{} Mult",
			"{C:green}#1# in #3#{} chance for {X:chips,C:white}X#5#{} Chips",
		}
	},
	config = {
		mult_odds = 2,
		xchips_odds = 4,
		mult = 25,
		xchips = 2,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.mult_odds, card.ability.xchips_odds, card.ability.mult, card.ability.xchips} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			
			if pseudorandom("bev_mult") < G.GAME.probabilities.normal/card.ability.mult_odds then 
				SMODS.calculate_effect({ mult = card.ability.mult }, card)
			end

			if pseudorandom("bev_xchips") < G.GAME.probabilities.normal/card.ability.xchips_odds then
				SMODS.calculate_effect({ xchips = card.ability.xchips }, card)
			end

        end
	end
}

SMODS.Joker {
	key = "savannah",
	loc_txt = {
		name = "Savannah Cheetaby",
		text = {
			"{X:chips,C:white}X#1#{} Chips for",
			"every {C:money}$#2#{} you have",
			"{C:inactive}(Currently {X:chips,C:white}X#3#{C:inactive} Chips)"
		}
	},
	config = {
		extra = {
			xchips_per = 0.1,
			money = 5
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips_per, card.ability.extra.money, (1 + card.ability.extra.xchips_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and to_number(math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)) >= 1 then
        	return {
				xchips = 1 + to_number(card.ability.extra.xchips_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money))
			}
        end
	end
}

SMODS.Joker {
    key = 'scoot',
	loc_txt = {
		name = "Scoot Racoonerson",
		text = {
			"{C:attention}+#1# Card, Booster,{} and",
			"{C:attention}Voucher{} in the shop",
			"Everything in the shop",
			"costs {C:money}$1{} more"
		},
	},
    atlas = 'jokers',
	pos = { x = 6, y = 0 },
    rarity = 2,
	config = {
		slots = 1,
		hikeup = 1
	},
    blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
    cost = 5,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.slots, card.ability.hikeup } }
    end,
    add_to_deck = function(self, card, from_debuff)
        change_shop_size(card.ability.slots)
		SMODS.change_voucher_limit(card.ability.slots)
		SMODS.change_booster_limit(card.ability.slots)
		G.GAME.inflation = G.GAME.inflation + card.ability.hikeup
		for k, v in pairs(G.I.CARD) do
			if v.set_cost then v:set_cost() end
		end
    end,

    remove_from_deck = function(self, card, from_debuff)
        change_shop_size(-card.ability.slots)
		SMODS.change_voucher_limit(-card.ability.slots)
		SMODS.change_booster_limit(-card.ability.slots)
		G.GAME.inflation = G.GAME.inflation - card.ability.hikeup
		for k, v in pairs(G.I.CARD) do
			if v.set_cost then v:set_cost() end
		end
    end
}

SMODS.Joker{
    key = "pawarch",
	loc_txt = {
		name = "The Paw Arch",
		text = {
            'If played hand has',
        	'{C:attention}3 or fewer{} cards,',
            "{C:attention}retrigger{} all scored cards"
		},
    },
	config = {
        extra = {
            reps = 1,
        }
    },
	pos = { x = 7, y = 0 },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = true,
    atlas = 'jokers',

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reps } }
	end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and #context.full_hand <= 3 then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.reps,
                card = card
            }
        	end
    	end
}

SMODS.Joker {
	key = "manny",
	loc_txt = {
		name = "Manny Mouser",
		text = {
			"Each {C:attention}Ace{} held in hand", 
			"gives {C:mult}+#1#{} Mult"
		}
	},
	config = {
		mult = 15,
		has_scored = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and context.other_card.base.value == "Ace" and not card.ability.has_scored then
			return {
				mult = card.ability.mult
			}
		elseif context.after and context.cardarea == G.jokers then
			card.ability.has_scored = true
        end
	end
}

SMODS.Joker {
	key = "petula",
	loc_txt = {
		name = "Petula Woolwright",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when a",
			"{C:attention}playing card{} is destroyed",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{} Mult)"
		},
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 9, y = 0 },
	cost = 7,
	config = {
		xmult_gain = 0.2,
		xmult = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.remove_playing_cards and not context.blueprint then
			local cards = 0
			for i = 1, #context.removed do
					cards = cards + 1
			end
		
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.ability.xmult = card.ability.xmult + cards*card.ability.xmult_gain
							return true
						end
					}))
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.xmult + cards*card.ability.xmult_gain } } })
					play_sound("paca_petula", 1.0, 0.8)
					return true
				end
			}))

			return
		end
	end
}

SMODS.Joker {
	key = "austin",
	loc_txt = {
		name = "Austin Goldenpup",
		text = {
			"{X:chips,C:white}X#1#{} Chips if your {C:attention}full",
			"{C:attention}deck{} is exactly {C:attention}#3#{} cards",
			"Otherwise {C:chips}+#2#{} Chips"
		}
	},
	config = {
			xchips = 2,
			pitychips = 20
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = {x = 0, y = 1},
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xchips, card.ability.pitychips, G.GAME.starting_deck_size } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.starting_deck_size == #G.playing_cards then
			return {
				xchips = card.ability.xchips
			}
		elseif G.GAME.starting_deck_size ~= #G.playing_cards then
			return {
				chips = card.ability.pitychips
			}
		end
		end
	end
}

SMODS.Joker {
	key = "scarf",
	loc_txt = {
		name = "Trendy Scarf",
		text = {
			"When scored, {C:chips}Bonus Cards{}",
			"give {C:mult}+#1#{} Mult and {C:mult}Mult{}",
			"{C:mult}Cards{} give {C:chips}+#2#{} Chips"
		},
	},
	config = {
		mult = 2,
		chips = 15,
	},
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
      info_queue[#info_queue+1] = G.P_CENTERS.m_mult
		return { vars = { card.ability.mult, card.ability.chips} }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 1 },
	cost = 3,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_bonus') then
			return {
				mult = card.ability.mult
			}
		end
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_mult') then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "catcher",
	loc_txt = {
		name = "The Pet Catcher",
		text = {
			"Prevents Death if chips",
			"scored are at least {C:attention}#1#%{} of",
			"requirement, gains {X:chips,C:white}X#2#{} Chips",
			"when Death is prevented",
			"{C:inactive}(Currently {X:chips,C:white}X#3#{C:inactive} Chips)"
		},
	},
	config = {
		extra = {
			required_chips = 70,
			xchips_gain = .5,
			xchips = 1
		},
		old_bones = ""
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 1 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.required_chips, card.ability.extra.xchips_gain, card.ability.extra.xchips } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.old_bones = G.localization.misc.dictionary.ph_mr_bones
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xchips = card.ability.extra.xchips
        	}
        elseif context.game_over and to_big(G.GAME.chips)/G.GAME.blind.chips >= to_big(card.ability.extra.required_chips / 100) and not context.blueprint then
        	card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_gain
        	G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound('tarot1')
					return true
				end
			}))
			G.localization.misc.dictionary.ph_mr_bones = "You can't escape ME, Little Pet..."
			play_sound("paca_catcher", 1.0, 0.7)
			return {
				message = localize { type = 'variable', key = 'a_xchips',vars = { card.ability.extra.xchips }},
				saved = true,
				colour = G.C.BLUE
			}
		elseif context.ending_shop and not context.blueprint then
			G.localization.misc.dictionary.ph_mr_bones = card.ability.old_bones
        end
	end
}


SMODS.Joker {
	key = "key",
	loc_txt = {
		name = "Paw-Tucket Key",
		text = {
			"Played {C:attention}Steel Cards{} give",
			"{X:mult,C:white}X#1#{} Mult when scored"
		},
	},
	config = {
		mult = 1.33,
	},
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return { vars = { card.ability.mult} }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 1 },
	cost = 4,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_steel') then
			return {
				xmult = card.ability.mult
			}
		end
	end
}

 SMODS.Joker {
    key = 'misteryut',
    loc_txt = {
      name = 'Mr. Yut',
      text = {
        "Return to {C:attention}Shop{} when",
        "a blind is {C:attention}skipped{}"
      }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
      return { vars = {  } }
    end,
  
    rarity = 2,
    atlas = 'jokers',
    pos = { x = 4, y = 1 },
    cost = 8,
  
      blueprint_compat = false,
      eternal_compat = true,
      perishable_compat = true,

      calculate = function(self, card, context)
        if context.skip_blind then
          return {
            message = 'You Again?',
            card = card
          }
        end
      end
  }