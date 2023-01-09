MythicPlusRatingGain = {}
local rg = MythicPlusRatingGain

SLASH_RATINGGAIN1 = "/rg"
SLASH_RATINGGAIN2 = "/ratinggain"
SlashCmdList["RATINGGAIN"] = function(msg)
    rg.ratingGain_Commands(msg)
end

function rg.ratingGain_Commands(args)
    rg.keyLevel = tonumber(strmatch(args, "^%-?%d+$"))

    if rg.keyLevel ~= nil then
        if rg.keyLevel < 2 or rg.keyLevel > 50 then
            print("M+ Rating Gain: Only supports key levels between 2 and 50")
        elseif (C_MythicPlus.GetCurrentAffixes() == nil) or (C_MythicPlus.GetCurrentAffixes()[1] == nil) then
            print("M+ Rating Gain: There is no active M+ season")
        else
            rg.ratingGain()
        end
    else
        print("M+ Rating Gain usage: /rg <key level>")
    end
end

rg.ratingGain = function()
    rg.sub10 = {
        [2] = 40,
        [3] = 45,
        [4] = 55,
        [5] = 60,
        [6] = 65,
        [7] = 75,
        [8] = 80,
        [9] = 85
    }

    rg.affix = {"Tyrannical", "Fortified",}

    rg.currentWeek = C_MythicPlus.GetCurrentAffixes()[1].id - 8

    rg.totalGain = 0

    if rg.keyLevel < 10 then
        rg.newScore = rg.sub10[rg.keyLevel]
    else
        rg.newScore = rg.keyLevel * 5 + 50 + (rg.keyLevel - 10) * 2
    end

    print("------------------------------------")

    print("Gains for +" .. rg.keyLevel .. ":")

    for k, v in ipairs(C_ChallengeMode.GetMapTable()) do
        rg.affixScores = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(v)

        local gain = rg.calcScore()

        if gain > 0 then
            print(C_ChallengeMode.GetMapUIInfo(v) .. ": " .. gain)
        end
    end

    print("Total: " .. rg.totalGain)
    print("------------------------------------\n")
end

rg.calcScore = function()
    local scores = {}
    local currIndex = 2

    if rg.affixScores ~= nil then
        if rg.affixScores[1] == nil then
            scores[1] = 0
        end
        if rg.affixScores[2] == nil then
            scores[2] = 0
        end
    else
        scores[1] = 0
        scores[2] = 0
    end

    if scores[1] ~= 0 then
        scores[1] = rg.affixScores[1].score
        if rg.affixScores[1].name == rg.affix[rg.currentWeek] then
            currIndex = 1
        end
    end
    if scores[2] ~= 0 then
        scores[2] = rg.affixScores[2].score
        if rg.affixScores[2].name == rg.affix[rg.currentWeek] then
            currIndex = 2
        end
    end

    local currentOverall = math.max(scores[1], scores[2]) * 1.5 + math.min(scores[1], scores[2]) * 0.5

    if scores[currIndex] < rg.newScore then
        scores[currIndex] = rg.newScore
    end

    local newOverall = math.max(scores[1], scores[2]) * 1.5 + math.min(scores[1], scores[2]) * 0.5

    local gain = newOverall - currentOverall

    if gain > 0 then
        rg.totalGain = rg.totalGain + gain
        return gain
    else
        return 0
    end
end
