------------MOD CODE -------------------------

assert(SMODS.load_file('sound.lua'))()
assert(SMODS.load_file('music.lua'))()
assert(SMODS.load_file('titlescreen.lua'))()
assert(SMODS.load_file('collab1.lua'))()
assert(SMODS.load_file('collab2.lua'))()
assert(SMODS.load_file('pawprintdeck.lua'))()
assert(SMODS.load_file('tarot.lua'))()
assert(SMODS.load_file('jokers/one.lua'))()
assert(SMODS.load_file('jokers/two.lua'))()
assert(SMODS.load_file('jokers/three.lua'))()
assert(SMODS.load_file('jokers/four.lua'))()
assert(SMODS.load_file('jokers/five.lua'))()

SMODS.Atlas{
    key = 'jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas {
    key = "deck",
    path = "deck.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "boosters",
    path = "booster.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 28,
    py = 28
}

SMODS.Atlas {
    key = "consumables",
    path = "consumable.png",
    px = 71,
    py = 95
}

SMODS.Booster:take_ownership("buffoon_normal_1", {
		atlas = "boosters",
		pos = { x = 0, y = 0 }
	},
	true
)

SMODS.Booster:take_ownership("buffoon_normal_2", {
		atlas = "boosters",
		pos = { x = 1, y = 0 }
	},
	true
)

SMODS.Booster:take_ownership("buffoon_jumbo_1", {
		atlas = "boosters",
		pos = { x = 2, y = 0 }
	},
	true
)

SMODS.Booster:take_ownership("buffoon_mega_1", {
		atlas = "boosters",
		pos = { x = 3, y = 0 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_1", {
		atlas = "boosters",
		pos = { x = 0, y = 1 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_2", {
		atlas = "boosters",
		pos = { x = 1, y = 1 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_3", {
		atlas = "boosters",
		pos = { x = 2, y = 1 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_4", {
		atlas = "boosters",
		pos = { x = 3, y = 1 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_jumbo_1", {
		atlas = "boosters",
		pos = { x = 0, y = 2 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_jumbo_2", {
		atlas = "boosters",
		pos = { x = 1, y = 2 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_mega_1", {
		atlas = "boosters",
		pos = { x = 2, y = 2 }
	},
	true
)

SMODS.Booster:take_ownership("arcana_mega_2", {
		atlas = "boosters",
		pos = { x = 3, y = 2 }
	},
	true
)

 function get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

function wild_counter()
  local count = 0
  if G.playing_cards then
    for k, v in pairs(G.playing_cards) do
      if v.config.center == G.P_CENTERS.m_wild then count = count + 1 end
    end
  end
  return count
end
  
----------------------------------------------
------------MOD CODE END----------------------
    
