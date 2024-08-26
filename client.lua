local play = false

--- Return whether the player is near the given coordinates
---@param x number
---@param y number
---@param z number
---@return boolean
local function IsPlayerNearCoords(x, y, z)
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(px, py, pz, x, y, z, false)

    if distance <= 1 then
        return true
    end
end

--- Return whether the player is near the given coordinates
---@return vector4
local function NearestPiano()
    for _, coords in ipairs(Config.pianos) do
        if (IsPlayerNearCoords(coords)) then
            return coords
        end
    end
    return nil
end

Citizen.CreateThread(function()
    local promptGroup = UipromptGroup:new(Config.language.piano)
    local prompt = Uiprompt:new(0x760A9C6F, Config.language.press, promptGroup)
        :setOnControlJustPressed(function(_, location)
            play = not play

            if (play) then
                local scenario = IsPedMale(PlayerPedId()) and "PROP_HUMAN_PIANO" or "PROP_HUMAN_ABIGAIL_PIANO"
                TaskStartScenarioAtPosition(PlayerPedId(), GetHashKey(scenario), location, 0, true, true, 0, true)

            else
                ClearPedTasks(PlayerPedId())
            end
        end)

    local sleep = true
	while true do
        if (sleep) then
            Citizen.Wait(1000)
        else
            Citizen.Wait(5)
        end
        
        local piano = NearestPiano()
        if (piano) then
            promptGroup:handleEvents(piano)
            promptGroup:setActiveThisFrame()

            sleep = false
        else
            sleep = true
        end
    end    
end)