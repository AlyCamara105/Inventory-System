-- Inventory Controller
-- Username
-- March 9, 2021



local InventoryController = {}

function InventoryController:Start()

    local InventoryModule = self.Modules.Inventory

    self.Services.DataStoreService.SendInv:Connect(function(inventory)

        local player = game.Players.LocalPlayer

        repeat wait() until player.Character

        local InventoryScreen = player.PlayerGui["Inventory 2.0"]
        local Inventory = InventoryScreen["Overall Frame"].Inventoryframe.Inventory
        local defaultitem = Inventory.Itemframe
        
        for index, item in ipairs(inventory) do

            InventoryModule:LoadItem(item, player)
        
        end
	
    end)

end


function InventoryController:Init()
	
end


return InventoryController