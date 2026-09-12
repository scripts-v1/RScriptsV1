assert(replicatesignal, "Missing critical function! Function: replicatesignal")

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local TextChannels = TextChatService:FindFirstChild("TextChannels")
local RBXGeneral = TextChannels:FindFirstChild("RBXGeneral")
local LocalPlayerSource = RBXGeneral[Player.Name]

local Methods = {}

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


        return msgId, metadata
end


function Methods:EditLocalPlayerMessage(txt, messageID, metadata)

        if not string.find(messageID, tostring(Player.UserId)) then
                warn("Invalid message / Not your message")
                return
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

        return messageID
end

function Methods:GetLocalPlayerMessages()
        return LocalPlayerMessages
end


return Methods
