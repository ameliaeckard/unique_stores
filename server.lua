Config = Config or {}
local StoreConfig = Config.Stores
local ItemsConfig = Config.Items

local storeInventoryCache = {}
local lastUpdate = {}

function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function GetGameHour()
    return GetClockHours()
end

function IsStoreClosed(store)
    if not store.StoreHoursAllowed then return false end
    local hour = GetGameHour()
    return hour < store.StoreOpen or hour >= store.StoreClose
end

function CheckAndUpdateStoreInventory(storeKey)
    local store = StoreConfig.Stores[storeKey]
    if not store then return end

    if not storeInventoryCache[storeKey] then
        storeInventoryCache[storeKey] = {}
        lastUpdate[storeKey] = -1
    end

    if IsStoreClosed(store) then
        local currentHour = GetGameHour()
        if lastUpdate[storeKey] ~= currentHour then
            lastUpdate[storeKey] = currentHour

            local storetype = store.storetype
            local baseItems = ItemsConfig[storetype] or {}

            local shuffled = {}
            for i = 1, #baseItems do
                table.insert(shuffled, baseItems[i])
            end
            for i = #shuffled, 2, -1 do
                local j = math.random(i)
                shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
            end

            local itemCount = math.random(3, #shuffled)
            local newInventory = {}

            for i = 1, itemCount do
                local item = table.deepcopy(shuffled[i])
                local fluctuation = math.random(-2, 5)
                item.price = math.max(1, (item.price or 10) + fluctuation)
                if item.ammoPrice then
                    item.ammoPrice = math.max(1, item.ammoPrice + math.random(-1, 3))
                end
                table.insert(newInventory, item)
            end

            storeInventoryCache[storeKey] = newInventory
            print("[Store] Updated inventory for:", storeKey)
        end
    end
end

RegisterNetEvent('store:getStoreItems')
AddEventHandler('store:getStoreItems', function(storeKey)
    if type(storeKey) ~= "string" then
        print("[Store] Invalid store key type received: " .. type(storeKey))
        return
    end

    if not StoreConfig.Stores[storeKey] then
        print("[Store] Store key not found: " .. tostring(storeKey))
        return
    end

    local _source = source
    local success, err = pcall(CheckAndUpdateStoreInventory, storeKey)
    if not success then
        print("[Store] Error updating inventory for store:", storeKey, "Error:", err)
        return
    end

    local items = storeInventoryCache[storeKey] or {}
    TriggerClientEvent('store:receiveStoreItems', _source, items)
end)

local Framework = {}
TriggerEvent("redemrp_inventory:getData", function(call)
    Framework = call
end)

local code = math.random(111111, 9999999)

RegisterNetEvent("gunCatalogue:getCode")
AddEventHandler("gunCatalogue:getCode", function()
    local _source = source
    TriggerClientEvent('gunCatalogue:SendCode', _source, code)
end)

function getWeaponData(weapon)
    local guns = ItemsConfig["weapon"] or {}
    for i = 1, #guns do
        if guns[i].itemName == weapon then
            return guns[i]
        end
    end
    return false
end

RegisterNetEvent("gunCatalogue:Purchase")
AddEventHandler("gunCatalogue:Purchase", function(data, code1)
    local _source = source
    if code == code1 then
        TriggerEvent('redem:getPlayerFromId', _source, function(user)
            local cash = user.getMoney()
            local wData = getWeaponData(data.weapon)
            if not wData then
                TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'error', text = "You're trying to buy a weapon that doesn't exist" })
                return
            end

            if tonumber(data.isammo) ~= 1 then
                if cash >= wData.price then
                    local ItemData = Framework.getItem(_source, GetHashKey(data.weapon))
                    ItemData.AddItem(1)
                    TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'success', text = 'Received ' .. wData.itemLabel })
                    user.removeMoney(wData.price)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'error', text = 'You do not have enough money to buy this weapon' })
                end
            else
                if cash >= wData.ammoPrice then
                    local ItemData = Framework.getItem(_source, data.weapon)
                    ItemData.AddItem(1)
                    TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'success', text = 'Received ' .. wData.itemLabel })
                    user.removeMoney(wData.ammoPrice)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'error', text = 'You do not have enough money to buy ammo' })
                end
            end
        end)
    end
end)

RegisterServerEvent("RegisterUsableItem:revolver_ammo")
AddEventHandler("RegisterUsableItem:revolver_ammo", function(source)
    local _source = source
    print("hi")
    TriggerClientEvent('gunCatalogue:giveammo', _source, "WEAPON_REVOLVER_CATTLEMAN", code)
    local ItemData = Framework.getItem(_source, 'revolver_ammo', 1)
    ItemData.RemoveItem(1)
end)

-- Repeat similar RegisterServerEvent blocks for other ammo items as needed...
