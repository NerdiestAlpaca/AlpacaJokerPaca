SMODS.Joker {
	key = "arcade",
	loc_txt = {
		name = "Arcade Machine",
		text = {
			"Earn {C:money}$#1#{} at end of round",
			"{C:red}-#2#{} hand size"
		}
	},
	config = {
		extra = 7,
		hand_loss = 1
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 6 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra, card.ability.hand_loss } }
	end,
	add_to_deck = function(self, card, from_debuff)
		play_sound("paca_arcade1", 1, 0.7)
		G.hand:change_size(-card.ability.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		play_sound("paca_arcade2", 1, 0.7)
		G.hand:change_size(card.ability.hand_loss)
	end
}

SMODS.Joker {
	key = "underdog",
	loc_txt = {
		name = "Underdog Boost",
		text = {
			"Played {C:attention}2s{} and {C:attention}3s{} each",
			"give {X:mult,C:white}X#1#{} Mult when scored"
		},

	},
	config = {
		extra = {
			xmult = 1.75,
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 6 },
	cost = 7,
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
	key = "ANGEL",
	loc_txt = {
		name = "Angel's Heaven",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult if played",
			"hand contains a {C:attention}#2#{}",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult)",
		}
	},
	config = {
		mult_gain = 0.1,
		mult = 1
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 4, y = 6 },
	soul_pos = { x = 5, y = 6 },
	cost = 6,
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
	key = "smashinvite",
	loc_txt = {
		name = "Invitation Letter",
		text = {
			"When {C:attention}Boss Blind{} is selected,",
			"create a random {C:red}Rare{} {C:attention}Joker{}",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 6 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and context.blind.boss then
			local color = nil
			local rarity = 0
			G.GAME.joker_buffer = G.GAME.joker_buffer + math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
			color = G.C.RED
			rarity = 3
			
			G.E_MANAGER:add_event(Event({
				func = function() 
					local card = create_card('Joker', G.jokers, nil, rarity, nil, nil, nil, 'smashinvite')
					card:add_to_deck()
					play_sound("paca_smashbros", 1, 0.7)
					G.jokers:emplace(card)
					card:start_materialize()
					G.GAME.joker_buffer = 0
					return true
				end
			}))   
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_joker'), colour = color })
        end
	end
}

SMODS.Joker {
	key = "token",
	loc_txt = {
		name = "CEC Token",
		text = {
			"Each played {C:attention}7{} gives",
			"{C:mult}+#1#{} Mult when scored",
			"{C:green}#2# in #3#{} chance this card is",
			"destroyed at end of round"
		}
	},
	config = {
		mult = 7,
		odds = 7,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, 'token')
		return { vars = { card.ability.mult, probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "7" then
				return {
					mult = card.ability.mult
				}
			end
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if SMODS.pseudorandom_probability(card, "token", 1, card.ability.odds, "token") then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('coin6')
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
					message = "Spent!"
				}
			end
		end
	end
}


SMODS.Joker {
	key = "shipwreck",
	loc_txt = {
		name = "Jolly Roger",
		text = {
			"Played {C:attention}Lucky Cards{} give {C:mult}+#1#{}",
			"Mult and {C:money}$#2#{} when scored, but",
			"can {C:red}no longer randomly trigger"
		}
	},
	config = {
		mult = 2,
		bigbucks = 3,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
		return { vars = { card.ability.mult, card.ability.bigbucks } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 6 },
	cost = 6,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint and context.identifier == "lucky_mult" or context.identifier == "lucky_money" then
			return {
				numerator = 0
			}
		elseif context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_lucky")  then
			return {
				mult = card.ability.mult,
				dollars = card.ability.bigbucks
			}
		end
	end
}

SMODS.Joker {
	key = "spaceship",
	loc_txt = {
		name = "Space Insignia",
		text = {
			"{C:planet}Planet{} cards may",
			"appear in any of",
			"the {C:attention}Arcana Packs"
		}
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 6 },
	cost = 5,
}

SMODS.Joker {
	key = "redbrick",
	loc_txt = {
		name = "Red Brick",
		text = {
			"All booster packs in",
			"the {C:attention}Shop{} are replaced",
			"with {C:spectral}Spectral Packs{}"
		}
	},
	config = {
		in_build = false,
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 7 },
	soul_pos = { x = 1, y = 7 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		play_sound("paca_lego", 1, 0.7)
		card.ability.in_build = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end
}

SMODS.Joker {
	key = "crown",
	loc_txt = {
		name = "Crown Shield",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when",
			"a {C:tarot}Tarot{} card is used",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		},
	},
	config = {
		xmult_gain = .1,
		xmult = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 2, y = 7 },
	cost = 6,
	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Tarot" then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			G.E_MANAGER:add_event(
				Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type='variable', key='a_xmult', vars = { card.ability.xmult } }, colour = G.C.MULT });
						return true
					end
				})
			)
			return
        elseif context.joker_main then
        	return {
        		xmult = card.ability.xmult
        	}
        end
	end
}

SMODS.Joker {
	key = "crystal",
	loc_txt = {
		name = "Energy Crystal",
		text = {
			"{C:chips}+#1#{} Chips if all played ",
			"cards are of {C:diamonds}Diamond{} suit"
		},
	},
	config = {
		chips = 160
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 7 },
	cost = 7,
	calculate = function(self, card, context)
		if context.joker_main then
			for i = 1, #context.full_hand do
				if not (context.full_hand[i]:is_suit( "Diamonds") or SMODS.has_any_suit(context.full_hand[i])) then
					return nil
				end
			end
			return {
				chips = card.ability.chips
			}
        end
	end
}

SMODS.Joker {
    key = "rudolph",
    loc_txt = {
        name = "Rudolph",
        text = {
            "{C:green}#1# in #2#{} chance to",
            "create a {C:attention}Coupon Tag",
            "at end of round"
        },
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { odds = 4 },
    rarity = 1,
    atlas = "jokers",
    pos = { x = 4, y = 7 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_coupon
        return{vars = {G.GAME.probabilities.normal or 1, card.ability.odds}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and (pseudorandom('rudolph')<= G.GAME.probabilities.normal/card.ability.odds ) then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_coupon'))
                    play_sound('paca_rudolph', 0.925 + math.random() * 0.2, 0.7)
                    return true
                end)
            }))
            return {
                message = "Gifted!",
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker{
	key = "soda",
    	loc_txt = {
          name = "Orange Soda",
          text = {
          "Sell this card to",
          "create #1# random {C:attention}tag{}"
        },
      },
	atlas = "jokers",
	pos = {x = 5, y = 7},
	rarity = 1,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	config = {extra = {amount = 1}},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount}}
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            local available_tags = get_current_pool('Tag')
            local selected_tags = {}
            for i = 1, card.ability.extra.amount do
                local tag = pseudorandom_element(available_tags, pseudoseed('soda'))
                while tag == 'UNAVAILABLE' do
                    tag = pseudorandom_element(available_tags, pseudoseed('soda_reroll'))
                end
				while tag == 'tag_orbital' do
                    tag = pseudorandom_element(available_tags, pseudoseed('soda_reroll'))
                end
                selected_tags[i] = tag
            end
            G.E_MANAGER:add_event(Event({
                func = (function()
                    for _, tag in pairs(selected_tags) do
                        add_tag(Tag(tag, false, 'Small'))
                    end
                    play_sound('generic1', 1, 0.4)
                    play_sound('paca_soda', 1, 0.7)
                    return true
                end)
            }))
        end
    end
}

SMODS.Joker{
	key = "gamecard",
	loc_txt = {
		name = "Game Card",
		text = {
		"Every played card provides an",
		"extra {C:chips}+#1#{} Chips when scored",
		"{C:chips}+#2#{} Chips for each held",
		"{C:attention}Joker{} and {C:attention}Consumable{} card",
		"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips){}",
		}
	},
	atlas = "jokers",
	pos = { x = 6 , y = 7 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {scored_chips = 10, ending_chips = 20}},
    loc_vars = function(self, info_queue, card)
		local total_cards = (G.jokers and #G.jokers.cards or 0) + (G.consumeables and #G.consumeables.cards or 0)
		return {vars = {card.ability.extra.scored_chips, card.ability.extra.ending_chips, total_cards*card.ability.extra.ending_chips}}
    end,
	add_to_deck = function(self, card, from_debuff)
		play_sound("paca_switch", 1.0, 0.5)
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				chips = card.ability.extra.scored_chips
			}
        elseif context.joker_main then
            local total_cards = #G.jokers.cards + #G.consumeables.cards
            return {
                chips = total_cards*card.ability.extra.ending_chips, 
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker {
	key = "plushies",
	loc_txt = {
		name = "Plush Pile",
		text = {
			"{C:green}#1# in #2#{} chance for",
			"{C:attention}Debuffed cards{} to",
			"give {C:money}$#3#{} when scored"
		},
	},
	config = {
		chance = 2,
		money = 4,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.chance, card.ability.money} }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 7 },
	cost = 7,
	calculate = function(self, card, context)
		if context.debuffed_individual then
			if pseudorandom("plushies") < G.GAME.probabilities.normal/card.ability.chance then 
			return {
				dollars = card.ability.money
			}
			end
		end
	end
}


SMODS.Joker {
	key = "nerdy",
	loc_txt = {
		name = "{s:0.85}The Titular Alpaca",
		text = {
			"{s:1.5,C:dark_edition}Hi!{}",
			"+#1# Joker Slot",
			"{s:0.8}also{} {s:0.8,C:chips}+#2# Chips{} {s:0.8}and{} {s:0.8,C:mult}+#3# Mult"
		}
	},
	config = {
		joker_slots = 1,
		chips = 8,
		mult = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.joker_slots, card.ability.chips, card.ability.mult } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 8, y = 7 },
	soul_pos = { x = 9, y = 7 },
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
		play_sound("paca_paca", 1.0, 1.0)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.joker_slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.joker_slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
		end
	end
}