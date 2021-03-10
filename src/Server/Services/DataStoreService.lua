-- Data Store Service
-- Username
-- March 9, 2021



local DataStoreService = {Client = {}}

local SendInventoryEvent = "SendInv"

function DataStoreService:Start()

local DataStore2 = require(game.ServerScriptService.DataStore2)

game.Players.PlayerAdded:Connect(function(player)

    DataStore2.Combine("MasterKey", "Inventory")

    local InventoryData = DataStore2("Inventory", player)

    local DefaultInventory = {"one"}
	
    local playerInventory = InventoryData:Get(DefaultInventory)
	
    self:FireClient(SendInventoryEvent, player, playerInventory)

    print("The server fired the inventory event")

end)

end


function DataStoreService:Init()
	self:RegisterClientEvent(SendInventoryEvent)
end


return DataStoreService