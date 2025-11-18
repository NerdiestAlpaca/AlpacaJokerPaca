SMODS.Joker {
	key = "morpho",
	loc_txt = {
		name = "Morpho Knight",
		text = {
			"Scored {C:attention}Wild Cards{} give",
			"either {X:mult,C:white}X#1#{}, {X:mult,C:white}X#2#{}, ",
			"{X:mult,C:white}X#3#{}, or {X:mult,C:white}X#4#{} Mult"
		},
	},
	config = {
		small = 1.25,
		medium = 1.5,
		big = 1.75,
		mega = 2,
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    atlas = "jokers",
    pos = { x = 6, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_wild
		return { vars = { card.ability.small, card.ability.medium, card.ability.big, card.ability.mega } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_any_suit(context.other_card) then
			local rand = pseudorandom("morpho")
				
			local zeroth = 0
			local first = 3 / 10
			local second = 7 / 10
			local third = 9 / 10
			local fourth = 1
			
			if zeroth < rand and rand < first then
				return {
					xmult = card.ability.small
				}
			elseif first < rand and rand < second then
				return {
					xmult = card.ability.medium
				}
			elseif second < rand and rand < third then
				return {
					xmult = card.ability.big
				}
			elseif third < rand and rand < fourth then
				return {
					xmult = card.ability.mega
				}
			end
        end
	end
}

SMODS.Joker {
  key = "weapon",
  	loc_txt = {
          name = "AZ's Weapon",
        text = {
          "Earn {C:money}$#2#{} at end of round",
          "Payout increases by {C:money}$#1#{} if the",
          "{C:attention}final hand{} of a Blind is played",
          "Payout decreases by {C:money}$#1#{}",
          "when Blind is {C:attention}skipped{}"
        }
      },
  config = { money_mod = 1, extra = 2 },
  rarity = 2,
  atlas = "jokers",
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = { x = 7, y = 4 },
  cost = 6,

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.money_mod, card.ability.extra } }
  end,

	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_left < card.ability.money_mod then
      card.ability.extra = card.ability.extra + card.ability.money_mod
    end
      if context.skip_blind and card.ability.extra > 1 then
        card.ability.extra = card.ability.extra - card.ability.money_mod
    end
    end
}

SMODS.Joker {
	key = "elephant",
	loc_txt = {
		name = "Elephant Fruit",
		text = {
			"The next {C:attention}#1#{} played cards",
			"each give {C:money}$#2#{} when scored"
		}
	},
	config = {
		money = 1,
		card_count = 25
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 8, y = 4 },
	pools = {food = true},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.card_count, card.ability.money }
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			card.ability.card_count = card.ability.card_count - 1
			SMODS.calculate_effect( {dollars = card.ability.money}, context.other_card)
			if card.ability.card_count == 0 then
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Wowie Zowie!" })
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						play_sound("paca_elephant", 1, 4)
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
			end
		end
	end
}

SMODS.Joker {
	key = "darkcurse",
	loc_txt = {
		name = "Dark Curse",
		text = {
			"Scoring {C:attention}Face Cards{}",
			"are turned into",
			"{C:attention}Stone Cards{}",
		}
	},
    rarity = 1,
    pos = { x = 9, y = 4 },
    atlas = 'jokers',
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
	perishable_compat = true,
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.mult } }
    end,

  calculate = function(self, card, context)
    if context.before and not context.blueprint then
    local enhanced_a_card = false
      local cards = {}
      for k, v in ipairs(context.scoring_hand) do
          if v:is_face() then
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
		play_sound("paca_curse", 1, 0.7),
        colour = G.C.JOKER_GREY
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
		xchips_gain = .15,
		xchips = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xchips_gain, card.ability.xchips } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 0, y = 5 },
	cost = 7,
	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint and (context.consumeable.ability.set == "Spectral" or context.consumeable.ability.set == "Planet") then
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "xchips",
					scalar_value = "xchips_gain",
					message_colour = G.C.MULT,
				})
			return
        elseif context.joker_main then
        	return {
        		xchips = card.ability.xchips
        	}
        end
	end
}

SMODS.Joker {
	key = "insatian",
	loc_txt = {
		name = "Insatian",
		text = {
			"{C:mult}+#1#{} Mult",
			"{C:red}-#2#{} hand size"
		}
	},
	config = {
		mult = 100,
		hand_loss = 2
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 5 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card.ability.hand_loss } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_loss)
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		mult = card.ability.mult
        	}
        end
	end
}

SMODS.Joker {
	key = "sakuroma",
	loc_txt = {
		name = "Sakuroma",
		text = {
			"Played cards with {C:hearts}Heart{}",
			"suit give {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult when scored"
		},
	},
	config = {
		chips = 15,
		mult = 2
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Hearts") or SMODS.has_any_suit(context.other_card)) then
				return {
					chips = card.ability.chips,
					mult = card.ability.mult,
				}
        end
	end
}

SMODS.Joker {
	key = "nightflaid",
	loc_txt = {
		name = "Nightflaid",
		text = {
			"At end of round, {C:red}destroys",
			"{C:red}#1# random card{} held in hand",
			"and gains {X:chips,C:white}X#2#{} Chips if a",
			"card is destroyed this way",
			"{C:inactive}(Currently {X:chips,C:white}X#3#{C:inactive} Chips)"
		}
	},
	config = {
		cards_destroyed = 1,
		xchips_gain = 0.35,
		xchips = 1
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	pos = { x = 3, y = 5 },
	soul_pos = { x = 4, y = 5 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.cards_destroyed, card.ability.xchips_gain, card.ability.xchips } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and #G.hand.cards > 0 and not context.blueprint then
			local knife = pseudorandom_element(G.hand.cards, pseudoseed('nightflaid'))
			G.E_MANAGER:add_event(Event({
            	trigger = 'after',
            	delay = 0.1,
            	func = function()
					play_sound("paca_scythe", 1, 0.7)
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Ta-ta!", colour = G.C.RED})
					card:juice_up(0.3, 0.5)
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    if SMODS.has_enhancement(knife, "m_glass") then
						knife:shatter()
					else
						knife:start_dissolve(nil, false)
					end
					SMODS.scale_card(card, {
						ref_table = card.ability,
						ref_value = "xchips",
						scalar_value = "xchips_gain",
						message_colour = G.C.MULT,
					})
					SMODS.calculate_context({remove_playing_cards = true, removed = { knife }})
                    return true
                end
            }))
		elseif context.joker_main then
        	return {
        		xchips = card.ability.xchips
        	}
	end
	end
}

SMODS.Joker {
	key = "izzurius",
	loc_txt = {
		name = "Izzurius",
		text = {
			"Played {C:spades}Spade{} cards",
			"give either {C:chips}+#1#{} Chips,",
			"{C:mult}+#2#{} Mult, {X:mult,C:white}X#3#{} Mult,",
			"or {C:money}$#4#{} when scored" 
		},
	},
	config = {
		chips = 65,
		mult = 9,
		xmult = 1.65,
		money = 2,
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    atlas = "jokers",
    pos = { x = 5, y = 5 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.mult, card.ability.xmult, card.ability.money} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Spades") or SMODS.has_any_suit(context.other_card)) then
			local rand = pseudorandom("izzurius")
				
			local zeroth = 0
			local first = 1 / 4
			local second = 2 / 4
			local third = 3 / 4
			local fourth = 1
			
			if zeroth < rand and rand < first then
				return {
					chips = card.ability.chips
				}
			elseif first < rand and rand < second then
				return {
					mult = card.ability.mult
				}
			elseif second < rand and rand < third then
				return {
					xmult = card.ability.xmult
				}
			elseif third < rand and rand < fourth then
				return {
					dollars = card.ability.money
				}
			end
        end
	end
}

SMODS.Joker {
	key = "hivemine",
	loc_txt = {
		name = "Hivemine",
		text = {
			"{C:chips}+#1#{} Chip, {C:mult}+#2#{} Mult for",
			"every {C:money}$#3#{} you have",
			"{C:inactive}(Currently {C:chips}+#4#{C:inactive}, {C:mult}+#5#{C:inactive})"
		}
	},
	config = {
		extra = {
			chips_per = 1,
			mult_per = 0.5,
			money = 1
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 5 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_per, card.ability.extra.mult_per, card.ability.extra.money, (card.ability.extra.chips_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)), (card.ability.extra.mult_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money))  } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and to_number(math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)) >= 1 then
        	return {
				chips = to_number(card.ability.extra.chips_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)),
				mult = to_number(card.ability.extra.mult_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money))
			}
        end
	end
}

SMODS.Joker {
	key = "campanella",
	loc_txt = {
		name = "Campanella",
		text = {
			"{C:planet}Planet Cards{} provide",
			"{C:attention}#1# more level{} for their",
			"respective {C:attention}Poker Hand{}"
		},
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 5 },
	config = {
		level_amt = 1,
		levels = {}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.level_amt } }
	end,

calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.set == 'Planet' then
        for hand, data in pairs(G.GAME.hands) do
			if self.config.levels[hand] ~= data.level then
			return {
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'), chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level}),
				level_up_hand(card, hand, nil, card.ability.level_amt),
				update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''}),
				play_sound("paca_ufo", 1, 0.7),
				message = "Explored!",
				colour = G.C.SECONDARY_SET.Planet
			}
				end
			end
		end
	end
    for hand, data in pairs(G.GAME.hands) do
      if self.config.levels[hand] ~= data.level then
        G.E_MANAGER:add_event(Event({
          func = function()
            for hand, data in pairs(G.GAME.hands) do
              self.config.levels[hand] = data.level
            end
            return true
          end
        }))
end
end
end
}

SMODS.Joker {
	key = "elliana",
	loc_txt = {
		name = "Elliana",
		text = {
			"Retrigger",
			"each played",
			"{C:attention}Ace{} #1# times"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 5 },
	config = {
        extra = {
            reps = 2,
        }
    },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reps } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
            if context.other_card.base.value == "Ace" then
			return {
				message = localize('k_again_ex'),
				repetitions = card.ability.extra.reps,
				card = context.blueprint_card or card
			}
			end
		end
	end
}

SMODS.Joker {
  key = "artificer",
	loc_txt = {
		name = "The Artificer",
    text = {
      "If played hand {C:attention}outscores{}",
      "Blind requirements, this",
      "Joker gains {X:mult,C:white}X#2#{} Mult",
      "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)"
    },
	},
  config = { xmult = 1, scaling = 0.3 },
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  rarity = 3,
  atlas = "jokers",
  pos = { x = 9, y = 5 },
  cost = 8,
  
  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.xmult, card.ability.scaling}}
  end,


  calculate = function(self, card, context)
    if context.after then
      if hand_chips*mult>=G.GAME.blind.chips then
        if not context.blueprint then
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "xmult",
					scalar_value = "scaling",
					message_colour = G.C.MULT,
				})
        end
    end
  end
  if context.joker_main then
    return {
      xmult = card.ability.xmult
    }
  end
end
}

SMODS.Joker{
  key = "abyss",
	loc_txt = {
		name = "Gatekeeper",
		text = {
			'Copies the ability', 
			'of rightmost {C:attention}Joker'
		}
	},
    atlas = "jokers",
    pos = {x = 0, y = 6},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        if card.area == G.jokers and G.jokers.cards[#G.jokers.cards] ~= card and G.jokers.cards[#G.jokers.cards].config.center.blueprint_compat then
            card.ability.blueprint_compat = ' '..localize('k_compatible')..' '
            card.ability.bubble_colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)

        else
            card.ability.blueprint_compat = ' '..localize('k_incompatible')..' '
            card.ability.bubble_colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
        end
        return {main_end = (card.area and card.area == G.jokers) and {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = card, align = "m", colour = card.ability.bubble_colour, r = 0.05, padding = 0.06}, nodes={
                    {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                }}
            }}}}
    end,
    calculate = function(self, card, context)
        return SMODS.blueprint_effect(card, G.jokers.cards[#G.jokers.cards], context)
    end    
}

SMODS.Joker {
	key = "rabbit",
	loc_txt = {
		name = "Elfazar's Rabbit",
		text = {
			"Creates a {C:tarot}Tarot{} card when",
			"played hand is a {C:attention}#1#{}",
			"{s:0.9}Hand changes at end of round",
			"{C:inactive}(Must have room)"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 6 },
	cost = 5,
	config = {
		selected_hand = "High Card"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands[card.ability.selected_hand]} }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "rabbit")
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and context.scoring_name == card.ability.selected_hand then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'rabbit')
						new_card:add_to_deck()
						G.consumeables:emplace(new_card)
						card:juice_up(0.3, 0.5)
						play_sound("paca_magic", 1.0, 0.7)
					end
					return true
				end
			}))
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "rabbit")
			while not G.GAME.hands[card.ability.selected_hand].visible do
				card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "rabbit")
			end
		end
	end
}