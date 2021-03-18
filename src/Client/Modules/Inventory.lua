-- Create Item Module
-- Username
-- March 10, 2021



local Inventory = {}

Inventory.__index = Inventory

local TweenService = game:GetService("TweenService")

Inventory.Items = {

    ["StarterSword"] = {

        ["Name"] = "Starter Sword";
        ["Damage"] = 5;
        ["Desc"] = "One of the first swords ever created in-game!"

    };

    ["LowPolySword"] = {

        ["Name"] = "Long Sword";
        ["Damage"] = 10;
        ["Desc"] = "The second sword created in-game!"

    }

}

Inventory.openedItemGui = nil
Inventory.EquippedItem = nil

function Inventory:GetEquippedItem()

    return self.EquippedItem

end

function Inventory:SetEquippedItem(EquippedItem)

    self.EquippedItem = EquippedItem

end

function Inventory:GetopenedItemGui()
    return self.openedItemGui
end

function Inventory:SetopenedItemGui(ItemGui)
    self.openedItemGui = ItemGui
    if self.openedItemGui ~= nil then

        print(ItemGui.ItemGui.Name.."Has just been opened")

    end
    
end

function Inventory:GuiEvents(ItemGui)
    local GuiEvents = setmetatable({}, Inventory)

    GuiEvents.ItemGui = ItemGui
    GuiEvents.Itemopened = false
    GuiEvents.VP = ItemGui.ViewportFrame
    GuiEvents.Equipbutton = ItemGui.Equip
    GuiEvents.Deletebutton = ItemGui.Delete
    GuiEvents.Stats = ItemGui.Stats
    GuiEvents.StatsDamage = GuiEvents.Stats.Damage
    GuiEvents.VPCamera = ItemGui.Camera
    GuiEvents.defaultcframe = GuiEvents.VPCamera.CFrame
    GuiEvents.Equipped = false

    function GuiEvents:GetGuiOpened()

        print(self.ItemGui.Name.."is opened: "..tostring(self.Itemopened))
        return self.Itemopened

    end

    function GuiEvents:SetGuiOpened(bool)

        self.Itemopened = bool
        print(self.ItemGui.Name.."was changed to: "..tostring(self.Itemopened))

    end

    function GuiEvents:GetEquipped()

        return self.Equipped

    end

    function GuiEvents:SetEquipped(bool)

        self.Equipped = bool

    end

    ItemGui.MouseEnter:Connect(function()
    
        local goal = {}
        goal.CFrame = GuiEvents.VPCamera.CFrame * CFrame.Angles(0,0,math.pi)

        local tweeninfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, math.huge)

        local tween = TweenService:Create(GuiEvents.VPCamera, tweeninfo, goal)
        
        GuiEvents.Stats.Visible = true
        tween:Play()
    
    end)
    
    ItemGui.MouseLeave:Connect(function()

        local goal2 = {}
        goal2.CFrame = GuiEvents.defaultcframe

        local tweeninfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

        local tween2 = TweenService:Create(GuiEvents.VPCamera, tweeninfo2, goal2)

        if GuiEvents:GetGuiOpened() == true then

            print("Don't close the stats frame")

        else

            GuiEvents.Stats.Visible = false
            print("We closed the stats frame because the itemgui wasn't clicked")

        end

        tween2:Play()

    end)

    ItemGui.MouseButton1Click:Connect(function(input)

        if Inventory:GetopenedItemGui() ~= nil then

            if Inventory:GetopenedItemGui() == GuiEvents then

                GuiEvents.Equipbutton.Visible = false
                GuiEvents.Deletebutton.Visible = false
                GuiEvents.Stats.Visible = false

                Inventory:SetopenedItemGui(nil)
                GuiEvents:SetGuiOpened(false)

                print("This gui should close")

            elseif Inventory:GetopenedItemGui() ~= GuiEvents then

                local OtherItemGui = Inventory:GetopenedItemGui()
                OtherItemGui.Equipbutton.Visible = false
                OtherItemGui.Deletebutton.Visible = false
                OtherItemGui.Stats.Visible = false
                OtherItemGui:SetGuiOpened(false)

                Inventory:SetopenedItemGui(GuiEvents)
                
                GuiEvents:SetGuiOpened(true)

                GuiEvents.Equipbutton.Visible = true
                GuiEvents.Deletebutton.Visible = true

                print(GuiEvents.ItemGui.Name.." was opened when "..OtherItemGui.ItemGui.Name.." was")

            end 

        elseif Inventory:GetopenedItemGui() == nil then

            Inventory:SetopenedItemGui(GuiEvents)
            
            GuiEvents:SetGuiOpened(true)

            GuiEvents.Equipbutton.Visible = true
            GuiEvents.Deletebutton.Visible = true

            print(GuiEvents.ItemGui.Name.." opened when none was opened")

        end
    
    end)

    GuiEvents.Equipbutton.MouseButton1Click:Connect(function()

        if Inventory:GetEquippedItem() ~= nil then

            if Inventory:GetEquippedItem() == GuiEvents then

                if GuiEvents:GetEquipped() == true then

                    GuiEvents.Equipbutton.TextLabel.Text = "Equip"
                    GuiEvents:SetEquipped(false)
                    Inventory:SetEquippedItem(nil)
                    print(GuiEvents.ItemGui.Name.." Just Unequiped the Item.")
        
                end

            elseif Inventory:GetEquippedItem() ~= GuiEvents then

                local OtherItem = Inventory:GetEquippedItem()
                OtherItem:SetEquipped(false)
                OtherItem.Equipbutton.TextLabel.Text = "Equip"

                GuiEvents.Equipbutton.TextLabel.Text = "Unequip"
                GuiEvents:SetEquipped(true)
                Inventory:SetEquippedItem(GuiEvents)
                print(GuiEvents.ItemGui.Name.." Just Equiped the Item. Another Item was equipped.")
        
            end

        elseif Inventory:GetEquippedItem() == nil then

            GuiEvents.Equipbutton.TextLabel.Text = "Unequip"
            GuiEvents:SetEquipped(true)
            Inventory:SetEquippedItem(GuiEvents)
            print(GuiEvents.ItemGui.Name.." Just Equiped the Item. No ther Item was equipped.")

        end
    
        --[[
        if GuiEvents:GetEquipped() == true then

            GuiEvents.Equipbutton.TextLabel.Text = "Equip"
            GuiEvents:SetEquipped(false)
            print("The item was unequipped")

        elseif GuiEvents:GetEquipped() == false then

            GuiEvents.Equipbutton.TextLabel.Text = "Unequip"
            GuiEvents:SetEquipped(true)
            print("The item was equipped")

        end
        --]]
    
    end)

    return GuiEvents
end
local loop = 1

Inventory.GuiIsNil = false
Inventory.DefaultGui = nil

function Inventory:EraseDefaultItemGui(DefaulItemGui)

    DefaulItemGui.Parent = nil
    self.DefaultGui = DefaulItemGui
    self.GuiIsNil = true
    print("The defaultgui should be gone from the inventory")

end

function Inventory:LoadItem(item, player)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Swords = ReplicatedStorage:WaitForChild("Swords", 3):GetChildren()

    local InventoryScreen = player.PlayerGui["Inventory 2.0"]
    local Inventoryframe = InventoryScreen["Overall Frame"].Inventoryframe.Inventory

    if not self.GuiIsNil then

        local defaultitem = Inventoryframe.Itemframe

        for invname, info in pairs(Inventory.Items) do

            if item == invname then
    
                Inventory:EraseDefaultItemGui(defaultitem)
    
                local NewInvItem = self.DefaultGui:Clone()
                NewInvItem.Parent = Inventoryframe
    
                local StatsName = NewInvItem.Stats.SwordName
                local StatsDamage = NewInvItem.Stats.Damage
                local StatsDesc = NewInvItem.Stats.Desc
    
                StatsName.Text = info.Name
                StatsDamage.Text = "Damage: "..info.Damage
                StatsDesc.Text = "Desc: "..info.Desc
    
                NewInvItem.Name = NewInvItem.Name..loop
    
                local VP = NewInvItem.ViewportFrame
    
                local VPCamera = Instance.new("Camera")
                VP.CurrentCamera = VPCamera
                VPCamera.Parent = NewInvItem
    
                for index, sword in pairs(Swords) do
                    
                    print(sword.Name)
                    print(item)
                    if item == sword.Name then
    
                        local VPSword = sword:Clone()
                        VPSword.Position = Vector3.new(0, 0, 0)
                        VPSword.Parent = VP
                        VPCamera.CFrame = CFrame.new(Vector3.new(0,0,-7), VPSword.Position)
                        Inventory:GuiEvents(NewInvItem)
                        loop = loop + 1
                    end
    
                end
                
            end
    
        end

    elseif self.GuiIsNil then

        for invname, info in pairs(Inventory.Items) do

            if item == invname then
    
                local NewInvItem = self.DefaultGui:Clone()
                NewInvItem.Parent = Inventoryframe
    
                local StatsName = NewInvItem.Stats.SwordName
                local StatsDamage = NewInvItem.Stats.Damage
                local StatsDesc = NewInvItem.Stats.Desc
    
                StatsName.Text = info.Name
                StatsDamage.Text = "Damage: "..info.Damage
                StatsDesc.Text = "Desc: "..info.Desc
    
                NewInvItem.Name = NewInvItem.Name..loop
    
                local VP = NewInvItem.ViewportFrame
    
                local VPCamera = Instance.new("Camera")
                VP.CurrentCamera = VPCamera
                VPCamera.Parent = NewInvItem
    
                for index, sword in pairs(Swords) do
                    
                    print(sword.Name)
                    print(item)
                    if item == sword.Name then
    
                        local VPSword = sword:Clone()
                        VPSword.Position = Vector3.new(0, 0, 0)
                        VPSword.Parent = VP
                        VPCamera.CFrame = CFrame.new(Vector3.new(0,0,-7), VPSword.Position)
                        Inventory:GuiEvents(NewInvItem)
                        loop = loop + 1
                    end
    
                end
                
            end
    
        end

    end

end

return Inventory