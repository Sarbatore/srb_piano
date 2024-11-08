local prompt = 0
local play = false

AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    PromptDelete(prompt)
end)

--- Return whether the player is near the given coordinates
---@param x number
---@param y number
---@param z number
---@return boolean
local function IsPlayerNearCoords(x, y, z)
    local pcoords = GetEntityCoords(PlayerPedId(), 0)
    local distance = GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, x, y, z, false)

    if distance <= Config.distance then
        return true
    end
end

--- Return the nearest piano coordinates
---@return vector4
local function GetNearestPianoCoords()
    for _, coords in ipairs(Config.pianos) do
        if (IsPlayerNearCoords(coords.x, coords.y, coords.z)) then
            return coords
        end
    end
    return nil
end

Citizen.CreateThread(function()
    local promptGroup = GetRandomIntInRange(0, 0xffffff)
    prompt = PromptRegisterBegin()
        UiPromptSetControlAction(prompt, Config.controlKey)
        UiPromptSetText(prompt, VarString(10, "LITERAL_STRING", Config.language.press))
        UiPromptSetEnabled(prompt, true)
        UiPromptSetVisible(prompt, true)
        UiPromptSetStandardMode(prompt, true)
        UiPromptSetGroup(prompt, promptGroup, 0)
	UiPromptRegisterEnd(prompt)

    local sleep = true
	while true do
        if (sleep) then
            Citizen.Wait(1000)
        else
            Citizen.Wait(0)
        end

        sleep = true
        
        local piano = GetNearestPianoCoords()
        if (piano) then
            sleep = false

            PromptSetActiveGroupThisFrame(promptGroup, VarString(10, "LITERAL_STRING", Config.language.piano))

            if (PromptIsJustPressed(prompt)) then
                play = not play

                local playerPed = PlayerPedId()
                if (play) then
                    local scenario = IsPedMale(playerPed) and "PROP_HUMAN_PIANO" or "PROP_HUMAN_ABIGAIL_PIANO"
                    TaskStartScenarioAtPosition(playerPed, joaat(scenario), piano, 0, true, true, 0, true)
                else
                    ClearPedTasks(playerPed)
                end
            end
        end
    end    
end)
