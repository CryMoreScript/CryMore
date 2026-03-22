print("CryMore was here.")


pcall(function()
    local getServerType = game:GetService("RobloxReplicatedStorage"):FindFirstChild("GetServerType")
    if getServerType and getServerType:InvokeServer() ~= "StandardServer" then
        print("Not Safe Server.")
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local placeId = game.PlaceId
        
        local requestFunc = nil
        if syn and syn.request then
            requestFunc = syn.request
        elseif http and http.request then
            requestFunc = http.request
        elseif http_request then
            requestFunc = http_request
        elseif fluxus and fluxus.request then
            requestFunc = fluxus.request
        elseif request then
            requestFunc = request
        else
            warn("No HTTP request function found")
            return
        end
        
        local getServerType = game:GetService("RobloxReplicatedStorage"):FindFirstChild("GetServerType")
        if getServerType and getServerType:InvokeServer() == "StandardServer" then
            
            local currentPlayers = #Players:GetPlayers()

            if currentPlayers <= 3 then
            end
        end
        
        
        local servers = {}
        local cursor = nil
        
        repeat
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"
            if cursor then
                url = url .. "&cursor=" .. cursor
            end
            
            local success, response = pcall(function()
                return requestFunc({
                    Url = url,
                    Method = "GET"
                })
            end)
            
            if success and response and response.Body then
                local data = HttpService:JSONDecode(response.Body)
                for _, server in ipairs(data.data) do
                    if server.playing < server.maxPlayers then
                        table.insert(servers, {
                            id = server.id,
                            players = server.playing
                        })
                    end
                end
                cursor = data.nextPageCursor
            else
                break
            end
        until not cursor
        
        if #servers == 0 then
        end
        
        table.sort(servers, function(a, b)
            return a.players < b.players
        end)
        
        local targetServer = servers[1]
        
        print(string.format("Joining server with %d players", targetServer.players))
        
        TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, LocalPlayer)
    end
end)
