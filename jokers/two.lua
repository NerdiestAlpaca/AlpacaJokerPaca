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
		chips_gain = 6,
		mult = 0,
		chips = 0
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 5, y = 1 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_gold
		return { vars = { card.ability.mult_gain, card.ability.chips_gain, card.ability.mult, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and not context.blueprint and context.cardarea == G.play and context.other_card.ability.name == 'Gold Card' then
			card.ability.chips = card.ability.chips + card.ability.chips_gain
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.MULT })
		elseif context.joker_main then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "buttercream",
	loc_txt = {
		name = "Buttercream",
		text = {
			"{C:attention}Wild Cards{} can no",
			"longer be {C:attention}debuffed{}"
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_wild
	end,
		calculate = function(self, card, context)
			if context.debuff_card and SMODS.has_any_suit(context.debuff_card) then
				return { prevent_debuff = true }
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
		xmult = 3.5,
		odds = 2
	},
	loc_vars = function(card, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.xmult} }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal } }
	end,
	rarity = 4,
	blueprint_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 1 },
	soul_pos = { x = 8, y = 1 },
	cost = 20,
	calculate = function(self, card, context)
		if context.other_joker and pseudorandom("pepper") < G.GAME.probabilities.normal/card.ability.odds then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					if not context.blueprint then
					play_sound("paca_pepper", 1, 0.5)
					end
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
  key = "sprinkles",
  	loc_txt = {
          name = "Sugar Sprinkles",
        text = {
          "Earn {C:money}$#1#{} for each {C:attention}Wild{}",
          "{C:attention}Card{} in your {C:attention}full deck{}",
		  "at end of round",
          "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
        }
      },
  config = { extra = { money_mod = 2 } },
  rarity = 2,
  atlas = "jokers",
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = { x = 9, y = 1 },
  cost = 5,

  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    return { vars = { card.ability.extra.money_mod, wild_counter() * card.ability.extra.money_mod } }
  end,

  calc_dollar_bonus = function(self, card)
    local bonus = wild_counter() * card.ability.extra.money_mod
    if bonus > 0 then return bonus end
  end
}

SMODS.Joker {
	key = "madamepom",
	loc_txt = {
		name = "Madame Pom",
		text = {
			"{C:green}#1# in #2#{} chance to apply a",
			"{C:attention}Gold Seal{} to each scoring",
			"{C:attention}Non-Face Card{} if they",
			"don't already have a seal"
		}
	},
    rarity = 2,
    pos = { x = 0, y = 2 },
    atlas = 'jokers',
    cost = 7,
	config = {
		odds = 3
	},
    blueprint_compat = false,
    eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(card, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS['gold_seal'] or G.P_SEALS[SMODS.Seal.badge_to_key['gold_seal'] or '']
		return { vars = { G.GAME.probabilities.normal, card.ability.odds} }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal } }
	end,

  calculate = function(self, card, context)
    if context.before and not context.blueprint then
    local enhanced_a_card = false
      local cards = {}
      for k, v in ipairs(context.scoring_hand) do
          if not v:is_face() and not v:get_seal() then
          cards[#cards+1] = v
			if pseudorandom("madamepom") < G.GAME.probabilities.normal/card.ability.odds then
          v:set_seal('Gold', true)
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
      end
    if enhanced_a_card then
      return {
				message = localize('k_upgrade_ex'),
      }
    end
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
		money = 4
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 2 },
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
			"Gains {C:mult}+#1#{} Mult for",
			"every {C:attention}Joker{} sold",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		},
	},
	config = {
		mult_gain = 4,
		mult = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 2, y = 2 },
	cost = 6,
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
			"This joker gains {C:chips}+#1#{}",
			"Chips when each played",
			"{C:attention}Queen{} is scored",
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
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 3, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and not context.blueprint and context.cardarea == G.play and context.other_card:get_id() == 12 then
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
	key = "stronghoof",
	loc_txt = {
		name = "Stronghoof",
		text = {
			"Played {C:attention}Gold, Steel,{}",
			"and {C:attention}Stone{} cards give",
			"{C:mult}+#1#{} Mult when scored"
		},
	},
	config = {
		mult = 9,
	},
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_gold
      info_queue[#info_queue+1] = G.P_CENTERS.m_steel
      info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.mult} }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 2 },
	cost = 5,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, 'm_steel') or SMODS.has_enhancement(context.other_card, 'm_gold') or SMODS.has_enhancement(context.other_card, 'm_stone') then
			return {
				mult = card.ability.mult
			}
		end
		end
	end
}


SMODS.Joker{
    key = 'icicle',
    rarity = 1,
	atlas = "jokers",
		loc_txt = {
			name = "Ice Sculpture",
			text = { 
				"{C:attention}Glass Cards{} give {X:mult,C:white}X#1#{}",
				"Mult but have a {C:green}#2# in #3#",
				"chance to break"
			},
	},
    cost = 5,
    blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
    pos = { x = 5, y = 2 },
    config = { extra = { xmult = 3, odds = 3 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass
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
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 2 },
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
			"Retrigger all played",
			"{C:hearts}Hearts{} or {C:diamonds}Diamonds{} if",
			"hand contains a {C:attention}#1#{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 2 },
	cost = 6,
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
			"Played {C:attention}Face Cards{}",
			"each give random",
			"{C:mult}+Mult{} when scored"
		}
	},
	config = {
		mult_one = 3,
		mult_two = 4,
		mult_three = 5,
		mult_four = 6,
		mult_five = 7,
		mult_six = 8
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.mult_one,
			card.ability.mult_two,
			card.ability.mult_three,
			card.ability.mult_four,
			card.ability.mult_five,
			card.ability.mult_six
		} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_face() then
			local rand = pseudorandom("paprika")
				
			local zeroth = 0
			local first = 1 / 6
			local second = 2 / 6
			local third = 3 / 6
			local fourth = 4 / 6
			local fifth = 5 / 6
			local sixth = 1
			
			if zeroth < rand and rand < first then
				return {
					mult = card.ability.mult_one
				}
			elseif first < rand and rand < second then
				return {
					mult = card.ability.mult_two
				}
			elseif second < rand and rand < third then
				return {
					mult = card.ability.mult_three
				}
			elseif third < rand and rand < fourth then
				return {
					mult = card.ability.mult_four
				}
			elseif fourth < rand and rand < fifth then
				return {
					mult = card.ability.mult_five
				}
			elseif fifth < rand and rand < sixth then
				return {
					mult = card.ability.mult_six
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
			"Retrigger all played",
			"{C:spades}Spades{} or {C:clubs}Clubs{} if",
			"hand contains a {C:attention}#1#{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 2 },
	cost = 6,
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
		name = "Pom Lamb",
		text = {
			"Other {C:blue}Common{} Jokers",
			"each give {X:chips,C:white}X#1#{} Chips"
		}
	},
	config = {
			xchips = 1.25
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xchips } }
	end,
	calculate = function(self, card, context)
		if context.other_joker and (context.other_joker.config.center.rarity == 1 or context.other_joker.config.center.rarity == "Common") and context.other_joker ~= card then
			return {
				xchips = card.ability.xchips
			}
		end
	end
}