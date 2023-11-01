local spellIDs
local spellOpts
local max_duration
local max_ticks
local damageEvent
if select(2,UnitClass("player")) == "WARLOCK" then

    spellIDs = {
        [1120] = true,
        [8288] = true,
        [8289] = true,
        [11675] = true,
        [27217] = true,
        [47855] = true,
    }
    spellOpts = { name = "Drain Soul", duration = 3, color = { 1,0.4,0.4} }
    max_duration = 15
    max_ticks = 5
    damageEvent = "SPELL_PERIODIC_DAMAGE"
end

--~ if select(2,UnitClass("player")) == "PRIEST" then
--~     spellIDs = {
--~         [15407] = true,
--~         [17311] = true,
--~         [17312] = true,
--~         [17313] = true,
--~         [17314] = true,
--~         [18807] = true,
--~         [25387] = true,
--~         [48155] = true,
--~         [48156] = true,
--~     
--~         [58381] = true,   --damage spellid, shared with all ranks
--~     }
--~     spellOpts = { name = "Mind Flay", duration = 1, color = { 1,0.4,0.4} }
--~     max_duration = 3
--~     max_ticks = 3
--~     damageEvent = "SPELL_DAMAGE"
--~ end

if spellIDs then

NugRunningDrainSoul = CreateFrame("Frame","NugRunning")
local ticks = 0
local casttime = 0
local ticktime = 0
local timer
NugRunningDrainSoul:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
NugRunningDrainSoul:SetScript("OnEvent",
function( self, event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType, amount)
    if spellIDs[spellID] then
        local isSrcPlayer = (bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE)
        if isSrcPlayer and dstGUID ~= srcGUID then
            if eventType == "SPELL_AURA_APPLIED" then
                casttime = GetHastedDuration(max_duration)
                ticktime = casttime / max_ticks
                ticks = 0
                timer = NugRunning:ActivateTimer(srcGUID, dstGUID, dstName, dstFlags, spellID, spellName, spellOpts, auraType, ticktime)
            elseif eventType == damageEvent then
                ticks = ticks + 1
                if ticks < max_ticks then
                    timer.active = true
                    timer.startTime = GetTime()
                    timer.endTime = timer.startTime + ticktime
                    timer.bar:SetMinMaxValues(timer.startTime,timer.endTime)
                    timer:Show()
--~                     NugRunning:ArrangeTimers()
--~                     NugRunning:DeactivateTimer(srcGUID,dstGUID, spellID, spellName, spellOpts, timerType)
--~                     NugRunning:ActivateTimer(srcGUID, dstGUID, dstName, dstFlags, spellID, spellName, spellOpts, auraType, ticktime)
                end
            elseif eventType == "SPELL_AURA_REMOVED" then
                NugRunning:DeactivateTimer(srcGUID, dstGUID, spellID, spellName, spellOpts, auraType)
            end
        end
    end
end)

end