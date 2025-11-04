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
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 3 },
	cost = 4,
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
	key = "honey",
	loc_txt = {
		name = "Honey Poodle",
		text = {
			"Retrigger all scoring",
			"{C:attention}Cards with Editions{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 3 },
	cost = 6,
	calculate = function(self, card, context)
			if context.repetition and context.cardarea == G.play then
				if (context.other_card.edition and not context.other_card.edition.base == true) then
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
	key = "elsa",
	loc_txt = {
		name = "Elsa Nicole Corgi",
		text = {
			"Retrigger all scoring",
			"{C:attention}Enhanced Cards{}"
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 3 },
	cost = 7,
	calculate = function(self, card, context)
			if context.repetition and context.cardarea == G.play then
			if context.other_card.ability.effect ~= "Base" then
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
	key = "bigcookie",
	loc_txt = {
		name = "Big Cookie",
		text = {
			"Retrigger all scoring",
			"{C:attention}Cards with Seals{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 3 },
	cost = 6,
	calculate = function(self, card, context)
			if context.repetition and context.cardarea == G.play then
				if context.other_card:get_seal() then
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
	key = "chikn",
	loc_txt = {
		name = "Demigod of Chaos",
		text = {
			"Gains {C:chips}+#1#{} Chips and {X:mult,C:white}X#2#{} Mult",
			"if played hand is a {C:attention}Secret Hand{}",
			"{C:inactive}(Currently {C:chips}+#3#{} {C:inactive}Chips and{} {X:mult,C:white}X#4#{}{C:inactive} Mult{})"

		}
	},
	config = {
		chips_gain = 66,
		mult_gain = 0.6,
		chips = 0,
		mult = 1
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 5, y = 3 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips_gain, card.ability.mult_gain, card.ability.chips, card.ability.mult, G.localization.misc.poker_hands['Flush Five'], G.localization.misc.poker_hands['Flush House'], G.localization.misc.poker_hands['Five of a Kind'] } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and (next(context.poker_hands['Flush Five']) or next(context.poker_hands['Flush House']) or next(context.poker_hands['Five of a Kind'])) and not context.blueprint then
			card.ability.chips = card.ability.chips + card.ability.chips_gain
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
		elseif context.joker_main then
			return {
				chips = card.ability.chips,
				xmult = card.ability.mult
			}
end
end
}

SMODS.Joker {
	key = "throneroom",
	loc_txt = {
		name = "Whisker Palace",
		text = {
			"After {C:attention}#1#{C:inactive} [#2#]{} rounds,",
			"sell this card to",
			"apply {C:dark_edition}#3#{} to the",
			"Joker to the {C:attention}right"
		}
	},
	config = {
		turn_cap = 2,
		turns = 0
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 6, y = 3 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		return { vars = { card.ability.turn_cap, card.ability.turns, G.localization.descriptions.Edition.e_polychrome.name } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.turns = card.ability.turns + 1
			card:juice_up(0.3,0.4)
			if card.ability.turns >= card.ability.turn_cap then
				local eval = function(card)
					return card.ability.turns >= card.ability.turn_cap
				end
				juice_card_until(card, eval, true)
			end
		elseif context.selling_self and #G.jokers.cards > 1 and card.ability.turns >= card.ability.turn_cap and not context.blueprint then
			local joker = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					joker = G.jokers.cards[i + 1]
				end
			end
			if joker then
				G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.4,
						func = function()
							joker:set_edition("e_polychrome", true)
							return true
						end
					}))
				end
		end
	end
}

SMODS.Joker {
	key = "pumpkin",
	loc_txt = {
		name = "Pumpkin",
		text = {
			"Each {C:attention}Queen{}",
			"held in hand", 
			"gives {X:chips,C:white}X#1#{} Chips"
		}
	},
	config = {
		xchips = 1.5,
		has_scored = false
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 3 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xchips } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and context.other_card.base.value == "Queen" and not card.ability.has_scored then
			return {
				xchips = card.ability.xchips
			}
		elseif context.after and context.cardarea == G.jokers then
			card.ability.has_scored = true
        end
	end
}

SMODS.Joker {
	key = "dreamy",
	loc_txt = {
		name = "Dreamy",
		text = {
			"{C:green}#1# in #2#{} chance to",
			"create a {C:spectral}Spectral{}",
			"card at end of round",
			"{C:inactive}(Must have room){}"
		}
	},
	config = {
		create_odds = 3,
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.create_odds} }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and pseudorandom("dreamy_create") < G.GAME.probabilities.normal/card.ability.create_odds then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then 
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
							local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'dreamy')
							card:add_to_deck()
							G.consumeables:emplace(card)
							G.GAME.consumeable_buffer = 0
						return true
					end)}))
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral })
			end
        end
	end
}

SMODS.Joker {
	key = "treasure",
	loc_txt = {
		name = "Treasure",
		text = { 
			"Earn an additional {C:money}$#1#{}",
			"for each {C:attention}remaining",
			"{C:attention}hand{} at end of round"
		} 
	},
    config = {
        extra = {
            money = 2
        }
    },
    rarity = 2,
    pos = { x = 9, y = 3 },
    atlas = 'jokers',
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if not G.GAME.modifiers.money_per_hand then
            G.GAME.modifiers.money_per_hand = 1
        end

        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand + card.ability.extra.money
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand - card.ability.extra.money
    end,

    calculate = function(self, card, context)

    end
}

SMODS.Joker {
	key = "bdaycake",
	loc_txt = {
		name = "Berry's Birthday Cake",
		text = {
			"{C:green}#1# in #2#{} chance to {C:attention}create{} a {C:planet}Planet{}",
			"card when using a {C:tarot}Tarot{} card",
			"{C:inactive}(Must have room){}",
			"{C:green}#1# in #3#{} chance to be {C:attention}destroyed{}",
			"when using a {C:tarot}Tarot{} card"
		}
	},
	config = {
		planet_odds = 2,
		destroy_odds = 10
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
    perishable_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 4 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, planet_odds = SMODS.get_probability_vars(card, 1, card.ability.planet_odds, "bdaycake_planet")
		local _, destroy_odds = SMODS.get_probability_vars(card, 1, card.ability.destroy_odds, "bdaycake_destroy")
		return { vars = { probabilities_normal, planet_odds, destroy_odds } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Tarot' then
			if SMODS.pseudorandom_probability(card, "bdaycake_planet", 1, card.ability.planet_odds, "bdaycake_planet") then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'bdaycake')
							new_card:add_to_deck()
							G.consumeables:emplace(new_card)
							if context.blueprint then
								context.blueprint_card:juice_up(0.3, 0.5)
							else
								card:juice_up(0.3, 0.5)
							end
						end
						return true
					end
				}))
			end
			if not context.blueprint then
				if SMODS.pseudorandom_probability(card, "bdaycake_destroy", 1, card.ability.destroy_odds, "bdaycake_destroy") then
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound('tarot1')
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
								func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true;
								end
							})) 
							return true
						end
					})) 
					return {
						message = "Eaten!"
					}
				end
			end
        end
	end
}

SMODS.Joker {
	key = "stylus",
	loc_txt = {
		name = "Active Stylus",
		text = {
			"Gains {C:chips}+#1#{} Chip when each",
			"played card is scored",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
	config = {
		chips_gain = 1,
		chips = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 1, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and not context.blueprint and context.cardarea == G.play then
			card.ability.chips = card.ability.chips + card.ability.chips_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex')})
		elseif context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "kabong",
	loc_txt = {
		name = "El Kabong",
		text = {
			"{X:chips,C:white}X#1#{} Chips and {X:mult,C:white}X#1#{} Mult",
			"on {C:attention}final hand{} of round",
			"{X:chips,C:white}X#2#{} and {X:mult,C:white}X#2#{} instead",
			"on final {C:attention}Boss Blind{} hand",
		},
	},
	config = {
		value_normal = 2,
		value_boss = 3,
		value_wtf = 99999,
		hands_remaining = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.value_normal, card.ability.value_boss, card.ability.value_wtf, card.ability.hands_remaining} }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 4 },
	cost = 8,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_left <= card.ability.hands_remaining then
			if G.GAME.blind.name == "Small Blind" then
				return {
					xchips = card.ability.value_normal,
					xmult = card.ability.value_normal,
					play_sound("paca_kabong", 1, 0.3)
				}
			elseif G.GAME.blind.name == "Big Blind" then
				return {
					xchips = card.ability.value_normal,
					xmult = card.ability.value_normal,
					play_sound("paca_kabong", 1, 0.3)
				}
			elseif G.GAME.blind.boss then
				return {
					xchips = card.ability.value_boss,
					xmult = card.ability.value_boss,
					play_sound("paca_kabong", 1, 0.55)
				}
			else
				return {
					chips = card.ability.value_wtf,
					play_sound("paca_kabong", 1, 4),
					mult = card.ability.value_wtf,
					play_sound("paca_kabong", 1, 4),
					xchips = card.ability.value_wtf,
					play_sound("paca_kabong", 1, 4),
					xmult = card.ability.value_wtf,
					play_sound("paca_kabong", 1, 4),
					message = "?????????",
					play_sound("paca_kabong", 1, 4)
				}
			end
			end
			end
}

SMODS.Joker({
	key = "huckleberry",
	atlas = "jokers",
		loc_txt = {
		name = "Mayor Huckleberry",
		text = {
				"Played {C:attention}non-face{} cards",
				"have a {C:green}#1# in #2#{} chance",
				"to give {C:money}$#3#{} when scored"
		}
	},
	pos = {x = 3, y = 4},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {
		money_chance = 3,
		dollar = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.money_chance, card.ability.dollar} }
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.config.center.always_scores then
			if context.other_card.base.value == "2" or context.other_card.base.value == "3" or context.other_card.base.value == "4" or context.other_card.base.value == "5" or context.other_card.base.value == "6" or context.other_card.base.value == "7" or context.other_card.base.value == "8" or context.other_card.base.value == "9" or context.other_card.base.value == "10" or context.other_card.base.value == "Ace" then
            if pseudorandom("huckleberry") < G.GAME.probabilities.normal/card.ability.money_chance then 
                return {
                    dollars = card.ability.dollar,
                    card = card
                }
            	end
            end
        end
    end
})

SMODS.Joker {
	key = "susan",
	loc_txt = {
		name = "Susan",
		text = {
			"{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult",
			"when {C:attention}#5# discards{} left",
			"{C:chips}+#3#{} Chips, {C:mult}+#4#{} Mult",
			"if {C:attention}#5# discards{} on {C:attention}Boss{}",
		}
	},
	config = {
		chips_normal = 40,
		mult_normal = 10,
		chips_boss = 100,
		mult_boss = 25,
		discards_remaining = 0,
		value_wtf = 99999,
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 4 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips_normal, card.ability.mult_normal, card.ability.chips_boss, card.ability.mult_boss, card.ability.discards_remaining, card.ability.value_wtf } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.discards_left == card.ability.discards_remaining then
			if G.GAME.blind.name == "Small Blind" then
				return {
					chips = card.ability.chips_normal,
					mult = card.ability.mult_normal,
				}
			elseif G.GAME.blind.name == "Big Blind" then
				return {
					chips = card.ability.chips_normal,
					mult = card.ability.mult_normal,
				}
			elseif G.GAME.blind.boss then
				return {
					chips = card.ability.chips_boss,
					mult = card.ability.mult_boss,
				}
			else
				return {
					chips = card.ability.value_wtf,
					mult = card.ability.value_wtf,
					xchips = card.ability.value_wtf,
					xmult = card.ability.value_wtf,
					message = "?????????",
				}
			end
			end
			end
}

SMODS.Joker {
	key = "tablet",
	loc_txt = {
		name = "Screen Tablet",
		text = {
			"Gains {C:mult}+#1#{} Mult when each",
			"played card is scored",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	config = {
		mult_gain = 0.5,
		mult = 0
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 5, y = 4 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and not context.blueprint and context.cardarea == G.play then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex')})
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}