function RunDid(rawArgs, editbox)
    local args = { strsplit(" ", rawArgs) }
    for i = 1, #args do
        arg = args[i]

        local completed = C_QuestLog.IsQuestFlaggedCompleted(arg)
        if completed then
            print("Did: You HAVE completed Quest ID " .. arg .. ".")
        else
            print("Did: You HAVE NOT completed Quest ID " .. arg .. ".")
        end
    end
end

SLASH_DID1 = '/did'
SlashCmdList["DID"] = RunDid
