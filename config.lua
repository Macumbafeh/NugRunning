NugRunningConfig = {}
NugRunningConfig.cooldowns = {}
local _,class = UnitClass("player")






local Talent = function (spellID)
    local spellName
    if type(spellID) == "number" then 
        spellName = GetSpellInfo(spellID)
    elseif type(spellID) == "string" then
        spellName = spellID
    end
    local numTabs = GetNumTalentTabs()
    for t=1, numTabs do
        local numTalents = GetNumTalents(t)
        for i=1, numTalents do
            local name, _,_,_, rank = GetTalentInfo(t, i)
            if spellName == name then
                return rank
            end
        end
    end
    return 0
end

local Glyph = function (gSpellID)
    for i = 1, GetNumGlyphSockets() do
        if select(3,GetGlyphSocketInfo(i,GetActiveTalentGroup()) ) == gSpellID then return 1 end
    end
    return 0
end






local function AddSpell( ids, opts)
    local spelldata = opts
    for _, i in ipairs(ids) do
        NugRunningConfig[i] = spelldata
    end
end
-- spellID to get localized spellname and it's icon. so just one rank of spell is enough
local function AddCooldown( id, opts)
    if type(id) == "table" then id = id[1] end
    opts.localname = GetSpellInfo(id)
    NugRunningConfig.cooldowns[id] = opts
end

--[[
GUIDE:
    AddSpell({ commaseparated list of spell ids which can be found on wowhead }, { settings })
        Settings:
            duration - kinda neccesary, but if possible accurate duration will be scanned from target, mouseover, player for buffs and arena 1-5, focus for debuffs.
                       only if spell is applied to something out of these unit ids then this value is used.
        
            [optional]
            name     - text on the progress bar, if omitted localized spell name will display.
            color    - RGB of bar color for spell
            short    - short name for spell. works if short text is enabled
            pvpduration - same as duration, but for enemy players 
            recast_mark - creates a mark that will shine when spell should be recasted. For example 3.5 for haunt is roughly travel time at 30yds + cast 
            maxtimers - won't create any more timers for this spell if their destination is not your target
            tick     - interval between ticks in seconds. Only used to align dots with refresh from another spell. So far used only for corruption
            multiTarget - true for aoe spells
            textfunc - called on creation, setting text on progress bar. Example: function(spellName, dstName) return dstName end
]]

local colors = {
    RED = { 0.8, 0, 0},
    LRED = { 1,0.4,0.4},
    CURSE = { 0.6, 0, 1 },
    PINK = { 1, 0.3, 0.6 },
    TEAL = { 0.32, 0.52, 0.82 },
    ORANGE = { 1, 124/255, 33/255 },
    LBLUE = {149/255, 121/255, 214/255},
    LGREEN = { 0.63, 0.8, 0.35 },
    PURPLE = { 187/255, 75/255, 128/255 },
    FROZEN = { 65/255, 110/255, 1 },
    CHILL = { 0.6, 0.6, 1},
    YELLOW = { 1, 0.9, 0 },
}



local useTrinkets = true
local procTrinkets = true
local stackingTrinkets = true
if useTrinkets then
    AddSpell({ 33702,33697,20572 },{ name = "Blood Fury", duration = 15 }) --Orc Racial
    AddSpell({ 26297, 26296, 20554 },{ name = "Berserking", duration = 10 }) --Troll Racial
    AddSpell({ 20594 },{ name = "Stoneform", duration = 8 }) --Dwarf Racial
    AddSpell({ 20549 },{ name = "War Stomp", duration = 2, multiTarget = true }) --Tauren Racial
    AddSpell({ 7744 },{ name = "Will of the Forsaken", duration = 5 }) --Undead Racial
    AddSpell({ 44041, 44043, 44044, 44045, 44046, 44047 },{ name = "Chastise", duration = 2 }) --Priest Dwarf/Draenei spell
    AddSpell({ 28730, 25046 },{ name = "Arcane Torrent", duration = 2, multiTarget = true }) --Blood elf Racial
    AddSpell({ 2651 },{ name = "Elune's Grace", duration = 15 }) --Priest Night elf spell
   
    -- Bombs/Grenades
    AddSpell({ 4067 },{ name = "Big Bronze Bomb", duration = 2, multiTarget = true })
    AddSpell({ 4068 },{ name = "Iron Grenade", duration = 3, multiTarget = true })
    AddSpell({ 4069 },{ name = "Big Iron Bomb", duration = 3, multiTarget = true })
    AddSpell({ 12543 },{ name = "Hi-Explosive Bomb", duration = 3, multiTarget = true })
    AddSpell({ 12562 },{ name = "The Big One", duration = 5, multiTarget = true })
    AddSpell({ 19769 },{ name = "Thorium Grenade", duration = 3, multiTarget = true })
    AddSpell({ 19784 },{ name = "Dark Iron Bomb", duration = 4, multiTarget = true })
    AddSpell({ 19821 },{ name = "Arcane Bomb", duration = 5, multiTarget = true })
    AddSpell({ 30216 },{ name = "Fel Iron Bomb", duration = 3, multiTarget = true })
    AddSpell({ 30217 },{ name = "Adamantite Grenade", duration = 3, multiTarget = true })
    AddSpell({ 30461 },{ name = "The Bigger One", duration = 5, multiTarget = true })
    AddSpell({ 39965 },{ name = "Frost Grenades", duration = 5, multiTarget = true })
    
    
    
    --Ulduar
        AddSpell({ 64800 },{ name = "Wrathstone", duration = 20 })
        AddSpell({ 64712 },{ name = "Living Flame", duration = 20 })
        
    --TBC
    AddSpell({ 35166 },{ name = "Lust for Battle",duration = 20, target = "player" }) --Bloodlust Brooch
    AddSpell({ 40729 },{ name = "Heightened Reflexes",duration = 20, target = "player" }) --Badge of Tenacity
    AddSpell({ 36372 },{ name = "Phalanx",duration = 15, target = "player" }) --Dabiri's Enigma
    AddSpell({ 31047 },{ name = "Nightseye Panther",duration = 12, target = "player" }) --Figurine - Nightseye Panther (rare)
    AddSpell({ 40402 },{ name = "Deep Meditation",duration = 20, target = "player" }) --Earring of Soulful Meditation
    AddSpell({ 33807 },{ name = "DeepHaste",duration = 10, target = "player" }) --Abacus of Violent Odds
    AddSpell({ 35163 },{ name = "Blessing of the Silver Crescent",duration = 20, target = "player" }) --Icon of the Silver Crescent
    AddSpell({ 34210 },{ name = "Endless Blessings",duration = 20, target = "player" }) -- Bangle of Endless Blessings Use
    AddSpell({ 40396 },{ name = "Fel Infusion",duration = 20, target = "player" }) -- The Skull of Gul'dan
    AddSpell({ 33089, 33090 },{ name = "Vigilance of the Colossus",duration = 20, target = "player" }) -- Figurine of the Colossus
    AddSpell({ 35169 },{ name = "Gnome Ingenuity",duration = 20, target = "player" }) -- Gnomeregan Auto-Blocker 600
    AddSpell({ 43712 },{ name = "Mojo Madness",duration = 20, target = "player" }) -- Hex Shrunken Head
    AddSpell({ 35165 },{ name = "Essence of the Martyr",duration = 20, target = "player" }) -- Essence of the Martyr
    AddSpell({ 31040 },{ name = "Living Ruby Serpent",duration = 20, target = "player" }) -- Figurine - Living Ruby Serpent
    AddSpell({ 44055 },{ name = "Tremendous Fortitude",duration = 15, target = "player" }) -- Battlemaster's trinkets
    AddSpell({ 39228 },{ name = "Argussian Compass",duration = 20, target = "player" }) -- Argussian Compass
    AddSpell({ 34106 },{ name = "Armor Penetration",duration = 20, target = "player" }) -- Icon of Unyielding Courage
    AddSpell({ 35337 },{ name = "Spell Power",duration = 15, target = "player" }) -- Scryer's Bloodgem & Xi'ri's Gift
    AddSpell({ 40464 },{ name = "Protector's Vigor",duration = 20, target = "player" }) -- Shadowmoon Insignia
    AddSpell({ 46784 },{ name = "Shadowsong Panther",duration = 15, target = "player" }) -- Figurine - Shadowsong Panther
    AddSpell({ 37877 },{ name = "Blessing of Faith",duration = 15, target = "player" }) -- Lower City Prayerbook
    AddSpell({ 43716 },{ name = "Call of the Berserker",duration = 20, target = "player" }) -- Berserker's Call
    AddSpell({ 51955 },{ name = "Dire Drunkard",duration = 20, target = "player" }) -- Empty Mug of Direbrew
    AddSpell({ 51954 },{ name = "Hopped Up",duration = 20, target = "player" }) -- Direbrew Hops
    AddSpell({ 51953 },{ name = "Dark Iron Pipeweed",duration = 20, target = "player" }) -- Dark Iron Smoking Pipe
    AddSpell({ 31039 },{ name = "Dawnstone Crab",duration = 20, target = "player" }) -- Figurine - Dawnstone Crab
    AddSpell({ 34519 },{ name = "Time's Favor",duration = 10, target = "player" }) -- Moroes' Lucky Pocket Watch
    AddSpell({ 46780 },{ name = "Empyrean Tortoise",duration = 20, target = "player" }) -- Figurine - Empyrean Tortoise
    AddSpell({ 51952 },{ name = "Dark Iron Luck",duration = 20, target = "player" }) -- Coren's Lucky Coin
    AddSpell({ 43713 },{ name = "Hardened Skin",duration = 20, target = "player" }) -- Ancient Aqir Artifact
    AddSpell({ 46783 },{ name = "Crimson Serpent",duration = 20, target = "player" }) -- Figurine - Crimson Serpent
    AddSpell({ 33400 },{ name = "Accelerated Mending",duration = 20, target = "player" }) -- Warp-Scarab Brooch
    AddSpell({ 38351 },{ name = "Displacement",duration = 15, target = "player" }) -- Scarab of Displacement
    AddSpell({ 33479 },{ name = "Adamantine Shell",duration = 20, target = "player" }) -- Adamantine Figurine
    AddSpell({ 34000 },{ name = "The Arcanist's Stone Shell",duration = 20, target = "player" }) -- Arcanist's Stone
    AddSpell({ 38325 },{ name = "Regeneration",duration = 12, target = "player" }) -- Spyglass of the Hidden Fleet
    AddSpell({ 35733 },{ name = "Ancient Power",duration = 20, target = "player" }) -- Core of Ar'kelos
    AddSpell({ 36347 },{ name = "Healing Power",duration = 15, target = "player" }) -- Heavenly Inspiration
    AddSpell({ 33667 },{ name = "Ferocity",duration = 15, target = "player" }) -- Bladefist's Breadth & Ancient Draenei War Talisman
    AddSpell({ 33662 },{ name = "Arcane Energy",duration = 15, target = "player" }) -- Vengeance of the Illidari & Ancient Draenei Arcane Relic
    AddSpell({ 33668 },{ name = "Tenacity",duration = 15, target = "player" }) -- Regal Protectorate
end

if procTrinkets then
    AddSpell({ 60494 },{ name = "Dying Curse", duration = 10 }) --Dying Curse
    AddSpell({ 60064 },{ name = "Sundial", duration = 10 }) --Sundial of the Exiled
    AddSpell({ 60065 },{ name = "Mirror", duration = 10 }) --Mirror of Truth
    AddSpell({ 60437 },{ name = "Grim Toll", duration = 10 })
    AddSpell({ 65014 },{ name = "Infuser", duration = 10 }) -- Pyrite Infuser
    AddSpell({ 64790 },{ name = "YoggBlood", duration = 10 }) --Blood of the Old God
    AddSpell({ 64713 },{ name = "FotHeavens", duration = 10 }) --Flame of the Heavens
    -- TBC
    AddSpell({ 34774, 34775 },{ name = "Haste",duration = 10, target = "player" }) -- Dragonspine Trophy
    AddSpell({ 39446 },{ name = "Aura of Madness",duration = 30, target = "player" }) -- Darkmoon Card: Madness
    AddSpell({ 33297, 33370 },{ name = "Spell Haste",duration = 6, target = "player" }) -- Quagmirran's Eye
    AddSpell({ 37705 },{ name = "Healing Discount",duration = 15, target = "player" }) -- Eye of Gruul
    AddSpell({ 45053, 45354 },{ name = "Disdain",duration = 20, target = "player" }) -- Shard of Contempt
    AddSpell({ 42084 },{ name = "Fury of the Crashing Waves",duration = 10, target = "player" }) -- Tsunami Talisman
    AddSpell({ 38346 },{ name = "Meditation",duration = 15, target = "player" }) -- Bangle of Endless Blessings proc
    AddSpell({ 33649 },{ name = "Rage of the Unraveller",duration = 10, target = "player" }) -- Hourglass of the Unraveller
    AddSpell({ 34321 },{ name = "Call of the Nexus",duration = 10, target = "player" }) -- Shiffar's Nexus-Horn
    AddSpell({ 34747 },{ name = "Recurring Power",duration = 10, target = "player" }) -- Eye of Magtheridon
    AddSpell({ 33370 },{ name = "Spell Haste",duration = 6, target = "player" }) -- Scarab of the Infinite Cycle
    AddSpell({ 40477 },{ name = "Forceful Strike",duration = 10, target = "player" }) -- Madness of the Betrayer
    AddSpell({ 38348 },{ name = "Unstable Currents",duration = 15, target = "player" }) -- Sextant of Unstable Currents
    AddSpell({ 45058 },{ name = "Evasive Maneuvers",duration = 10, target = "player" }) -- Commendation of Kael'thas
end

if stackingTrinkets then
    AddSpell({ 60525 },{ name = "Dragon Figurine",duration = 10 }) --Majestic Dragon Figurine
    AddSpell({ 65006 },{ name = "EotBM",duration = 10 }) --Eye of the Broodmother
    AddSpell({ 60486 },{ name = "Dragon Soul",duration = 10 }) --Illustration of the Dragon Soul
    
    --TBC
    AddSpell({ 39438 },{ name = "Aura of the Crusade",duration = 10, target = "player" }) -- Darkmoon Card: Crusade
    AddSpell({ 39443 },{ name = "Aura of Wrath",duration = 10, target = "player" }) -- Darkmoon Card: Wrath
    AddSpell({ 38333 },{ name = "Fecundity",duration = 10, target = "player" }) -- Ribbon of Sacrifice
    AddSpell({ 45062 },{ name = "Holy Energy",duration = 90, target = "player" }) -- Vial of the Sunwell
    AddSpell({ 45040 },{ name = "Battle Trance",duration = 20, target = "player" }) -- Blackened Naaru Sliver
end



if class == "WARLOCK" then
AddSpell({ 70840 },{ name = "Devious Minds",duration = 10, target = "player", color = colors.LRED }) -- t10 4pc proc
AddSpell({ 37377 },{ name = "Shadowflame",duration = 15, target = "player", color = colors.LRED }) -- t4 Shadow 2pc proc
AddSpell({ 39437 },{ name = "Shadowflame Hellfire and RoF",duration = 15, target = "player", color = colors.LRED }) -- t4 fire 2pc proc



-- BUFFS
AddSpell({ 63321 },{ name = "Life Tap",duration = 20, color = colors.PURPLE })
AddSpell({ 34936 },{ name = "Backlash",duration = 8 })
--~ AddSpell({ 54274,54276,54277 },{ name = "Backdraft",duration = 15 })
AddSpell({ 17941 },{ name = "Nightfall",duration = 10, color = colors.CURSE })
AddSpell({ 30300 },{ name = "Nether Protection",duration = 4, color = colors.LRED })
AddSpell({ 47383,71162,71165 },{ name = "Molten Core",duration = 18, color = colors.PURPLE })
AddSpell({ 6229, 11739, 11740, 28610 },{ name = "Shadow Ward",duration = 30, color = colors.PURPLE })
AddSpell({ 63167,63165 },{ name = "Decimation",duration = 8, color = colors.LBLUE })

AddSpell({ 64371 },{ name = "Eradication",duration = 10, color = colors.CURSE })
AddSpell({ 17794, 17797, 17798, 17799, 17799 },{ name = "Shadow Vulnerability",duration = 12, color = colors.PURPLE })


AddSpell({ 27243,47835,47836 },{ name = "Seed of Corruption",duration = 15, color = colors.LRED, short = "SoC" })
-- DEBUFFS
AddSpell({348, 707, 1094, 2941, 11665, 11667, 11668, 25309, 27215, 47810, 47811 },{ name = "Immolate", recast_mark = "gcd", duration = 15, color = colors.RED })
AddSpell({ 30108, 30404, 30405, 47841, 47843 },{ name = "Unstable Affliction",duration = 18, recast_mark = "gcd", color = colors.RED, short = "UA" })  -- 15 sec duration on wotlk
AddSpell({ 31117, 43523 },{ name = "Unstable Affliction",duration = 5, color = colors.PURPLE }) -- UA silence

AddSpell({ 172,6222,6223,7648,11671,11672,25311,27216 --[[ ,47812,47813]] },{ name = "Corruption", color = colors.PINK, duration = 18, init = function(self)
                                                                                                                                self.hasted = (Glyph(70947) ~= 0) end })
AddSpell({ 18265,18879,18880,18881,27264,30911 },{ name = "Siphon Life", color = colors.PINK, duration = 30 })
AddSpell({ 980,1014,6217,11711,11712,11713,27218 --[[ ,47863,47864]] },{ name = "Curse of Agony",duration = 24, color = colors.CURSE, short = "Agony", init = function(self)self.duration = 24 + Glyph(56241)*4 end })
AddSpell({ 603, 30910 --[[ , 47867]] },{ name = "Curse of Doom",duration = 60, color = colors.CURSE, short = "Doom" })
AddSpell({ 704, 7658, 7659, 11717, 27226 },{ name = "Curse of Recklessness",duration = 120, color = colors.CURSE, short = "Recklessness" })
AddSpell({ 1714,11719 },{ name = "Curse of Tongues",duration = 30, color = colors.CURSE, pvpduration = 12, short = "CoT" })
AddSpell({ 702,1108,6205,7646,11707,11708,27224,30909 --[[,50511]] },{ name = "Curse of Weakness",duration = 120, color = colors.CURSE, short = "Weakness" })
AddSpell({ 18223 },{ name = "Curse of Exhaustion",duration = 12, color = colors.CURSE, short = "CoEx" })

-- AddSpell({ 48181,59161,59163,59164 },{ name = "",duration = 12, recast_mark = 3, color = colors.TEAL }) --Haunt
AddSpell({ 1490,11721,11722,27228 --[[,47865]] },{ name = "Curse of Elements",duration = 300, color = colors.CURSE, pvpduration = 120, short = "CoE" })
AddSpell({ 30283,30413,30414,47846,47847 },{ name = "Shadowfury",duration = 2, multiTarget = true }) -- 3 sec duration on wotlk
AddSpell({ 47960,61291 },{ name = "Shadowflame",duration = 8, multiTarget = true })
--PET SPELLS
AddSpell({ 24259 },{ name = "Spell Lock",duration = 3, color = colors.PINK })
AddSpell({ 6358 },{ name = "Seduction",duration = 15, pvpduration = 10 })
AddSpell({ 17767,17850,17851,17852,17853,17854,27272,47987,47988 },{ name = "Consume Shadows", duration = 6, color = colors.PURPLE, short = "Consume" })
AddSpell({ 30153,30195,30197,47995 },{ name = "Intercept",duration = 3 })
AddSpell({ 7812,19438,19440,19441,19442,19443,27273,47985,47986 },{ name = "Sacrifice",duration = 30, color = colors.PURPLE })
--
AddSpell({ 5782 },{ name = "Fear", duration = 10, pvpduration = 10 })
AddSpell({ 6213 },{ name = "Fear", duration = 15, pvpduration = 10 })
AddSpell({ 6215 },{ name = "Fear", duration = 20, pvpduration = 10 })
--
AddSpell({ 5484 },{ name = "Howl of Terror", duration = 6, multiTarget = true })                    
AddSpell({ 17928 },{ name = "Howl of Terror", duration = 8, multiTarget = true })

AddSpell({ 710 },{ name = "Banish", duration = 20 })
AddSpell({ 18647 },{ name = "Banish", duration = 30 })
AddSpell({ 6789, 17925, 17926, 27223 },{ name = "Death Coil",duration = 3 })
-- AddCooldown( 59172, { name = "Chaos Bolt",  color = colors.LBLUE })
AddCooldown( 17962, { name = "Conflagrate",  color = colors.LRED })
--AddCooldown( 59164, { name = "HAUNT",  color = colors.LRED })
end
   

if class == "PRIEST" then
AddSpell({ 37603 },{ name = "Shadow Word Pain Damage",duration = 15, target = "player", color = colors.LRED }) -- t5 shadow 4pc proc


-- BUFFS
AddSpell({ 139,6074,6075,6076,6077,6078,10927,10928,10929,25315,25221,25222,48067,48068 },{ name = "Renew", color = colors.LGREEN, duration = 15 })
AddSpell({ 552 },{ name = "Abolish Disease", color = colors.LGREEN, duration = 20, tick = 5 })
AddSpell({ 17,592,600,3747,6065,6066,10898,10899,10900,10901,25217,25218,48065,48066 },{ name = "Power Word: Shield", duration = 30, maxtimers = 3, color = colors.LRED, short = "PW:S" })
AddSpell({ 41635,48110,48111 },{ name = "Prayer of Mending",duration = 30, color = colors.RED, textfunc = function(spellName, dstName) return dstName end })
AddSpell({ 33151 },{ name = "Surge of Light",duration = 10 })
AddSpell({ 63725,63724,34754 },{ name = "Holy Concentration",duration = 8 })
AddSpell({ 47788 },{ name = "Guardian Spirit",duration = 10, color = colors.LBLUE, short = "Guardian" })
AddSpell({ 33206 },{ name = "Pain Suppression",duration = 8, color = colors.LBLUE })
AddSpell({ 6346 },{ name = "Fear Ward",duration = 180, color = colors.LBLUE })
AddSpell({ 586, 9578, 9579, 9592, 10941, 10942, 25429 },{ name = "Fade",duration = 10 })
-- AddSpell({ 49694,59000 },{ name = "Improved Spirit Tap",duration = 8 })
AddSpell({ 15271 },{ name = "Spirit Tap",duration = 15 })
AddSpell({ 47585 },{ name = "Dispersion",duration = 6, color = colors.PURPLE })
AddSpell({ 9035, 19281, 19282, 19283, 19284, 19285, 25470 },{ name = "Hex of Weakness",duration = 120, color = colors.PURPLE }) -- Troll 
--~ AddSpell({ 47753 },{ name = "Divine Aegis", duration = 12 })
AddSpell({ 59891,59890,59889,59888,59887 },{ name = "Borrowed Time", duration = 6 })
-- DEBUFFS
AddSpell({ 453, 8192, 10953, 25596 },{ name = "Mind Soothe",duration = 15 })
AddSpell({ 15269 },{ name = "Blackout",duration = 3, color = colors.LRED })
AddSpell({ 589,594,970,992,2767,10892,10893,10894,25367,25368,48124,48125 },{ name = "Shadow Word: Pain",duration = 18, color = colors.PURPLE, refreshed = true, tick = 3, short = "SW:Pain" })
AddSpell({ 34914,34916,34917,48159,48160 },{ name = "Vampiric Touch", recast_mark = "gcd", duration = 15, color = colors.RED, short = "VampTouch", hasted = true })
AddSpell({ 2944,19276,19277,19278,19279,19280,25467,48299,48300 },{ name = "Devouring Plague",duration = 24, color = colors.CURSE, short = "Plague", hasted = true })
AddSpell({ 9484,9485,10955 },{ name = "Shackle Undead",duration = 50, pvpduration = 10, short = "Shackle" })
AddSpell({ 15487 },{ name = "Silence",duration = 5, color = colors.PINK })
--AddSpell({ 15286 },{ name = "Vampiric Embrace",duration = 300, color = colors.CURSE, short = "VampEmbrace" })
AddSpell({ 8122,8124,10888,10890 },{ name = "Psychic Scream",duration = 8, multiTarget = true })
AddSpell({ 34433 },{ name = "Shadowfiend",duration = 15, color = colors.LBLUE })
AddSpell({ 34433, 19296, 19299, 19302, 19303, 19304, 19305, 25446 },{ name = "Starshards",duration = 15, color = colors.PURPLE, tick = 3 })
AddSpell({ 34754 },{ name = "Clearcasting", duration = 15 })

AddCooldown( 8092, { name = "Mind Blast",  color = colors.LRED })

end


if class == "ROGUE" then

AddSpell({ 37165 },{ name = "Haste",duration = 6, target = "player", color = colors.LRED }) -- t3.5 2pc proc

-- BUFFS
-- AddSpell({ 57993 },{ name = "Envenom", color = { 0, 0.65, 0}, duration = function() return (1+NugRunning.cpWas) end })

AddSpell({ 2983,8696,11305 },{ name = "Sprint",duration = 15 })
AddSpell({ 5277,26669 },{ name = "Evasion", color = colors.PINK, duration = 15 })
AddSpell({ 31224 },{ name = "Cloak of Shadows", color = colors.CURSE, duration = 5, short = "CloS" })
AddSpell({ 14183 },{ name = "Premeditation",duration = 20, color = colors.CURSE })
AddSpell({ 13750 },{ name = "Adrenaline Rush",duration = 15, color = colors.LRED })
AddSpell({ 63848 },{ name = "Hunger For Blood", short="Hunger", duration = 60, color = colors.ORANGE })
AddSpell({ 13877 },{ name = "Blade Flurry",duration = 15, color = colors.LRED })
AddSpell({ 51713 },{ name = "Shadow Dance",duration = 10, color = colors.LRED })
AddSpell({ 58427 },{ name = "Overkill", duration = 20, color =  colors.RED })                    
                
AddSpell({ 5171,6774 },{ name = "Slice and Dice", short = "SnD", color = colors.PURPLE, duration = function() return ((7 + NugRunning.cpWas * 3) * (1+Talent(14165)*0.25)) end })
AddSpell({ 31234,31235,31236 },{ name = "Find Weakness",duration = 10 })

AddSpell({ 11327,11329,26888 },{ name = "Vanish",duration = 10 })
AddSpell({ 45182 },{ name = "Cheating Death",duration = 3 })
AddSpell({ 14143, 14149 },{ name = "Remorseless",duration = 20 })
AddSpell({ 36554 },{ name = "Shadowstep speed",duration = 3 })
AddSpell({ 36563 },{ name = "Shadowstep damage",duration = 10 })
--~ 
-- DEBUFFS
AddSpell({ 1833 },{ name = "Cheap Shot",duration = 4, pvpduration = 4, color = colors.LRED })
AddSpell({ 408 },{ name = "Kidney Shot",duration = function() return (1 + NugRunning.cpWas * 1) end, pvpduration = function() return (1 + NugRunning.cpWas * 1) end, color = colors.LRED })
AddSpell({ 8643 },{ name = "Kidney Shot",duration = function() return (2 + NugRunning.cpWas * 1) end, pvpduration = function() return (2 + NugRunning.cpWas * 1) end, color = colors.LRED })
AddSpell({ 1776, 1777, 8629, 11285, 11286, 38764 },{ name = "Gouge", color = colors.PINK, duration = 4, pvpduration = 4, init = function(self)self.duration = 4 + Talent(13741)*0.5 end })
AddSpell({ 2094 },{ name = "Blind",duration = 10, pvpduration = 10, color = {0.20, 0.80, 0.2} })
AddSpell({ 8647, 8649, 8650, 11197, 11198, 26866 },{ name = "Expose Armor", color = colors.LBLUE, duration = 30 --[[function() return NugRunning.cpWas * 6 + Glyph(56803)*12 end]] })
AddSpell({ 51722 },{ name = "Dismantle",duration = 10,color = colors.LRED })

AddSpell({ 6770 },{ name = "Sap",duration = 25, pvpduration = 10, color = colors.LBLUE })
AddSpell({ 2070 },{ name = "Sap",duration = 35, pvpduration = 10, color = colors.LBLUE })
AddSpell({ 11297 },{ name = "Sap",duration = 45, pvpduration = 10, color = colors.LBLUE })
AddSpell({ 51724 },{ name = "Sap",duration = 60, pvpduration = 10, color = colors.LBLUE })

AddSpell({ 1943,8639,8640,11273,11274,11275,26867,48671,48672 },{ name = "Rupture", color = colors.RED, duration = function() return (8 + NugRunning.cpWas * 2) end})
AddSpell({ 703,8631,8632,8633,11289,11290,26839,26884,48675,48676,42964 },{ name = "Garrote", color = colors.RED, duration = 18 })
AddSpell({ 1330 },{ name = "Silence", color = colors.PINK, duration = 3 })
AddSpell({ 18425 },{ name = "Silenced", color = colors.PINK, duration = 3 })
AddSpell({ 16511, 17347, 17348, 26864 },{ name = "Hemorrhage", color = colors.RED, duration = 15 })
AddSpell({ 14278 },{ name = "Ghostly Strike", color = colors.PURPLE, duration = 7 })
AddSpell({ 32748 },{ name = "Deadly Throw Interrupt", color = colors.PINK, duration = 3 })

AddSpell({ 2818,2819,11353,11354,25349,26968,27187,57969,57970}, { name = "Deadly Poison", color = { 0.1, 0.75, 0.1}, duration = 12, short = "Deadly"})

AddSpell({ 3409 },{ name = "Crippling Poison", color = { 192/255, 77/255, 48/255}, duration = 12, short = "Crippling" }) -- -50% move speed
AddSpell({ 11201 },{ name = "Crippling Poison", color = { 192/255, 77/255, 48/255}, duration = 12, short = "Crippling" }) -- -70% move speed

AddSpell({ 5760 }, { name = "Mind-numbing Poison", color = { 180/255, 70/255, 40/255 }, duration = 10, short = "Mind-numbing"})
AddSpell({ 8692 }, { name = "Mind-numbing Poison", color = { 180/255, 70/255, 40/255 }, duration = 12, short = "Mind-numbing"})
AddSpell({ 11398 }, { name = "Mind-numbing Poison", color = { 180/255, 70/255, 40/255 }, duration = 14, short = "Mind-numbing"})

AddSpell({ 13218, 13222, 13223, 13224, 27189 },{ name = "Wound Poison", color = { 195/255, 80/255, 50/255}, duration = 15, short = "Wound" })

end

if class == "WARRIOR" then
AddSpell({ 37514 },{ name = "Blade Turning",duration = 15, target = "player", color = colors.LRED }) -- t4 prot 2pc proc
AddSpell({ 37528 },{ name = "Overpower Bonus",duration = 5, target = "player", color = colors.LRED }) -- t5 arm/fury 2pc proc
AddSpell({ 37522 },{ name = "Shield Block Block Value",duration = 6, target = "player", color = colors.LRED }) -- t5 prot 2pc proc
AddSpell({ 37525 },{ name = "Battle Rush",duration = 10, target = "player", color = colors.LRED }) -- t5 prot 4pc proc

AddSpell({ 6673,5242,6192,11549,11550,11551,25289,2048,47436 },{ name = "Battle Shout", multiTarget = true, shout = true, color = colors.PURPLE, duration = 120,init = function(self)self.duration = (120 + Glyph(58385)*120) * (1+Talent(12321) * 0.25)  end })
AddSpell({ 469, 47439, 47440 },{ name = "Commanding Shout", multiTarget = true, short = "CommShout", shout = true, color = colors.PURPLE, duration = 120, init = function(self)self.duration = (120 + Glyph(68164)*120) * (1+Talent(12321) * 0.25)  end })
AddSpell({ 2565 },{ name = "Shield Block", duration = 10 })
AddSpell({ 18499 },{ name = "Berserker Rage", duration = 10 })
AddSpell({ 2687 },{ name = "Bloodrage", duration = 10 })
AddSpell({ 12880, 14201, 14202, 14203, 14204 },{ name = "Enrage", duration = 12 })
AddSpell({ 12966, 12967, 12968, 12969, 12970 },{ name = "Flurry", duration = 15 })
AddSpell({ 1719 },{ name = "Recklessness", duration = 15, color = { 0.2, 0.5, 0.7 } })
AddSpell({ 12292 },{ name = "Death Wish", duration = 30, color = { 0.2, 0.5, 0.7 } })
AddSpell({ 12328 },{ name = "Sweeping Strikes", duration = 10, color = { 0.2, 0.5, 0.7 } })
AddSpell({ 30029, 30031, 30032 },{ name = "Rampage", duration = 30, color = { 0.2, 0.5, 0.7 } })
AddSpell({ 20230 },{ name = "Retaliation", duration = 15 })
AddSpell({ 50227 },{ name = "Slam!", color = colors.LRED, duration = 5 })
AddSpell({ 7922 },{ name = "Charge", color = colors.LRED, duration = 1 })
AddSpell({ 20253, 20614, 20615, 25273, 25274 },{ name = "Intercept", color = colors.LRED, duration = 3 })
AddSpell({ 3411 },{ name = "Intervene", color = colors.YELLOW, duration = 10 })
AddSpell({ 1715, 7372, 7373, 25212 },{ name = "Hamstring", color = { 192/255, 77/255, 48/255}, duration = 15, pvpduration = 10 })
AddSpell({ 12323 },{ name = "Piercing Howl", color = { 192/255, 77/255, 48/255}, duration = 6, })
AddSpell({ 772 },{ name = "Rend", color = colors.RED, duration = 9})
AddSpell({ 6546 },{ name = "Rend", color = colors.RED, duration = 12})
AddSpell({ 6547 },{ name = "Rend", color = colors.RED, duration = 15})
AddSpell({ 6548 },{ name = "Rend", color = colors.RED, duration = 18})
AddSpell({ 11572,11573,11574,25208 },{ name = "Rend", color = colors.RED, duration = 21})
AddSpell({ 46968 },{ name = "Shockwave", color = { 0.6, 0, 1 }, duration = 4, multiTarget = true })
AddSpell({ 12809 },{ name = "Concussion Blow", color = { 1, 0.3, 0.6 }, duration = 5 })
AddSpell({ 23694 },{ name = "Immobilized", color = { 1, 0.3, 0.6 }, duration = 5 }) -- Improved Hamstring
AddSpell({ 12798 },{ name = "Stun", color = { 1, 0.3, 0.6 }, duration = 3 }) -- Revenge Stun
AddSpell({ 5530 },{ name = "Stun", color = { 1, 0.3, 0.6 }, duration = 3 }) -- Mace stun
AddSpell({ 34510 },{ name = "Stun", color = { 1, 0.3, 0.6 }, duration = 4 }) -- Stormherald/Deep thunder stun
AddSpell({ 18498 },{ name = "Silence", color = { 1, 0.3, 0.6 }, duration = 3 }) -- Shield Bash silence
AddSpell({ 355 },{ name = "Taunt", duration = 3 })
AddSpell({ 1161 },{ name = "Challenging Shout", duration = 6 })
AddSpell({ 676 },{ name = "Disarm", duration = 10 })
AddSpell({ 871 },{ name = "Shield Wall", duration = 10 })
AddSpell({ 12975 },{ name = "Last Stand", duration = 20 })
AddSpell({ 23920 },{ name = "Spell Reflection", color = { 0.2, 0.5, 0.7 }, duration = 5 })
AddSpell({ 7386, 7405, 8380, 11596, 11597,25225 },{ name = "Sunder Armor", short = "Sunder", anySource = true, color = { 1, 0.2, 0.2}, duration = 30 })
AddSpell({ 1160,6190,11554,11555,11556,25202,25203,47437 },{ name = "Demoralizing Shout", anySource = true, short = "DemoShout", color = {0.3, 0.9, 0.3}, duration = 30, multiTarget = true })
AddSpell({ 6343 },{ name = "Thunder Clap", anySource = true, color = {149/255, 121/255, 214/255}, duration = 10, multiTarget = true })
AddSpell({ 8198 },{ name = "Thunder Clap", anySource = true, color = {149/255, 121/255, 214/255}, duration = 14, multiTarget = true })
AddSpell({ 8204 },{ name = "Thunder Clap", anySource = true, color = {149/255, 121/255, 214/255}, duration = 18, multiTarget = true })
AddSpell({ 8205 },{ name = "Thunder Clap", anySource = true, color = {149/255, 121/255, 214/255}, duration = 22, multiTarget = true })
AddSpell({ 11580},{ name = "Thunder Clap", anySource = true, color = {149/255, 121/255, 214/255}, duration = 26, multiTarget = true })
AddSpell({ 11581, 25264 },{ name = "Thunder Clap", anySource = true, color = {149/255, 121/255, 214/255}, duration = 30, multiTarget = true })
--~ AddSpell({ 56112 },{ name = "Furious Attacks", duration = 10 })
AddSpell({ 52437 },{ name = "Sudden Death", color = colors.LRED, duration = 10 })
AddSpell({ 5246, 20511 },{ name = "Intimidating Shout", color = colors.LRED, duration = 8 })
AddSpell({ 60503 },{ name = "", recast_mark = 3, color = colors.RED, duration = 6 }) -- Overpower proc (Taste for Blood)
AddSpell({ 7384, 7887, 11584,11585 },{ name = "Overpower", recast_mark = 3, color = colors.RED, duration = 5 }) -- Overpower proc
AddSpell({ 5308, 20658, 20660, 20661, 20662, 25234, 25236 },{ name = "Execute", recast_mark = 3, color = colors.RED, duration = 900 }) -- Execute proc
AddSpell({ 6572, 6574, 7379, 11600, 11601, 25288, 25269, 30357 },{ name = "Revenge", recast_mark = 3, color = colors.RED, duration = 5 }) -- Revenge proc
AddSpell({ 34428 },{ name = "Victory Rush", duration = 20 }) 
AddSpell({ 12294, 21551, 21552, 21553, 25248, 30330 },{ name = "Mortal Strike", duration = 10 }) 

AddCooldown( 12294, 21551, 21552, 21553, 25248, 30330, { name = "Mortal Strike",  color = colors.LBLUE })
AddCooldown( 23881, { name = "Bloodthirst",  color = colors.LBLUE })
AddCooldown( 23922, { name = "Shield Slam",  color = colors.LBLUE, resetable = true })
AddCooldown( 1680, { name = "Whirlwind" })
--~ AddCooldown( 6572, { name = "Revenge" })
end



--[[ if class == "DEATHKNIGHT" then
AddSpell({ 55095 },{ name = "Frost Fever", color = colors.CHILL, duration = 15, init = function(self)self.duration = 15 + Talent(49036)*3 end })
AddSpell({ 55078 },{ name = "Blood Plague", color = colors.PURPLE, duration = 15, init = function(self)self.duration = 15 + Talent(49036)*3 end })

--AddSpell({ 49194 },{ name = "Unholy Blight", color = colors.TEAL, duration = 20, init = function(self)self.duration = 20 + Glyph(63332)*10 end })
AddSpell({ 47805 },{ name = "Chains of Ice", color = colors.FROZEN, duration = 10 })
AddSpell({ 47476 },{ name = "Strangulate", duration = 5 })
AddSpell({ 48792 },{ name = "Icebound Fortitude", duration = 12, init = function(self)self.duration = 12 + Talent(50187)*2 end })
AddSpell({ 49016 },{ name = "Hysteria", duration = 30 })
AddSpell({ 51209 },{ name = "Hungering Cold", duration = 10, color = colors.FROZEN, multiTarget = true })
AddSpell({ 57330,57623 },{ name = "Horn of Winter", duration = 120, shout = true, color = colors.CURSE, multiTarget = true, short = "Horn", init = function(self)self.duration = 120 + Glyph(58680)*60 end })

AddSpell({ 51124 },{ name = "Killing Machine", duration = 30 })
AddSpell({ 59052 },{ name = "Freezing Fog", duration = 15 })
end ]]



if class == "MAGE" then
AddSpell({ 37424 },{ name = "Improved Mana Shield",duration = 15, target = "player", color = colors.LRED }) -- t3.5 4pc proc
AddSpell({ 37443 },{ name = "Crit Bonus Damage",duration = 6, target = "player", color = colors.LRED }) -- t5 4pc proc


-- BUFFS

AddSpell({ 12472 },{ name = "Icy Veins",duration = 20 })
AddSpell({ 47000, 46989 },{ name = "Improved Blink",duration = 4 })
AddSpell({ 130 },{ name = "Slow Fall",duration = 30 })
AddSpell({ 31643 },{ name = "Blazing Speed",duration = 8 })
AddSpell({ 12042 },{ name = "Arcane Power",duration = 15, short = "APwr" })
AddSpell({ 44401 },{ name = "Missile Barrage",duration = 15, color = colors.LRED, short = "Missiles!" })
AddSpell({ 48108 },{ name = "Hot Streak",duration = 10, color = colors.LRED, short = "Pyro!" })
AddSpell({ 57761 },{ name = "Brain Freeze",duration = 15, color = colors.LRED, short = "Fireball!" })
AddSpell({ 543,8457,8458,10223,10225,27128 },{ name = "Fire Ward",duration = 30, color = colors.LRED })
AddSpell({ 6143,8461,8462,10177,28609,32796 },{ name = "Frost Ward",duration = 30, color = colors.LRED })
AddSpell({ 11426,13031,13032,13033,27134,33405,43038,43039,45740 },{ name = "Ice Barrier",duration = 60, color = colors.LGREEN })
AddSpell({ 1463,8494,8495,10191,10192,10193,27131 },{ name = "Mana Shield",duration = 60, color = colors.LGREEN })
AddSpell({ 1008,8455,10169,10170,27130,33946 },{ name = "Amplify Magic",duration = 600, color = colors.TEAL })
AddSpell({ 604,8450,8451,10173,10174,33944 },{ name = "Dampen Magic",duration = 600, color = colors.TEAL })

AddSpell({ 23028,27127 },{ name = "Arcane Brilliance",duration = 3600, color = colors.TEAL })
AddSpell({ 1459,1460,1461,10156,10157,27126 },{ name = "Arcane Intellect",duration = 1800, color = colors.TEAL })
AddSpell({ 168,7300,7301 },{ name = "Frost Armor",duration = 1800, color = colors.TEAL })
AddSpell({ 7302, 7320,10219,10220,27124 },{ name = "Ice Armor",duration = 1800, color = colors.TEAL })
AddSpell({ 6117, 22782,22783,27125 },{ name = "Mage Armor",duration = 1800, color = colors.TEAL })
AddSpell({ 30482 },{ name = "Molten Armor",duration = 1800, color = colors.TEAL })
AddSpell({ 66 },{ name = "Fading",duration = 6 })
AddSpell({ 32612 },{ name = "Invisibility",duration = 20 })
AddSpell({ 36032 },{ name = "Arcane Blast",duration = 8, color = colors.RED })
--~ AddSpell({ 55342 },{ name = "Mirror Image",duration = 30 })
AddSpell({ 45438 },{ name = "Ice Block",duration = 10 })
AddSpell({ 31687 },{ name = "Water Elemental",duration = 45 })
AddSpell({ 12536 },{ name = "Clearcast",duration = 15, color = colors.PURPLE })
--~ AddSpell({ 54741 },{ name = "Firestarter",duration = 10 })
-- DEBUFFS
AddSpell({ 22959 },{ name = "Improved Scorch",duration = 30, recast_mark = 2.5, color = colors.RED, short = "Scorch" })
AddSpell({ 12654 },{ name = "Ignite",duration = 4, color = colors.RED })
AddSpell({ 44457,55359,55360 },{ name = "Living Bomb",duration = 12, color = colors.ORANGE, short = "Bomb" })
AddSpell({ 31589 },{ name = "Slow", duration = 15, pvpduration = 10 })
AddSpell({ 122,865,6131,10230,27088,42917 },{ name = "Frost Nova",duration = 8, short = "FrNova", color = colors.FROZEN, multiTarget = true })
AddSpell({ 12494 },{ name = "Frostbite",duration = 5, color = colors.FROZEN })
AddSpell({ 33395 },{ name = "Freeze",duration = 8, color = colors.FROZEN })
--~ AddSpell({ 12579 },{ name = "Winter's Chill",duration = 15, short = "WChill", maxtimers = 0 }) -- ignored if applied on nontargeted units
AddSpell({ 44544 },{ name = "Fingers of Frost",duration = 15, color = colors.FROZEN, short = "FoF" })
AddSpell({ 55080 },{ name = "Shattered Barrier",duration = 8, color = colors.FROZEN, short = "Shattered" })
AddSpell({ 44572 },{ name = "Deep Freeze",duration = 5 })
AddSpell({ 18469 },{ name = "Silenced",duration = 2, color = colors.PINK }) -- imp CS
AddSpell({ 55021 },{ name = "Silenced",duration = 4, color = colors.PINK }) -- imp CS
---
AddSpell({ 118 },{ name = "Polymorph", duration = 20, color = colors.LGREEN, pvpduration = 10, short = "Poly" })
AddSpell({ 12824 },{ name = "Polymorph", duration = 30, color = colors.LGREEN, pvpduration = 10, short = "Poly" })
AddSpell({ 12825 },{ name = "Polymorph", duration = 40, color = colors.LGREEN, pvpduration = 10, short = "Poly" })
AddSpell({ 61305,28272,61721,12826,61025,61780,28271 },{ name = "Polymorph", duration = 50, color = colors.LGREEN, pvpduration = 10, short = "Poly" })
AddSpell({ 12355 },{ name = "Impact", duration = 2, color = colors.LGREEN })
--AOE
AddSpell({ 120,8492,10159,10160,10161,27087,42930,42931 },{ name = "Cone of Cold", duration = 8, color = colors.CHILL, short = "CoC", multiTarget = true })
AddSpell({ 2120,2121,8422,8423,10215,10216,27086,42925,42926 },{ name = "Flamestrike", duration = 8, multiTarget = true })
AddSpell({ 11113,13018,13019,13020,13021,27133,33933,42944,42945,44920 },{ name = "Blast Wave", color = colors.CHILL, duration = 6, multiTarget = true })
AddSpell({ 31661,33041,33042,33043,42949,42950 },{ name = "Dragon's Breath", duration = 3, color = colors.ORANGE, short = "Breath", multiTarget = true })

--~ AddCooldown( 2136, { name = "Fire Blast", color = colors.LRED})
end

if class == "PALADIN" then
AddSpell({ 37189 },{ name = "Recuced Holy Light Cast Time",duration = 10, target = "player", color = colors.LRED }) -- t5 Holy 4pc proc
AddSpell({ 37191 },{ name = "Holy Shield Block Value",duration = 6, target = "player", color = colors.LRED }) -- t5 Prot 4pc proc

AddSpell({ 34510 },{ name = "Stun", color = { 1, 0.3, 0.6 }, duration = 4 }) -- Stormherald/Deep thunder stun
AddSpell({ 20184 },{ name = "JoJustice",duration = 20, color = colors.CHILL })
--~ AddSpell({ 20185 },{ name = "JoLight",duration = 20, color = colors.PINK })
--~ AddSpell({ 20186 },{ name = "JoWisdom",duration = 20, color = colors.LBLUE })
AddSpell({ 31884 },{ name = "Avenging Wrath",duration = 20, short = "AW" })
AddSpell({ 498 },{ name = "Divine Protection",duration = 6, short = "DProt" })
AddSpell({ 5573 },{ name = "Divine Protection",duration = 8, short = "DProt" })
AddSpell({ 642 },{ name = "Divine Shield",duration = 10, short = "DShield" })
AddSpell({ 1020 },{ name = "Divine Shield",duration = 12, short = "DShield" })
AddSpell({ 1022, 5599, 10278 },{ name = "Blessing of Protection",duration = 6, short = "HoProt" })
AddSpell({ 1044 },{ name = "Blessing of Freedom",duration = 10, init = function(self)self.duration = 10 + Talent(20174)*2 end, short = "Freedom" })
AddSpell({ 6940, 20729, 27147, 27148 },{ name = "Blessing of Sacrifice",duration = 30 })
AddSpell({ 19977, 19978, 19979, 27144  },{ name = "Blessing of Light",duration = 600, color = colors.TEAL, short = "BoL" })
AddSpell({ 19740, 19834, 19835, 19836, 19837, 19838, 25291, 27140  },{ name = "Blessing of Might",duration = 600, color = colors.TEAL, short = "BoM" })
AddSpell({ 1038 },{ name = "Blessing of Salvation",duration = 600, color = colors.TEAL, short = "BoS" })
AddSpell({ 19742, 19850, 19852, 19853, 19854, 25290, 27142 },{ name = "Blessing of Wisdom",duration = 600, color = colors.TEAL, short = "BoW" })
AddSpell({ 25780 },{ name = "Righteous Fury",duration = 600, color = colors.TEAL, short = "RFury" })
AddSpell({ 20217 },{ name = "Blessing of Kings",duration = 600, color = colors.TEAL, short = "BoK" })
AddSpell({ 20911, 20912, 20913, 20914, 27168 },{ name = "Blessing of Sanctuary",duration = 600, color = colors.TEAL, short = "BoSan" })
AddSpell({ 25898 },{ name = "Greater Blessing of Kings",duration = 1800, color = colors.TEAL, short = "GBoK" })
AddSpell({ 25890, 27145 },{ name = "Greater Blessing of Light",duration = 1800, color = colors.TEAL, short = "GBoL" })
AddSpell({ 25782, 25916, 27141 },{ name = "Greater Blessing of Might",duration = 1800, color = colors.TEAL, short = "GBoM" })
AddSpell({ 25895 },{ name = "Greater Blessing of Salvation",duration = 1800, color = colors.TEAL, short = "GBoS" })
AddSpell({ 25899, 27169 },{ name = "Greater Blessing of Sanctuary",duration = 1800, color = colors.TEAL, short = "GBoSan" })
AddSpell({ 25894, 25918, 27143 },{ name = "Greater Blessing of Wisdom",duration = 1800, color = colors.TEAL, short = "GBoW" })
AddSpell({ 10326 },{ name = "Turn Evil",duration = 20, pvpduration = 10, color = colors.LGREEN })
AddSpell({ 2878, 5627 },{ name = "Turn Undead",duration = 20, color = colors.LGREEN })
--AddSpell({ 20925,20927,20928,27179,48951,48952 },{ name = "Holy Shield",duration = 10, color = colors.RED })
AddSpell({ 53563 },{ name = "Beacon of Light",duration = 60, short = "Beacon",color = colors.RED })
AddSpell({ 54428 },{ name = "Divine Plea",duration = 15, short = "Plea" })
AddSpell({ 53601 },{ name = "Sacred Shield",duration = 30 })
AddSpell({ 31834 },{ name = "Light's Grace",duration = 15 })
AddSpell({ 20178 },{ name = "Reckoning",duration = 8 })
AddSpell({ 20050, 20052, 20053 },{ name = "Vengeance",duration = 30 })
AddSpell({ 20128 },{ name = "Redoubt",duration = 10 })
AddSpell({ 31892 },{ name = "Seal of Blood",duration = 30, color = colors.YELLOW })
AddSpell({ 348704 },{ name = "Seal of Corruption",duration = 30, color = colors.YELLOW })
AddSpell({ 20164, 31895 },{ name = "Seal of Justice",duration = 30, color = colors.YELLOW })
AddSpell({ 20165, 20347, 20348, 20349, 27160 },{ name = "Seal of Light",duration = 30, color = colors.YELLOW })
AddSpell({ 20154, 21084, 20287, 20288, 20289, 20290, 20291, 20292, 20293, 27155 },{ name = "Seal of Righteousness",duration = 30, color = colors.YELLOW })
AddSpell({ 21082, 20162, 20305, 20306, 20307, 20308, 27158 },{ name = "Seal of the Crusader",duration = 30, color = colors.YELLOW })
AddSpell({ 348700, 348701 },{ name = "Seal of the Martyr",duration = 30, color = colors.YELLOW })
AddSpell({ 31801 },{ name = "Seal of Vengeance",duration = 30, color = colors.YELLOW })
AddSpell({ 20166, 20356, 20357, 27166 },{ name = "Seal of Wisdom",duration = 30, color = colors.YELLOW })
AddSpell({ 20375, 20915, 20918, 20919, 20920, 27170 },{ name = "Seal of Command",duration = 30, color = colors.YELLOW })
AddSpell({ 31842 },{ name = "Divine Illumination",duration = 15, short = "Illum" })
AddSpell({ 53489,59578 },{ name = "The Art of War",duration = 15, short = "TAoW" })
AddSpell({ 20066 },{ name = "Repentance",duration = 6, short = "Repent"  })
AddSpell({ 853 },{ name = "Hammer of Justice",duration = 3, short = "HoJ", color = colors.FROZEN })
AddSpell({ 5588 },{ name = "Hammer of Justice",duration = 4, short = "HoJ", color = colors.FROZEN })
AddSpell({ 5589 },{ name = "Hammer of Justice",duration = 5, short = "HoJ", color = colors.FROZEN })
AddSpell({ 10308 },{ name = "Hammer of Justice",duration = 6, short = "HoJ", color = colors.FROZEN })
AddSpell({ 31803 },{ name = "Holy Vengeance",duration = 15, color = colors.RED})
AddSpell({ 356110 },{ name = "Blood Corruption",duration = 15, color = colors.RED})
AddSpell({ 67, 26017, 26018 },{ name = "Vindication",duration = 15, color = colors.RED})


AddCooldown( 20925 ,{ name = "Holy Shield", color = colors.RED })
AddCooldown( 24275 ,{ name = "HoW", color = colors.TEAL })
AddCooldown( 879 ,{ name = "Exorcism", color = colors.ORANGE })
AddCooldown( 20271 ,{ name = "Judgement", color = colors.LRED })
AddCooldown( 26573 ,{ name = "Consecration", color = colors.CURSE })

AddCooldown( 35395 ,{ name = "Crusader Strike", color = colors.RED })
AddCooldown( 53385 ,{ name = "Divine Storm", color = colors.PURPLE })

AddCooldown( 53595 ,{ name = "HotR", color = colors.RED })
AddCooldown( 53600 ,{ name = "SoR", color = colors.PURPLE })


end

if class == "DRUID" then
AddSpell({ 774,1058,1430,2090,2091,3627,8910,9839,9840,9841,25299,26981,26982,48440,48441 },{ name = "Rejuvenation",duration = 15, color = { 1, 0.2, 1}, init = function(self)self.duration = 15 + Talent(57865)*3 end })
AddSpell({ 8936,8938,8939,8940,8941,9750,9856,9857,9858,26980,48442,48443 },{ name = "Regrowth",duration = 21, color = { 198/255, 233/255, 80/255}, init = function(self)self.duration = 21 + Talent(57865)*6 end })
AddSpell({ 33763,48450,48451 },{ name = "Lifebloom", duration = 7, init = function(self)self.duration = 7 + Talent(57865)*2 end })
AddSpell({ 2893 },{ name = "Abolish Poison", duration = 8 })
AddSpell({ 5229 },{ name = "Enrage", duration = 10 })
AddSpell({ 48438,53248,53249,53251 },{ name = "Wild Growth", duration = 7, multiTarget = true, color = colors.LGREEN })
AddSpell({ 29166 },{ name = "Innervate",duration = 10 })

AddSpell({ 22812 },{ name = "Barkskin",duration = 12 })
-- AddSpell({ 52610 },{ name = "Savage Roar",duration = function() return (9 + NugRunning.cpWas * 5) end })
AddSpell({ 1850,9821,33357 },{ name = "Dash", duration = 15 })

--~ AddSpell({ 48391 },{ name = "Owlkin Frenzy", duration = 10 })
-- AddSpell({ 48517 },{ name = "Solar Eclipse", duration = 15, short = "Solar", color = colors.ORANGE }) -- Wrath boost
-- AddSpell({ 48518 },{ name = "Lunar Eclipse", duration = 15, short = "Lunar", color = colors.FROZEN }) -- Starfire boost
AddSpell({ 50334 },{ name = "Berserk", duration = 15 })
AddSpell({ 16870 },{ name = "Clearcasting", duration = 15 })

AddSpell({ 8921,8924,8925,8926,8927,8928,8929,9833,9834,9835,26987,26988,48462,48463 },{ name = "Moonfire",duration = 9, color = colors.PURPLE, init = function(self)self.duration = 9 + Talent(57865)*3 end })
AddSpell({ 5570,24974,24975,24976,24977,27013,48468 },{ name = "Insect Swarm",duration = 12, color = colors.RED, init = function(self)self.duration = 12 + Talent(57865)*2 end })
AddSpell({ 339,1062,5195,5196,9852,9853,26989,53308 },{ name = "Entangling Roots",duration = 27 })

AddSpell({ 33786 },{ name = "Cyclone", duration = 6 })
AddSpell({ 770,16857 },{ name = "Faerie Fire",duration = 300,pvpduration = 40, color = colors.CURSE }) --second is feral
AddSpell({ 99,1735,9490,9747,9898,26998,48559,48560 },{ name = "Demoralizing Roar", short = "DemoRoar", color = {0.3, 0.9, 0.3}, duration = 30, multiTarget = true })
AddSpell({ 6795 },{ name = "Growl", duration = 3 })
AddSpell({ 16979 },{ name = "Feral Charge",duration = 4 })
AddSpell({ 1079,9492,9493,9752,9894,9896,27008,49799,49800 },{ name = "Rip",duration = 12, color = colors.RED, init = function(self)self.duration = 12 + Glyph(54818)*4 end })
AddSpell({ 5209 },{ name = "Challenging Roar", duration = 6, multiTarget = true })
AddSpell({ 5211 },{ name = "Bash",duration = 2, init = function(self)self.duration = 2 + Talent(16940)*0.5 end })
AddSpell({ 6798 },{ name = "Bash",duration = 3, init = function(self)self.duration = 3 + Talent(16940)*0.5 end })
AddSpell({ 8983 },{ name = "Bash",duration = 4, init = function(self)self.duration = 4 + Talent(16940)*0.5 end })
AddSpell({ 9005,9823,9827,27006,49803 },{ name = "Pounce", duration = 3, color = colors.PINK, init = function(self)self.duration = 3 + Talent(16940)*0.5 end })
AddSpell({ 9007,9824,9826,27007,49804 },{ name = "Pounce Bleed", duration = 18 })
AddSpell({ 1822,1823,1824,9904,27003,48573,48574 },{ name = "Rake", duration = 9, color = colors.PURPLE })
AddSpell({ 33878,33986,33987,48563,48564 },{ name = "Mangle", duration = 60 })
AddSpell({ 33876,33982,33983,48565,48566 },{ name = "Mangle", duration = 60 })
AddSpell({ 22570,49802 },{ name = "Maim", duration = function() return NugRunning.cpWas end })
AddSpell({ 33745,48567,48568 },{ name = "Lacerate", duration = 15, color = colors.RED })

AddSpell({ 2637 },{ name = "Hibernate",duration = 20 })
AddSpell({ 18657 },{ name = "Hibernate",duration = 30 })
AddSpell({ 18658 },{ name = "Hibernate",duration = 40, pvpduration = 10 })

AddCooldown(6793,  { name = "Tiger's Fury", color = colors.FROZEN})

end

if class == "HUNTER" then
AddSpell({ 37483 },{ name = "Improved Kill Command",duration = 15, target = "player", color = colors.LRED }) -- t3.5 4pc proc


AddSpell({ 56453 },{ name = "Lock and Load", duration = 12, color = colors.LRED })
AddSpell({ 19574 },{ name = "Bestial Wrath", duration = 18, color = colors.LRED })

AddSpell({ 136,3111,3661,3662,13542,13543,13544,27046,48989,48990,43350 },{ name = "Mend Pet", duration = 15, color = colors.LGREEN })

AddSpell({ 2974 },{ name = "Wing Clip", duration = 10, color = { 192/255, 77/255, 48/255} })
AddSpell({ 19306,20909,20910,27067,48998,48999 },{ name = "Counterattack", duration = 5, color = { 192/255, 77/255, 48/255} })
AddSpell({ 13797,14298,14299,14300,14301,27024,49053,49054 },{ name = "Immolation Trap", duration = 15, color = colors.ORANGE, init = function(self)self.duration = 15 - Glyph(56846)*6 end })
AddSpell({ 1978,13549,13550,13551,13552,13553,13554,13555,25295,27016,49000,49001 },{ name = "Serpent Sting", duration = 15, color = colors.PURPLE })
AddSpell({ 3034 },{ name = "Viper Sting", duration = 8, color = colors.LBLUE })
AddSpell({ 19503 },{ name = "Scatter Shot", duration = 4, color = colors.CHILL })
AddSpell({ 5116 },{ name = "Concussive Shot", duration = 4, color = colors.CHILL, init = function(self)self.duration = 4 + Talent(19407) end })
AddSpell({ 34490 },{ name = "Silencing Shot", duration = 3, color = colors.PINK, short = "Silence" })

AddSpell({ 53359 },{ name = "Disarmed", duration = 10, color = colors.RED }) --Chimera Shot - Scorpid
AddSpell({ 24394 },{ name = "Intimidation", duration = 3, color = colors.RED })
AddSpell({ 19386,24132,24133,27068,49011,49012 },{ name = "Wyvern Sting", duration = 8, short = "Wyvern",color = colors.RED })


AddSpell({ 3355 },{ name = "Freezing Trap", duration = 10, pvpduration = 10, color = colors.FROZEN, init = function(self)self.duration = 10 * (1+Talent(19376)*0.1) end })
AddSpell({ 14308 },{ name = "Freezing Trap", duration = 15, pvpduration = 10, color = colors.FROZEN, init = function(self)self.duration = 15 * (1+Talent(19376)*0.1) end })
AddSpell({ 14309 },{ name = "Freezing Trap", duration = 20, pvpduration = 10, color = colors.FROZEN, init = function(self)self.duration = 20 * (1+Talent(19376)*0.1) end })

AddSpell({ 1513 },{ name = "Scare Beast", duration = 10, pvpduration = 10, color = colors.CURSE })
AddSpell({ 14326 },{ name = "Scare Beast", duration = 15, pvpduration = 10, color = colors.CURSE })
AddSpell({ 14327 },{ name = "Scare Beast", duration = 20, pvpduration = 10, color = colors.CURSE })

AddCooldown( 53209 ,{ name = "Chimera Shot", color = colors.RED })
AddCooldown( 19434 ,{ name = "Aimed Shot", color = colors.LBLUE })
--AddCooldown( 2643 ,{ name = "Multi-Shot", color = colors.LBLUE })
AddCooldown( 3044 ,{ name = "Arcane Shot", color = colors.RED })
AddCooldown( 53301 ,{ name = "Explosive Shot", color = colors.RED })
AddCooldown( 3674 ,{ name = "Black Arrow", color = colors.CURSE })
end

if class == "SHAMAN" then
AddSpell({ 37227 },{ name = "Improved Healing Wave",duration = 10, target = "player", color = colors.LRED }) -- t5 Resto 4pc proc
AddSpell({ 38432 },{ name = "Stormstrike AP Buff",duration = 12, target = "player", color = colors.LRED }) -- t6 Enha 4pc proc


--~ AddSpell({ 8042,8044,8045,8046,10412,10413,10414,25454,49230,49231 },{ name = "Earth Shock", duration = 8, color = colors.ORANGE, short = "ErS" })
AddSpell({ 8056,8058,10472,10473,25464,49235,49236 },{ name = "Frost Shock", duration = 8, color = colors.CHILL, short = "FrS" })
AddSpell({ 8050,8052,8053,10447,10448,29228,25457,49232,49233 },{ name = "Flame Shock", duration = 18, color = colors.RED, short = "FlS" })


AddSpell({ 53817 },{ name = "Maelstrom Weapon", duration = 12, color = colors.PURPLE, short = "Maelstrom" })

AddCooldown( 17364 ,{ name = "Stormstrike", color = colors.CURSE, short = "SS" })
AddCooldown( 8042 ,{ name = "Shock", color = colors.LRED })
AddCooldown( 8056 ,{ name = "Shock", color = colors.LRED })
AddCooldown( 8050 ,{ name = "Shock", color = colors.LRED })
AddCooldown( 60103 ,{ name = "Lava Lash", color = colors.RED })
AddCooldown( 51505 ,{ name = "Lava Burst", color = colors.RED })

end