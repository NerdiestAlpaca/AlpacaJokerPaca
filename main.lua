--- STEAMODDED HEADER
--- MOD_NAME: Alpaca Jokerpaca
--- MOD_ID: ALPACA
--- MOD_AUTHOR: [NerdiestAlpaca]
--- MOD_DESCRIPTION: A mod.
--- PREFIX: paca
--- VERSION: 1.0.0
----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas{
    key = 'jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 28,
    py = 28
}


SMODS.Joker {
	key = "roxie",
	loc_txt = {
		name = "Roxie McTerrier",
		text = {
			"Each card of {C:hearts}Heart{}",
			"suit held in hand",
			"gives {C:chips}+#1#{} Chips"
		}
	},
	config = {
		chips = 25,
		has_scored = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Hearts" or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
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
			"Each card of {C:hearts}Heart{}",
			"suit held in hand",
			"gives {C:mult}+#1#{} Mult"
		}
	},
	config = {
		mult = 7,
		has_scored = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Hearts" or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
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
			"{C:attention}6{}, {C:attention}7{}, {C:attention}8{}, or {C:attention}9{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
            if context.other_card.base.value == "6" or context.other_card.base.value == "7" or context.other_card.base.value == "8" or context.other_card.base.value == "9" then
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
			"Gains {C:chips}+#1#{} Chips for every",
			"card {C:attention}discarded{} this round",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
	config = {
		chips_per_card = 4,
		chips = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips_per_card, card.ability.chips } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips
			}
		elseif context.discard and not context.other_card.debuff and not context.blueprint then
			card.ability.chips = card.ability.chips + card.ability.chips_per_card
			return {
				message = localize { type = 'variable', key = 'a_chips',vars = { card.ability.chips }},
				colour = G.C.BLUE,
				delay = 0.45, 
				card = card
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.chips = 0
			return {
				message = localize('k_reset'),
				colour = G.C.BLUE
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
		mult = 20,
		xchips = 2,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
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
			"Provides {X:chips,C:white}X#1#{} Chips for",
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
    cost = 4,
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
    config = {
        extra = {
            reps = 2,
        }
    },
	loc_txt = {
		name = "The Paw Arch",
		text = {
            'If played hand has {C:attention}less',
        	'{C:attention}than 4{} scoring cards,',
            "{C:attention}retrigger{} all cards twice"
		},
    },
	pos = { x = 7, y = 0 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    atlas = 'jokers',

    loc_vars = function(self, info_queue, card)
        return {}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and #context.scoring_hand <= 3 then
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
			"{C:attention}Aces{} held in hand", 
			"give {C:mult}+#1#{} Mult"
		}
	},
	config = {
		mult = 15,
		has_scored = false
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 0 },
	cost = 6,
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
	key = "zoe",
	loc_txt = {
		name = "Zoe Trent",
		text = {
			"Gains {C:chips}+#2#{} Chips and",
			"{C:mult}+#1#{} Mult for each",
			"scored {C:attention}Gold Card{}",
			"{C:inactive}(Currently {C:chips}+#4#{C:inactive}, {C:mult}+#3#{C:inactive})"
		}
	},
	config = {
		mult_gain = 2,
		chips_gain = 10,
		mult = 0,
		chips = 0
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_gold
		return { vars = { card.ability.mult_gain, card.ability.chips_gain, card.ability.mult, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and not context.blueprint and context.cardarea == G.play and context.other_card.ability.name == 'Gold Card' then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			card.ability.chips = card.ability.chips + card.ability.chips_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
		elseif context.joker_main then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
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
	atlas = "jokers",
	pos = { x = 0, y = 1 },
	cost = 9,
	config = {
		xmult_gain = 0.15,
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
					return true
				end
			}))

			return
		end
	end
}

SMODS.Joker {
	key = "scarf",
	loc_txt = {
		name = "Trendy Scarf",
		text = {
			"When scored, {C:attention}Bonus Cards{}",
			"give {C:mult}+#1#{} Mult and {C:attention}Mult{}",
			"{C:attention}Cards{} give {C:chips}+#2#{} Chips"
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
	atlas = "jokers",
	pos = { x = 1, y = 1 },
	cost = 4,
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
	key = "pepper",
	loc_txt = {
		name = "Pepper Clark",
		text = {
			"Each Joker has a",
			"{C:green}#1# in #2#{} chance to",
			"give {X:mult,C:white}X#3#{} Mult"
		},
	},
	config = {
		xmult = 3,
		odds = 3
	},
	loc_vars = function(card, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.xmult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal } }
	end,
	rarity = 4,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 1 },
	soul_pos = { x = 3, y = 1 },
	cost = 20,
	calculate = function(self, card, context)
		if context.other_joker and pseudorandom("pepper") < G.GAME.probabilities.normal/card.ability.odds then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end,
			}))
			return {
				xmult = card.ability.xmult
			}
		end
	end,
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
		mult = 1.5,
	},
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return { vars = { card.ability.mult} }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 1 },
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
			required_chips = 80,
			xchips_gain = .5,
			xchips = 1
		},
		old_bones = ""
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 1 },
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
	key = "cap",
	loc_txt = {
		name = "Cap",
		text = {
			"If {C:attention}first hand{} of round",
			"has only {C:attention}1{} card, destroy",
			"it and earn {C:money}$#1#{}"
		}
	},
	config = {
		money = 5
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	calculate = function(self, card, context)
		if context.destroying_card and not context.blueprint then
			if #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                SMODS.calculate_effect({ dollars = card.ability.money }, card)
               	return true
            end
            return nil
        end
	end
}

SMODS.Joker {
	key = "cashmere",
	loc_txt = {
		name = "Cashmere",
		text = {
			"Gains {C:mult}+#1#{} Mult",
			"for each sold {C:attention}Joker",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		},
	},
	config = {
		mult_gain = 5,
		mult = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 1 },
	cost = 5,
	calculate = function(self, card, context)
		if context.selling_card and not context.selling_self and context.card.ability.set == "Joker" and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			G.E_MANAGER:add_event(
				Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.mult } }, colour = G.C.MULT });
						return true
					end
				})
			)
			return
        elseif context.joker_main then
        	return {
        		mult = card.ability.mult
        	}
        end
	end
}

SMODS.Joker {
	key = "velvet",
	loc_txt = {
		name = "Velvet",
		text = {
			"Gains {C:chips}+#1#{} Chips when each",
			"played {C:attention}Queen{} is scored",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
	config = {
		chips_gain = 8,
		chips = 0
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 1 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and not context.blueprint and context.cardarea == G.play and context.other_card.base.value == "Queen" then
			card.ability.chips = card.ability.chips + card.ability.chips_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = card
			}
		elseif context.joker_main then
			return {
				chips = card.ability.chips,
			}
        end
	end
}

SMODS.Joker {
	key = "stronghoof",
	loc_txt = {
		name = "Stronghoof",
		text = {
			"{C:attention}Gold, Steel{} and {C:attention}Glass{} cards",
			"give {C:mult}+#1#{} Mult when scored"
		},
	},
	config = {
		mult = 12,
	},
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_gold
      info_queue[#info_queue+1] = G.P_CENTERS.m_steel
      info_queue[#info_queue+1] = G.P_CENTERS.m_glass
		return { vars = { card.ability.mult} }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 1 },
	cost = 4,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, 'm_steel') or SMODS.has_enhancement(context.other_card, 'm_gold') or SMODS.has_enhancement(context.other_card, 'm_glass') then
			return {
				mult = card.ability.mult
			}
		end
		end
	end
}


SMODS.Joker{
    key = 'icicle',
    rarity = 2,
	atlas = "jokers",
		loc_txt = {
			name = "Ice Sculpture",
			text = { 
				"{C:attention}Glass Cards{} give {X:mult,C:white}X#1#{}",
				"Mult but have a {C:green}#2# in #3#",
				"chance to break"
			},
	},
    cost = 6,
    blueprint_compat = false,
    pos = { x = 0, y = 2 },
    config = { extra = { xmult = 3, odds = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context) 
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            for k, c in ipairs(context.scoring_hand) do
                if c.ability.name == 'Glass Card' then
                    c.ability.extra = card.ability.extra.odds
                    c.ability.x_mult = card.ability.extra.xmult
                end
            end 
        end
    end
}

SMODS.Joker {
	key = "nidra",
	loc_txt = {
		name = "Nidra",
		text = {
			"{C:mult}+#1#{} Mult for every",
			"{C:attention}Consumable{} card held",
			"{C:blue}+#2#{} consumable slots",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		}
	},
	config = {
		extra = {
			mult_per = 10,
			slots = 3
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 2 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		if G.consumeables ~= nil and G.consumeables.config ~= nil then
			return { vars = { card.ability.extra.mult_per, card.ability.extra.slots, 0 + (card.ability.extra.mult_per * G.consumeables.config.card_count) } }
		else
			return { vars = { card.ability.extra.mult_per, card.ability.extra.slots, 0 } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		mult = 0 + (card.ability.extra.mult_per * G.consumeables.config.card_count)
        	}
        end
	end
}

SMODS.Joker {
	key = "tianhuo",
	loc_txt = {
		name = "Tianhuo",
		text = {
			"Retrigger all played cards",
			"if hand contains a {C:attention}#1#{}",
			"of {C:hearts}Hearts{} or {C:diamonds}Diamonds{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 2 },
	cost = 5,
		loc_vars = function(self, info_queue, card)
		return { vars = {
			G.localization.misc.poker_hands['Flush'],
		} }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and next(context.poker_hands['Flush']) then
			if context.other_card.base.suit == "Hearts" or context.other_card.base.suit == "Diamonds" or SMODS.has_any_suit(context.other_card) then
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
	key = "paprika",
	loc_txt = {
		name = "Paprika",
		text = {
			"{C:attention}Random Bonus{} on all",
			"scored {C:attention}Face Cards{}"
		}
	},
	config = {
		chip_min = 5,
		chip_max = 15,
		mult_min = 1,
		mult_max = 4,
		xmult_min = 1.1,
		xmult_max = 1.3,
		xchips_min = 1.1,
		xchips_max = 1.3
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 2 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chip_min,
			card.ability.chip_max,
			card.ability.mult_min,
			card.ability.mult_max,
			card.ability.xmult_min,
			card.ability.xmult_max,
			card.ability.xchips_min,
			card.ability.xchips_max
		} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_face() then
			local rand = pseudorandom("paprika")
				
			local zeroth = 0
			local first = 1 / 4
			local second = 2 / 4
			local third = 3 / 4
			local fourth = 1
			
			if zeroth < rand and rand < first then
				return {
					chips = math.floor(pseudorandom("paprika_chips") * 25) + 5
				}
			elseif first < rand and rand < second then
				return {
					mult = math.floor(pseudorandom("paprika_mult") * 8)
				}
			elseif second < rand and rand < third then
				return {
					xmult = 1 + (math.floor(pseudorandom("paprika_xmult") * 4) / 10)
				}
			elseif third < rand and rand < fourth then
				return {
					xchips = 1 + (math.floor(pseudorandom("paprika_xchips") * 4) / 10)
				}
			end
        end
	end
}


SMODS.Joker {
	key = "baihe",
	loc_txt = {
		name = "Baihe",
		text = {
			"Retrigger all played cards",
			"if hand contains a {C:attention}#1#{}",
			"of {C:spades}Spades{} or {C:clubs}Clubs{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 2 },
	cost = 5,
		loc_vars = function(self, info_queue, card)
		return { vars = {
			G.localization.misc.poker_hands['Flush'],
		} }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and next(context.poker_hands['Flush']) then
			if context.other_card.base.suit == "Spades" or context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card) then
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
	key = "pom",
	loc_txt = {
		name = "Pom",
		text = {
			"{X:chips,C:white}X#1#{} Chips",
			"{X:mult,C:white}X#1#{} Mult"
		}
	},
	config = {
		extra = {
			xvalue = 1.5,
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xvalue } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xchips = card.ability.extra.xvalue,
				xmult = card.ability.extra.xvalue
			}
		end
	end
}

SMODS.Joker {
	key = "teardrop",
	loc_txt = {
		name = "Family Reunion",
		text = {
			"{C:mult}+#1#{} Mult for each",
			"remaining {C:blue}Hand{}",
			"and {C:red}Discard{}"
		}
	},
	config = {
		extra = {
			mult = 5
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult * (G.GAME.current_round.hands_left + G.GAME.current_round.discards_left)
			}
		end
	end
}

SMODS.Joker {
	key = "ANGEL",
	loc_txt = {
		name = "THE ANGEL",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult",
			"if played hand",
			"contains a {C:attention}#2#{}",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult)",
		}
	},
	config = {
		mult_gain = 0.2,
		mult = 1
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.mult_gain,
			G.localization.misc.poker_hands['Flush'],
			card.ability.mult
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Flush']) and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
		elseif context.joker_main then
			return {
				xmult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "underdog",
	loc_txt = {
		name = "Underdog Boost",
		text = {
			"Each played {C:attention}2{} or {C:attention}3{}",
			"gives {X:mult,C:white}X#1#{} Mult",
			"when scored"
		},

	},
	config = {
		extra = {
			xmult = 1.5,
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
            if context.other_card.base.value == "2" or context.other_card.base.value == "3" then
        	return {
        		xmult = card.ability.extra.xmult
        	}
            end
	    end
	end
}

SMODS.Joker {
	key = "darkcurse",
	loc_txt = {
		name = "Dark Curse",
		text = {
			"Scoring {C:attention}Face Cards{} are",
			"turned into {C:attention}Stone Cards{}",
			"{C:attention}Stone Cards{} give {C:mult}+#1#{} Mult"
		}
	},
	config = {
		mult = 15,
	},
    rarity = 2,
    pos = { x = 9, y = 2 },
    atlas = 'jokers',
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,

    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.mult } }
    end,

  calculate = function(self, card, context)
    if context.before and not context.blueprint then
    local enhanced_a_card = false
      local cards = {}
      for k, v in ipairs(context.scoring_hand) do
          if v:get_id() == 11 or v:get_id() == 12 or v:get_id() == 13 then
          cards[#cards+1] = v
          v:set_ability(G.P_CENTERS.m_stone, nil, true)
		  enhanced_a_card = true 
          G.E_MANAGER:add_event(Event({
              func = function()
                  card:juice_up()
                  v:juice_up()
                  return true
              end
          })) 
        end
      end
    if enhanced_a_card then
      return {
        message = 'Stolen!',
        colour = G.C.JOKER_GREY
      }
    end
    end
    if context.individual and context.cardarea == G.play then
      if context.other_card.ability.name == 'Stone Card' then
          local mult_bonus = card.ability.mult
          return {
              mult = mult_bonus,
              card = card,
              colour = G.C.RED 
          }
      end
  end
  end
}

SMODS.Joker {
	key = "giegue",
	loc_txt = {
		name = "Giegue",
		text = {
			"Gains {X:chips,C:white}X#1#{} Chips",
			"when a {C:spectral}Spectral{} or",
			"{C:planet}Planet{} card is used",
			"{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)"
		},
	},
	config = {
		xchips_gain = .2,
		xchips = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xchips_gain, card.ability.xchips } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 3 },
	cost = 7,
	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint and (context.consumeable.ability.set == "Spectral" or context.consumeable.ability.set == "Planet") then
			card.ability.xchips = card.ability.xchips + card.ability.xchips_gain
			G.E_MANAGER:add_event(
				Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type='variable', key='a_xchips', vars = { card.ability.xchips } }, colour = G.C.CHIPS });
						return true
					end
				})
			)
			return
        elseif context.joker_main then
        	return {
        		xchips = card.ability.xchips
        	}
        end
	end
}



  
----------------------------------------------
------------MOD CODE END----------------------
    
