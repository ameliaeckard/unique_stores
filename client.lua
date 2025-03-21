local Config = require('store_config')

Citizen.CreateThread(function()
    local prompts = {}
    for storeKey, store in pairs(Config.Stores) do
        if not store.isDeactivated then
            local prompt = PromptRegisterBegin()
            PromptSetControlAction(prompt, 0x5E723D8C)
            PromptSetText(prompt, CreateVarString(10, "LITERAL_STRING", store.PromptName))
            PromptSetHoldMode(prompt, true)
            PromptRegisterEnd(prompt)

            table.insert(prompts, {prompt = prompt, store = store, key = storeKey})
        end
    end

    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, data in pairs(prompts) do
            local store = data.store
            local storeCoords = store.possibleLocations.OpenMenu[1]
            local dist = #(coords - storeCoords)

            if dist < store.distanceOpenStore then
                sleep = 5
                PromptSetVisible(data.prompt, true)
                if PromptHasHoldModeCompleted(data.prompt) then
                    TriggerServerEvent('store:getStoreItems', data.key)
                    Citizen.Wait(500)
                end
            else
                PromptSetVisible(data.prompt, false)
            end
        end

        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('store:receiveStoreItems')
AddEventHandler('store:receiveStoreItems', function(items)
    -- Your existing UI handling logic here
    SendNUIMessage({
        type = "OpenBookGui",
        value = true,
        items = items
    })
    SetNuiFocus(true, true)
end)
