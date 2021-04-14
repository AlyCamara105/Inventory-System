-- Inventory Controller
-- Username
-- March 9, 2021



local InventoryController = {}

function InventoryController:Start()

    local InventoryModule = self.Modules.Inventory --Getting the Inventory Module

    self.Services.DataStoreService.SendInv:Connect(function(inventory) --Connecting the inventory event

        local player = game.Players.LocalPlayer --Getting the player

        repeat wait() until player.Character --Waiting for the character to load for replication

        local InventoryScreen = player.PlayerGui["Inventory 2.0"]
        local Inventory = InventoryScreen["Overall Frame"].Inventoryframe.Inventory
        local defaultitem = Inventory.Itemframe
        
        for index, item in ipairs(inventory) do --Looping through inventory argument passed from the server

            InventoryModule:LoadItem(item, player) --Calling the Inventory Module to create an item gui for the item in the inventory
        
        end
	
    end)

end


function InventoryController:Init()
	
end


return InventoryController