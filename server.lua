local Config = require('store_config')

RegisterNetEvent('store:getStoreItems')
AddEventHandler('store:getStoreItems', function(storeKey)
    local _source = source
    local store = Config.Stores[storeKey]
    if store then
        local storeType = store.storetype
        local items = GetItemsByStoreType(storeType)
        TriggerClientEvent('store:receiveStoreItems', _source, items)
    else
        print("Store not found: " .. storeKey)
    end
end)

function GetItemsByStoreType(storeType)
    local ItemsConfig = require('items_config')
    return ItemsConfig[storeType] or {}
end
