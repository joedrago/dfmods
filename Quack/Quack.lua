function MakeQuackSound()
    PlaySoundFile("Interface\\AddOns\\Quack\\Sounds\\quack.mp3", "SFX")
end

function onEmoteQuack(self, event, msg)
    if msg:find(" has died.") or msg:find("You died.") then
        MakeQuackSound()
    end
    return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", onEmoteQuack)

function QuackDebug(msg, editbox)
    print("Quack Debug: making quack sound")
    MakeQuackSound()
end

SLASH_QUACK1 = '/quack'
SlashCmdList["QUACK"] = QuackDebug
