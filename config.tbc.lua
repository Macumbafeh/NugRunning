-----------------------------------------------------------------------------------
-- It's a better idea to edit userconfig.lua in NugRunningUserConfig addon folder
-- CONFIG GUIDE: https://github.com/rgd87/NugRunning/wiki/NugRunningUserConfig
-----------------------------------------------------------------------------------
local _, helpers = ...
local Spell = helpers.Spell
local ModSpell = helpers.ModSpell
local Cooldown = helpers.Cooldown
local Activation = helpers.Activation
local EventTimer = helpers.EventTimer
local Cast = helpers.Cast
local Item = helpers.Item
local Anchor = helpers.Anchor
local Talent = helpers.ClassicTalent
local Totem = helpers.Totem
local Glyph = helpers.Glyph
local GetCP = helpers.GetCP
local SPECS = helpers.SPECS
local IsPlayerSpell = IsPlayerSpell
local IsUsableSpell = IsUsableSpell
local _,class = UnitClass("player")
local Interrupt = helpers.Interrupt
local colors = NugRunningConfig.colors

NugRunningConfig.nameplates.parented = true

local tocVersion = select(4,GetBuildInfo())
local isBC = tocVersion >= 20000 and tocVersion < 30000 -- WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
if not isBC then return end

-- RACIALS
-- EventTimer({ spellID = 23234, event = "SPELL_CAST_SUCCESS", name = "Blood Fury", duration = 15, scale = 0.75, group = "buffs" })
Spell( 20549 ,{ name = "War Stomp", global = true, duration = 2, multiTarget = true, color = colors.DRED, affiliation = "any" })
Spell( { 44041, 44043, 44044, 44045, 44046, 44047 }, { name = "Chastise", global = true, duration = 2, color = colors.DRED, affiliation = "any" })
Spell({ 28730 }, { name = "Arcane Torrent", duration = 2, shine = true, color = colors.DBLUE, affiliation = "any" })




-- WARLOCK

-- Interrupt(119910, "Spell Lock", 6) -- Felhunter spell from action bar
Interrupt(19244, "Spell Lock", 6, { affiliation = "any" }) -- Rank 1
Interrupt(19647, "Spell Lock", 8, { affiliation = "any" }) -- Rank 2
Spell( 24259 ,{ name = "Silence", duration = 3, color = colors.PINK, affiliation = "any" }) -- Spell Lock Silence

local normalize_dots_to = nil--26


Spell( 6358, { name = "Seduction", duration = 15, pvpduration = 20, color = colors.PURPLE4, affiliation = "any" }) -- varies, Improved Succubus
Spell({ 5484, 17928 }, { name = "Howl of Terror", shine = true, affiliation = "any", multiTarget = true,
    duration = function(timer)
        return timer.spellID == 5484 and 10 or 15
    end
})
Spell({ 5782, 6213, 6215 }, { name = "Fear",
    pvpduration = 20, affiliation = "any",
    duration = function(timer)
        if timer.spellID == 5782 then return 10
        elseif timer.spellID == 6213 then return 15
        else return 20 end
    end
})
Spell({ 710, 18647 }, { name = "Banish", nameplates = true, color = colors.TEAL3, affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        return timer.spellID == 710 and 20 or 30
    end
})
Spell({ 6789, 17925, 17926, 27223 }, { name = "Death Coil", duration = 3, color = colors.DTEAL, affiliation = "any" })



-- PALADIN

Spell( 20066 ,{ name = "Repentance", duration = 6, affiliation = "any" })
Spell({ 2878, 5627, 10326 }, { name = "Turn Undead", affiliation = "any",
    duration = function(timer)
        if timer.spellID == 2878 then return 10
        elseif timer.spellID == 5627 then return 15
        else return 20 end
    end
})
-- Cooldown( 879 ,{ name = "Exorcism", color = colors.ORANGE, ghost = true, priority = 8, affiliation = "any",})

Spell({ 853, 5588, 5589, 10308 }, { name = "Hammer of Justice", short = "Hammer", color = colors.FROZEN, affiliation = "any",
    duration = function(timer)
        if timer.spellID == 853 then return 3
        elseif timer.spellID == 5588 then return 4
        elseif timer.spellID == 5589 then return 5
        else return 6 end
    end
}) -- varies

Spell({ 20170 }, { name = "Seal of Justice Stun", duration = 1, shine = true, color = colors.DRED, affiliation = "any" })


-- HUNT

Spell({ 1513, 14326, 14327 }, { name = "Scare Beast", affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        if timer.spellID == 1513 then return 10
        elseif timer.spellID == 14326 then return 15
        else return 20 end
    end
})
Spell( 34490, { name = "Silencing Shot", duration = 3, color = colors.PINK, affiliation = "any" })
Spell({ 19229 }, { name = "Improved Wing Clip", duration = 5, shine = true, color = colors.DRED, affiliation = "any" })

Spell({ 19185 }, { name = "Entrapment", duration = 4, shine = true, color = colors.DRED, affiliation = "any" })

Spell({ 3034, 14279, 14280, 27018 }, { name = "Viper Sting", duration = 8, color = colors.DBLUE, affiliation = "any" })
Spell({ 19386, 24132, 24133, 27068 }, { name = "Wyvern Sting", short = "Sleep", duration = 12, color = colors.PURPLE3, ghost = 1, affiliation = "any" })


Spell({ 3355, 14308, 14309 }, { name = "Freezing Trap", color = colors.FROZEN, affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        local mul = 1 + 0.15*Talent(19239, 19245) -- Clever Traps
        if timer.spellID == 3355 then return 10*mul
        elseif timer.spellID == 14308 then return 15*mul
        else return 20*mul end
    end
})

Spell( 19503 , { name = "Scatter Shot", duration = 4, color = colors.PINK3, shine = true, affiliation = "any" })
Spell( 19410 ,{ name = "Conc Stun", duration = 3, shine = true, color = colors.RED, affiliation = "any" })
Spell( { 24394, 19577 }, { name = "Intimidation", duration = 3, shine = true, color = colors.RED, affiliation = "any" })



-- DRUID

Interrupt(16979, "Feral Charge", 4, { affiliation = "any" })



Spell({ 339, 1062, 5195, 5196, 9852, 9853, 26989, 19975, 19974, 19973, 19972, 19971, 19970, 27010 }, { name = "Entangling Roots", color = colors.DBROWN, affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        if timer.spellID == (339 or 19975) then return 12
        elseif timer.spellID == (1062 or 19974) then return 15
        elseif timer.spellID == (5195 or 19973) then return 18
        elseif timer.spellID == (5196 or 19972) then return 21
        elseif timer.spellID == (9852 or 19971) then return 24
        else return 27 end
    end
}) -- varies



Spell( 33786 ,{ name = "Cyclone", shine = true, color = colors.BLACK, overlay = {0, "gcd"}, duration = 6, affiliation = "any" })
Spell({ 2637, 18657, 18658 }, { name = "Hibernate", color = colors.PURPLE4, nameplates = true, affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        if timer.spellID == 2637 then return 20
        elseif timer.spellID == 18657 then return 30
        else return 40 end
    end
}) -- varies
Spell({ 5211, 6798, 8983 }, { name = "Bash", color = colors.RED, affiliation = "any",
    duration = function(timer)
        local brutal_impact = Talent(16940, 16941)*0.5
        if timer.spellID == 5211 then return 2+brutal_impact
        elseif timer.spellID == 6798 then return 3+brutal_impact
        else return 4+brutal_impact end
    end
}) -- varies
Spell(22570, { name = "Maim", shine = true, color = colors.LRED, affiliation = "any",
    duration = function(timer)
        return 1 + GetCP()
    end,
}) -- varies
Spell( 45334, { name = "Feral Charge", duration = 4, color = colors.DBROWN, shine = true, affiliation = "any" })
--          bear                        cat



Spell( 16922, { name = "Starfire Stun", duration = 3, shine = true, color = colors.RED, affiliation = "any" })
Spell({ 9005, 9823, 9827, 27006 }, { name = "Pounce", _skipunitaura = true, priority = -20, color = colors.RED, affiliation = "any",
    duration = function(timer)
        local brutal_impact = Talent(16940, 16941)*0.5
        return 2+brutal_impact
    end
})




-- MAGE

Interrupt(2139, "Counterspell", 8, { affiliation = "any" })
Spell( 33043 ,{ name = "Dragon's Breath", duration = 3, shine = true, color = colors.PURPLE3, affiliation = "any" })
Spell( 18469 ,{ name = "Silence", duration = 4, color = colors.CHIM, affiliation = "any" }) -- Improved Counterspell
Spell({ 118, 12824, 12825, 28271, 28272, 12826 },{ name = "Polymorph", glowtime = 5, ghost = 1, ghosteffect = "SLICENDICE", color = colors.LGREEN, affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        if timer.spellID == 118 then return 20
        elseif timer.spellID == 12824 then return 30
        elseif timer.spellID == 12825 then return 40
        else return 50 end
    end
}) -- varies


Spell( 12355 ,{ name = "Impact", duration = 2, shine = true, color = colors.PURPLE3, affiliation = "any" }) -- fire talent stun proc



-- PRIEST 

Spell( 15487 ,{ name = "Silence", duration = 5, color = colors.PINK, affiliation = "any" })

Spell({ 605, 10911, 10912 },{ name = "Mind Control", duration = 15, pvpduration = 20, color = colors.PURPLE3, affiliation = "any" })



Spell({ 9484, 9485, 10955 }, { name = "Shackle Undead", glowtime = 5, nameplates = true, color = colors.PURPLE3, ghost = 1, ghosteffect = "SLICENDICE", affiliation = "any",
    duration = function(timer)
        if timer.spellID == 9484 then return 30
        elseif timer.spellID == 9485 then return 40
        else return 50 end
    end
}) -- varies

Spell({ 8122, 8124, 10888, 10890 }, { name = "Psychic Scream", duration = 8, shine = true, multiTarget = true, affiliation = "any" })


Spell( 15269 ,{ name = "Blackout", duration = 3, shine = true, color = colors.PURPLE3, affiliation = "any" })
-- Cast( 15407, { name = "Mind Flay", short = "", priority = 12, tick = 1, overlay = {"tick", "tickend"}, color = colors.PURPLE2, priority = 11, duration = 3, scale = 0.8 })
-- Spell( 15258 ,{ name = "Shadow Vulnerability", short = "Vulnerability", duration = 15, scale = 0.5, priority = -10, glowtime = 4, ghost = true, ghosteffect = "GOUGE", color = colors.DPURPLE })





-- ROGUE
Interrupt({ 1766, 1767, 1768, 1769, 38768 }, "Kick", 5, { affiliation = "any" })
Spell( 18425 ,{ name = "Silence", duration = 2, color = colors.PINK, affiliation = "any" }) -- Improved Kick

-- Premedi doesn't work because UnitAura scan kills it
-- Spell( 14183 ,{ name = "Premeditation", duration = 10, group = "buffs", color = colors.CURSE })


Spell( 1833 , { name = "Cheap Shot", duration = 4, color = colors.LRED, affiliation = "any" })
Spell({ 2070, 6770, 11297 }, { name = "Sap", color = colors.LBLUE, glowtime = 5, ghost = 1, ghosteffect = "SLICENDICE", affiliation = "any",
    pvpduration = 20,
    duration = function(timer)
        if timer.spellID == 6770 then return 25 -- yes, Rank 1 spell id is 6770 actually
        elseif timer.spellID == 2070 then return 35
        else return 45 end
    end
}) -- varies
Spell( 2094 , { name = "Blind", duration = 10, color = colors.WOO, affiliation = "any" })

Spell({ 11327, 11329, 26888, 26889 }, { name = "Vanish", duration = 10, group = "buffs", scale = 1, color = colors.BLACK, affiliation = "any" })

Spell( 1330, { name = "Silence", color = colors.PINKIERED, duration = 3, affiliation = "any" })
Spell({ 408, 8643 }, { name = "Kidney Shot", shine = true, color = colors.LRED, affiliation = "any",
    duration = function(timer) return 1+GetCP() end,
}) -- varies
Spell({ 1776, 1777, 8629, 11285, 11286, 38764 }, { name = "Gouge", shine = true, color = colors.PINK3, affiliation = "any",
    duration = function(timer)
        return 4 + 0.5*Talent(13741, 13793, 13792)
    end
})



-- WARRIOR

Spell( 18498 ,{ name = "Silence", duration = 3, color = colors.PINK, affiliation = "any" }) -- Improved Shield Bash
Spell({ 20253, 20614, 20615, 25273, 25274 }, { name = "Intercept", duration = 3, shine = true, color = colors.DRED, affiliation = "any" })
Spell({ 100, 6178, 11578, 7922 }, { name = "Charge", duration = 1, shine = true, color = colors.DRED, affiliation = "any" })
Spell({ 23694 }, { name = "Improved Hamstring", duration = 1, shine = true, color = colors.DRED, affiliation = "any" }) -- Improved Hamstring
Spell({ 5530 }, { name = "Mace Stun Effect", duration = 1, shine = true, color = colors.DRED, affiliation = "any" }) 
Spell({ 12809 }, { name = "Concussion Blow", duration = 1, shine = true, color = colors.DRED, affiliation = "any" })
Spell({ 34510 }, { name = "Weapon Stun", duration = 1, shine = true, color = colors.DBLUE, affiliation = "any" }) -- Stormherald's and Deep Thunder's stun proc


-- Spell( 20511 ,{ name = "Intimidating Shout", duration = 8, priority = -1 }) -- Main Target
Spell( { 5246, 20511 }, { name = "Intimidating Shout", duration = 8, color = colors.PURPLE4, multiTarget = true, affiliation = "any" }) -- AoE Fear
Spell({ 8122, 8124, 10888, 10890 }, { name = "Psychic Scream", duration = 8, shine = true, multiTarget = true, affiliation = "any" })

-- TODO: Victory Rush activation

Spell( 676 ,{ name = "Disarm", color = colors.PINK3, scale = 0.8, shine = true, affiliation = "any",
    duration = function(timer)
        return 10 + Talent(12313, 12804, 12807)
    end,
}) -- varies
-- Spell( 29131 ,{ name = "Bloodrage", color = colors.WOO, duration = 10, scale = 0.5, shine = true })





local effects = {}
effects["UNHOLY"] = {
    path = "spells/enchantments/skullballs.m2",
    scale = 4,
    x = -6, y = -2,
}
effects["PURPLESWIPE"] = {
    path = "spells/enchantments/shaman_purple.m2",
    scale = 4,
    x = -10, y = -3,
}
effects["FIRESHOT"] = {
    path = "spells/fireshot_missile.m2",
    scale = 5,
    x = -3, y = -4,
}
effects["GOUGE"] = {
    path = "spells/Gouge_precast_state_hand.m2",
    scale = 5,
    x = -4, y = 0,
}
effects["MAGICCAST"] = {
    path = "spells/magic_cast_hand.m2",
    scale = 3,
    x = -12, y = -1,
}
effects["LIGHTNING"] = {
    path = "spells/lightning_precast_low_hand.m2",
    scale = 5,
    x = -1, y = 0,
}
effects["BACKSTAB"] = {
    path = "spells/backstab_impact_chest.m2",
    scale = 3,
    x = -5, y = -2,
}
effects["SLICENDICE"] = {
    path = "spells/slicedice_impact_chest.m2",
    scale = 3,
    x = -8, y = 0,
}
effects["BLOODBOIL"] = {
    path = "spells/bloodboil_impact_chest.m2",
    scale = 3.5,
    x = -4, y = -8,
}
NugRunningConfig.effects = effects


NugRunningConfig.DRopts = {
    FEAR = { id = 1, showid = 8122, name = "Fear", priority = -999, scale = 0.5, color = colors.DPURPLE, affiliation = "any" },
    -- SILENCE = { id = 2, showid = 15487, name = "Silence", priority = -999, scale = 0.5, color = colors.DPURPLE2 },
    INCAP = { id = 3, showid = 6770, name = "Incapacitation", priority = -999, scale = 0.5, color = colors.DBLUE, affiliation = "any" },
    STUN = { id = 4, showid = 7922, name = "Stun", priority = -999, scale = 0.5, color = colors.DRED, affiliation = "any" },
    -- HORROR = { id = 5, showid = 15487, name = "Horror", priority = -999, scale = 0.5, color = colors.DTEAL },
    -- RANDOM_STUN = { id = 6, showid = 15487, name = "Random Stun", priority = -999, scale = 0.5, color = colors. },
    -- RANDOM_ROOT = { id = 7, showid = 15487, name = "Random Root", priority = -999, scale = 0.5, color = colors. },
    -- FROST_SHOCK = { id = 8, showid = 15487, name = "Frost Shock", priority = -999, scale = 0.5, color = colors.DTEAL },
    ROOT = { id = 9, showid = 339, name = "Root", priority = -999, scale = 0.5, color = colors.DBROWN, affiliation = "any" },
    KIDNEY_SHOT = { id = 10, showid = 408, name = "Kidney Shot", priority = -999, scale = 0.5, color = colors.WOO2DARK, affiliation = "any" },
}

local FEAR = "FEAR"
local SILENCE = "SILENCE"
local INCAP = "INCAP"
local STUN = "STUN"
local HORROR = "HORROR"
-- local OPENER_STUN = "OPENER_STUN"
local RANDOM_STUN = "RANDOM_STUN"
local RANDOM_ROOT = "RANDOM_ROOT"
local FROST_SHOCK = "FROST_SHOCK"
local ROOT = "ROOT"
local KIDNEY_SHOT = "KIDNEY_SHOT"
local CYCLONE = "CYCLONE"

helpers.DR_TypesPVE = {
    [KIDNEY_SHOT] = true,
    [STUN] = true,
}

helpers.DR_CategoryBySpellID = {
    -- Silences weren't on DR until 3.0.8
    -- Are random stuns even diminished at all among themselves?
    -- Random roots?

    [20549] = STUN, -- War Stomp
    [16566] = ROOT, -- Net-o-Matic

    [5782] = FEAR, -- Fear 3 ranks
    [6213] = FEAR,
    [6215] = FEAR,
    [5484] = FEAR, -- Howl of Terror 2 ranks
    [17928] = FEAR,
    [6358] = FEAR, -- Seduction

    [30153] = STUN, -- Felguard Intercept Stun
    [30195] = STUN,
    [30197] = STUN,
	
	[13120] = INCAP, -- Net-o-Matic
	[8312] = INCAP, -- Trap
    [1090] = INCAP, -- Magic Dust
    [13327] = INCAP, -- Goblin Rocket Helm, Reckless Charge
    [5134] = FEAR, -- Flash Bomb

    -- [24259] = SILENCE, -- Spell Lock

    -- Coil wasn't on DR in classic, not sure about BC
    [6789] = HORROR, -- Death Coil 3 ranks
    [17925] = HORROR,
    [17926] = HORROR,
    [27223] = HORROR,

    [22703] = STUN, -- Infernal Summon Stun


    [20066] = INCAP, -- Repentance

    [853] = STUN, -- Hammer of Justice 4 ranks
    [5588] = STUN,
    [5589] = STUN,
    [10308] = STUN,

    [20170] = RANDOM_STUN, -- Seal of Justice Stun



    [3355] = INCAP, -- Freezing Trap Effect 3 ranks
    [14308] = INCAP,
    [14309] = INCAP,

    [19386] = INCAP, -- Wyvern Sting 4ranks
    [24132] = INCAP,
    [24133] = INCAP,
    [27068] = INCAP,

    [19503] = INCAP, -- Scatter Shot
    -- [19229] = RANDOM_ROOT, -- Improved Wing Clip Root

    [19306] = ROOT, -- Counterattack

    [19410] = RANDOM_STUN, -- Conc stun
    [24394] = STUN, -- Intimidation


    [2637] = INCAP, -- Hibernate 3 ranks
    [18657] = INCAP,
    [18658] = INCAP,

    [5211] = STUN, -- Bash 3 ranks
    [6798] = STUN,
    [8983] = STUN,

    [339] = ROOT, -- Entangling Roots 6 ranks
    [1062] = ROOT,
    [5195] = ROOT,
    [5196] = ROOT,
    [9852] = ROOT,
    [9853] = ROOT,
    [26989] = ROOT,
	[19675] = ROOT, -- Feral charge
    [16922] = RANDOM_STUN, -- Improved Starfire

    [33786] = CYCLONE, -- Cyclone

    -- Pounce wasn't on the same DR with Cheap Shot until 3.1.0
    [9005] = STUN, -- Pounce
    [9823] = STUN,
    [9827] = STUN,
    [27006] = STUN,


    -- [18469] = SILENCE, -- Silence (Improved Counterspell)

    [118] = INCAP, -- Polymorph 7 variants
    [12824] = INCAP,
    [12825] = INCAP,
    [12826] = INCAP,
    [28271] = INCAP,
    [28272] = INCAP,

    -- Frostbite wasn't on DR until 2.1.0
    -- [12494] = RANDOM_ROOT, -- Frostbite
    [12355] = RANDOM_STUN, -- Impact

    [122] = ROOT, -- Frost Nova 4 rank
    [865] = ROOT,
    [6131] = ROOT,
    [10230] = ROOT,

    [8056] = FROST_SHOCK, -- Frost Shock 4 ranks
    [8058] = FROST_SHOCK,
    [10472] = FROST_SHOCK,
    [10473] = FROST_SHOCK,


    -- [15487] = SILENCE, -- Silence (Priest)
    [15269] = RANDOM_STUN, -- Blackout

    -- MIND CONTROL ???
    -- No Undeads for Shackle in classic

    [8122] = FEAR, -- Psychic Scream
    [8124] = FEAR,
    [10888] = FEAR,
    [10890] = FEAR,


    -- [18425] = SILENCE, -- Imp Kick
    [1833] = STUN, -- Cheap Shot
    -- Blind wasn't on Fear until some time in 3.0, and before that it was with Cyclone,
    -- and in classic probably with itself

    -- In BC Blind and Cyclone share DR
    [2094] = CYCLONE, -- Blind

    [2070] = INCAP, -- Sap 3 ranks
    [6770] = INCAP,
    [11297] = INCAP,

    [1776] = INCAP, -- Gouge 5 ranks
    [1777] = INCAP,
    [8629] = INCAP,
    [11285] = INCAP,
    [11286] = INCAP,
    [38764] = INCAP,

    [408] = KIDNEY_SHOT, -- Kidney Shot 2 ranks
    [8643] = KIDNEY_SHOT,

    [5530] = RANDOM_STUN, -- Mace Spec Stun, shared by both Rogue and Warrior


    -- [18498] = SILENCE, -- Imp Shield Bash Silence
    -- [23694] = RANDOM_ROOT, -- Improved Hamstring Root

    -- Disarm wasn't on DR until 2.3.0
    -- [676] = "DISARM", -- Disarm

    [12809] = STUN, -- Concussion Blow
    [12798] = RANDOM_STUN, -- Improved Revenge

    [5246] = FEAR, -- Intimidating Shout
    [20511] = FEAR, -- Int shout on off targets i think

    [7922] = STUN, -- Charge

    [20253] = STUN, -- Intercept Stun 5 ranks
    [20614] = STUN,
    [20615] = STUN,
    [25273] = STUN,
    [25274] = STUN,
}
