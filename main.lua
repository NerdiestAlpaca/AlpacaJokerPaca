------------MOD CODE -------------------------
local lovely = require("lovely")

ALPACA = SMODS.current_mod
if NFS.read(SMODS.current_mod.path.."config.lua") then
    local file = STR_UNPACK(NFS.read(SMODS.current_mod.path.."config.lua"))
    ALPACA.config_file = file
end

G.FUNCS.restart_game_smods = function(e)
	SMODS.restart_game()
end

ALPACA.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			r = 0.1,
			align = "tl",
			padding = 0.2,
			colour = G.C.BLACK
		},
		nodes =  {
				create_toggle(
				{
					align = "tl",
					label = "Custom Music?",
					ref_table = ALPACA.config_file,
					ref_value = "enableMusic",
					callback = function(_set_toggle)
						ALPACA.config_file.enableMusic = _set_toggle
						NFS.write(lovely.mod_dir.."/AlpacaJokerpaca/config.lua", STR_PACK(ALPACA.config_file))
					end
				}
			),
			create_toggle(
				{
					align = "tl",
					label = "Tarot Card Skins?",
					ref_table = ALPACA.config_file,
					ref_value = "enableTarotSkins",
					callback = function(_set_toggle)
						ALPACA.config_file.enableTarotSkins = _set_toggle
						NFS.write(lovely.mod_dir .. "/AlpacaJokerpaca/config.lua", STR_PACK(ALPACA.config_file))
					end
				}
			),
			UIBox_button(
				{
					align = "tl",
					label = { "Apply Changes" }, 
					minw = 3.5,
					button = 'restart_game_smods'
				}
			),
		}
	}
end

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

if next(SMODS.find_mod("CardSleeves")) then
	assert(SMODS.load_file('sleeve.lua'))()
end

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
    key = "sleeve",
    path = "sleeve.png",
    px = 73,
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
    
