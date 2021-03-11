-- Inventory Controller
-- Username
-- March 9, 2021



local InventoryController = {}


function InventoryController:Start()

    local InventoryModule = self.Modules.CreateItemModule

    self.Services.DataStoreService.SendInv:Connect(function(inventory)

        local player = game.Players.LocalPlayer

        player.CharacterAdded:Wait()

        local InventoryScreen = player.PlayerGui["Inventory 2.0"]
        local Inventory = InventoryScreen["Overall Frame"].Inventoryframe.Inventory
        local defaultitem = Inventory.Itemframe
        
        for index, item in pairs(inventory) do

            local NewInvItem = defaultitem:Clone()
            NewInvItem.Parent = Inventory

            InventoryModule.CreateItem(item, NewInvItem)
        
        end
	
    end)

end


function InventoryController:Init()
	
end


return InventoryController