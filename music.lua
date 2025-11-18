if ALPACA.config_file['enableMusic'] then
    SMODS.Sound({
        vol = 0.6,
        pitch = 1,
        key = "aaa_music1",
        path = "aaa_music1.ogg",
        select_music_track = function()
            return 10 or false
        end,
    })

    SMODS.Sound({
        vol = 0.6,
        pitch = 1,
        key = "aaa_music2",
        path = "aaa_music2.ogg",
        select_music_track = function()
            return (G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED) and 11 or false
        end,
    })
    SMODS.Sound({
        vol = 0.5,
        pitch = 1,
        key = "aaa_music3",
        path = "aaa_music3.ogg",
        select_music_track = function()
            return (G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED) and 11 or false
        end,
    })
    SMODS.Sound({
        vol = 0.65,
        pitch = 1,
        key = "aaa_music4",
        path = "aaa_music4.ogg",
        select_music_track = function()
            return (G.shop and not G.shop.REMOVED) and 11 or false
        end,
    })
    SMODS.Sound({
        vol = 0.55,
        pitch = 1,
        key = "aaa_music5",
        path = "aaa_music5.ogg",
        select_music_track = function()
            return (G.GAME.blind and G.GAME.blind.boss) and 11 or false
        end,
    })
end