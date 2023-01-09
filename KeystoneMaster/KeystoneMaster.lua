---------------------------------------------------------------------------------------------------
-- Tune stuff here

local function ksmColor(text, color)
    -- Lookup table for easy color tuning
    if color == "affix"     then color = "ffff88" end
    if color == "dungeon"   then color = "ffaa00" end
    if color == "error"     then color = "ff7777" end
    if color == "level"     then color = "88ff88" end
    if color == "line"      then color = "666666" end
    if color == "nogains"   then color = "ff8888" end
    if color == "number"    then color = "00ffff" end
    if color == "projected" then color = "aaaaaa" end
    if color == "total"     then color = "ffcc33" end
    if color == "totalnum"  then color = "00ffff" end
    if color == "weeknext"  then color = "ffffff" end
    if color == "weekthis"  then color = "ffffff" end

    return "\124cff" .. color .. text .. "\124r"
end

local function ksmShortName(mapName)
    if mapName == "Shadowmoon Burial Grounds"  then return "SBG" end
    if mapName == "Halls of Valor"             then return "HOV" end
    if mapName == "Court of Stars"             then return "COS" end
    if mapName == "Algeth'ar Academy"          then return "AA"  end
    if mapName == "The Nokhud Offensive"       then return "NO"  end
    if mapName == "Ruby Life Pools"            then return "RLP" end
    if mapName == "Temple of the Jade Serpent" then return "TJS" end
    if mapName == "The Azure Vault"            then return "AV"  end
    return mapName
end

---------------------------------------------------------------------------------------------------

local function ksmArrayLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function ksmNumber(s)
    if s == nil then
        return nil
    end
    return tonumber(strmatch(s, "^%-?%d+$"))
end

local function ksmSyntax()
    print("KeystoneMaster Syntax: /ksm <key level>")
end

local function ksmError(reason)
    print(ksmColor("KeystoneMaster Error: ", "error") .. reason)
end

-- Expecting two numbers
local function ksmGains(mapID, level)
    local sub10 = {
        [2] = 40,
        [3] = 45,
        [4] = 55,
        [5] = 60,
        [6] = 65,
        [7] = 75,
        [8] = 80,
        [9] = 85
    }

    -- Calculate how much one week's worth of score at the requested level would be worth
    local timedScore = 0
    if level < 10 then
        timedScore = sub10[level]
    else
        timedScore = 50 + (level * 5) + ((level - 10) * 2)
    end

    local gains = {}
    gains.name = C_ChallengeMode.GetMapUIInfo(mapID)

    local affixScores = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)

    -- Calculate a potentially better score for each weekly affix
    for weeklyIndex in ipairs(affixScores) do
        local otherIndex = 1
        if weeklyIndex == 1 then
            otherIndex = 2
        end
        local weeklyAffixName = affixScores[weeklyIndex].name
        local weeklyScore = affixScores[weeklyIndex].score
        local otherScore = affixScores[otherIndex].score
        local pumpedScore = math.max(weeklyScore, timedScore)

        local currentTotal = (math.max(weeklyScore, otherScore) * 1.5) + (math.min(weeklyScore, otherScore) * 0.5)
        local pumpedTotal = (math.max(pumpedScore, otherScore) * 1.5) + (math.min(pumpedScore, otherScore) * 0.5)
        if pumpedTotal < currentTotal then
            gains[weeklyAffixName] = 0
        else
            gains[weeklyAffixName] = pumpedTotal - currentTotal
        end
    end
    return gains
end

local function ksmKeyMode(level)
    if (level == nil) or (level < 2) or (level > 50) then
        return ksmError("Only key levels 2 - 50")
    end

    -- print(ksmColor("---------------------------------------", "line"))

    local affixNamesById = {
        [9] = "Tyrannical",
        [10] = "Fortified"
    }
    local thisWeekAffix = affixNamesById[C_MythicPlus.GetCurrentAffixes()[1].id]
    local nextWeekAffix = "Tyrannical"
    if nextWeekAffix == thisWeekAffix then
        nextWeekAffix = "Fortified"
    end

    local weeks = { thisWeekAffix, nextWeekAffix }
    local titlePrefix = ksmColor("This Week ","weekthis").."["
    for _, week in ipairs(weeks) do
        local totalGains = 0
        local gainString = ""
        for _, mapID in ipairs(C_ChallengeMode.GetMapTable()) do
            local gains = ksmGains(mapID, level)
            if gains[week] > 0 then
                if gainString ~= "" then
                    gainString = gainString .. ", "
                end
                gainString = gainString .. ksmColor(ksmShortName(gains.name), "dungeon") .. ": " .. ksmColor(gains[week], "number")
                totalGains = totalGains + gains[week]
            end
        end

        local prefixString = titlePrefix .. ksmColor(week, "affix").."+"..ksmColor(level, "level").."] - "
        if totalGains > 0 then
            local projectedTotal = C_ChallengeMode.GetOverallDungeonScore() + totalGains
            print(prefixString .. gainString .. ", "..ksmColor("Total", "total")..": " .. ksmColor(totalGains, "totalnum") .. ksmColor(" ("..projectedTotal..")", "projected"))
        else
            print(prefixString .. ksmColor("No Gains", "nogains"))
        end

        titlePrefix = ksmColor("Next Week ","weeknext").."["
    end
end

local function ksmMain(args)
    -- Bail out early if there's no active season
    if (C_MythicPlus.GetCurrentAffixes() == nil) or (C_MythicPlus.GetCurrentAffixes()[1] == nil) then
        return ksmError("There is no active M+ season.")
    end

    -- Turn args into argc/argv
    local argv = { strsplit(" ", args) }
    local argc = ksmArrayLength(argv)
    -- print("argc: " .. argc)
    -- for i,v in ipairs(argv) do
    --     print("ARGV["..i.."]: '"..v.."'")
    -- end

    -- Parse args
    local mode = argv[1]
    if mode == "key" then
        local level = ksmNumber(argv[2])
        ksmKeyMode(level)
    elseif mode == "" then
        ksmSyntax()
    else
        local level = ksmNumber(argv[1])
        if level == nil then
            return ksmError("Unknown mode: " .. mode)
        end
        ksmKeyMode(level)
    end
end

SLASH_KEYSTONEMASTER1 = "/ksm"
SLASH_KEYSTONEMASTER2 = "/keystonemaster"
SlashCmdList["KEYSTONEMASTER"] = function(msg)
    ksmMain(msg)
end
