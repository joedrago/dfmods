function MakeFartSound()
    soundFilename = string.format("Interface\\AddOns\\Farty\\Sounds\\fart%d.mp3", random(0, 4))
    PlaySoundFile(soundFilename, "SFX")
end

function onEmote(self, event, msg)
    if msg:find(" fart ") or msg:find(" farts ") then
        MakeFartSound()
    end
    return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", onEmote)

function FartyDebug(msg, editbox)
    print("Farty Debug: making fart sound")
    MakeFartSound()
end

SLASH_FARTY1 = '/farty'
SlashCmdList["FARTY"] = FartyDebug
