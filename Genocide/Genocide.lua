local GetBattlefieldScore = GetBattlefieldScore
local GetNumBattlefieldScores = GetNumBattlefieldScores

function output(destination, msg)
    if destination == nil then
        print(msg)
    else
        SendChatMessage(msg, destination)
    end
end

function RunGenocide(rawArgs, editbox)
    local destination = nil
    local args = { strsplit(" ", rawArgs) }
    local filters = {}
    local showNames = false
    for i = 1, #args do
        arg = args[i]
        if (arg == 'p') or (arg == 'party') then
            destination = "PARTY"
        elseif (arg == 'i') or (arg == 'instance') then
            destination = "INSTANCE"
        elseif (arg == 'n') or (arg == 'name')  or (arg == 'names') then
            showNames = true
        elseif strlen(arg) > 0 then
            table.insert(filters, arg)
        end
    end

    local raceCounts = {}

    -- raceCounts["Tauren"] = 4
    -- raceCounts["Highmountain Tauren"] = 5
    -- raceCounts["Blood Elf"] = 7
    -- raceCounts["Undead"] = 9

    local battlefieldScoresCount = GetNumBattlefieldScores()
    if battlefieldScoresCount > 0 then
        for index = 1, GetNumBattlefieldScores() do
            local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(index)
            if name and race then
                if not raceCounts[race] then
                    raceCounts[race] = 0
                end
                raceCounts[race] = raceCounts[race] + 1
                -- print(name .. ": " .. race )
            end
        end

        local printedOne = false
        for raceName,raceCount in pairs(raceCounts) do
            local showRace = false
            if #filters > 0 then
                local lowercaseRaceName = strlower(raceName)
                for filterIndex = 1, #filters do
                    filter = filters[filterIndex]
                    if string.match(lowercaseRaceName, filter) then
                        showRace = true
                    end
                end
            else
                showRace = true
            end

            if showRace then
                if not printedOne then
                    output(destination, "Genocide:")
                end
                printedOne = true
                output(destination, "* " .. raceName .. ": " .. raceCount)

                if showNames then
                    for index = 1, GetNumBattlefieldScores() do
                        local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(index)
                        if race == raceName then
                            name = gsub(name, "%-[^|]+", "")
                            output(destination, "  * [" .. class .. "] " .. name)
                        end
                    end
                end
            end
        end

        if not printedOne then
            output(nil, "Genocide Error: No races matched your filter.")
        end
    else
        output(nil, "Genocide Error: You're not in a battleground.")
    end
end

SLASH_GENOCIDE1 = '/genocide'
SLASH_GENOCIDE2 = '/gen'
SlashCmdList["GENOCIDE"] = RunGenocide
