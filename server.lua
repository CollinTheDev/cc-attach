RegisterServerEvent('fivem_attach:attachToCall')
AddEventHandler('fivem_attach:attachToCall', function(callId)
    local _source = source
    print("Server event received with call ID:", callId, "and source:", _source)

    local discordId = GetDiscordId(_source)
    
    if discordId == nil then
        TriggerClientEvent('chat:addMessage', _source, { args = { '^1SYSTEM', 'Could not find your Discord ID.' } })
        print("Could not find Discord ID for player with source:", _source)
        return
    end

    print("Discord ID found:", discordId)

    -- Make the API request
    AttachToCall(callId, discordId, _source)
end)

-- Function to get the Discord ID of a player
function GetDiscordId(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.match(identifier, "discord:") then
            return string.sub(identifier, 9)
        end
    end
    return nil
end

-- Function to make the API request
function AttachToCall(callId, discordId, playerId)
    local url = Config.ApiUrl
    local apiKey = Config.ApiKey
    local data = {
        call_id = callId,
        user_id = discordId
    }

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            TriggerClientEvent('chat:addMessage', playerId, { args = { '^2SYSTEM', 'You have been successfully attached to the call.' } })
        else
            TriggerClientEvent('chat:addMessage', playerId, { args = { '^1SYSTEM', 'Failed to attach to the call. Please try again.' } })
        end
    end, 'POST', json.encode(data), { ["Content-Type"] = 'application/json', ["Authorization"] = "Bearer " .. apiKey, ['token'] = Config.ApiKey })
end
