local function loadMessageEdit(toastEnabled, getgenvSavingEnabled)

assert(replicatesignal, "Missing critical function! Function: replicatesignal")

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local TextChannels = TextChatService:FindFirstChild("TextChannels")
local RBXGeneral = TextChannels:FindFirstChild("RBXGeneral")
local LocalPlayerSource = RBXGeneral[Player.Name]



local Methods = {
        ["UseNotificationsV1"] = toastEnabled,
        ["SaveAsChatV1"] = getgenvSavingEnabled
}


local function notify(txt, content)
        if Methods.UseNotificationsV1 then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts-v1/AstraV1/refs/heads/main/GUI/NotifyToastV1.luau"))()
                getgenv().NotifyToast({title = txt, content = content})

        end
end



local Signals = {
        TextChatService.ClientToServerMessageReplicateSignalV2
}

local LocalPlayerMessages = {}

TextChatService.MessageReceived:Connect(function(msg)
        if string.find(msg.MessageId, tostring(Player.UserId)) then
                table.insert(LocalPlayerMessages, msg)
        end
end)


function Methods:GenerateMessageID()
        return string.format("%s-%s", Player.UserId, HttpService:GenerateGUID())
end


function Methods:SendMessage(txt, metadata)

        local msgId = Methods:GenerateMessageID()

        metadata = metadata or ""

        replicatesignal(
                Signals[1],
                txt,
                metadata,
                msgId,
                LocalPlayerSource,
                RBXGeneral      
        )

        notify("Astra API", "Message sent!")
        return msgId, metadata
end


function Methods:EditLocalPlayerMessage(txt, messageID, metadata)

        if not string.find(messageID, tostring(Player.UserId)) then
                notify("Message couldn't be edited", "Reason: Invalid message / Not your message")
                return "Invalid / Msg"
        end

        metadata = metadata or ""

        replicatesignal(
                Signals[1],
                txt,
                metadata,
                messageID,
                LocalPlayerSource,
                RBXGeneral      
        )

        notify("Astra API", "Message edited!")
        return messageID
end

function Methods:GetLocalPlayerMessages()
        return LocalPlayerMessages
end


if Methods["SaveAsChatV1"] then getgenv().ChatV1 = Methods end
notify("Astra ChatAPI v1 Loaded", "@dvc")

return Methods
end


return loadMessageEdit
