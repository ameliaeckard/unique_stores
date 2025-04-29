Config = Config or {}

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
            local nearStore = false
            for _, loc in ipairs(store.possibleLocations.OpenMenu) do
                if #(coords - loc) < store.distanceOpenStore then
                    nearStore = true
                    break
                end
            end

            if nearStore then
                sleep = 5
                PromptSetVisible(data.prompt, true)
                if PromptHasHoldModeCompleted(data.prompt) then
                    if type(data.key) == "string" then
                        TriggerServerEvent('store:getStoreItems', data.key)
                    else
                        print("[Store] Invalid store key type for store:", data.key)
                    end
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
    if type(items) ~= "table" then
       print("[Store] Received invalid items data from server.")
       return
    end

    SendNUIMessage({
        type = "OpenBookGui",
        value = true,
        items = items
    })
    SetNuiFocus(true, true)
end)

function Purchase(data)
    TriggerServerEvent('gunCatalogue:getCode')
    Citizen.Wait(200)
    TriggerServerEvent('gunCatalogue:Purchase', data, code)
end

RegisterNUICallback('purchaseweapon', function(data, cb)
    Purchase(data)
    cb("ok")
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)
