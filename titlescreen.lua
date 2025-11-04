------------MOD CODE -------------------------
SMODS.Atlas {
	key = "splash",
	path = "splash.png",
	px = 333,
	py = 216,
	atlas_table = "ASSET_ATLAS"
}

SMODS.Joker {
	key = "nerdy_title",
	discovered = true,
	atlas = "jokers",
	pos = { x = 8, y = 7 },
	soul_pos = { x = 9, y = 7 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}