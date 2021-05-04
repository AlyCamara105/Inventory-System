-- Create Item Module
-- Username
-- March 10, 2021



local Inventory = {}

function Inventory:Start()

    local EquipmentModule = self.Modules.EquipmentModule -- The equipment Module

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

    Inventory.openedItemGui = nil -- The opened Item Gui for inventory (The class)
    Inventory.EquippedItem = nil -- the equipped Item for inventory (the class)

    function Inventory:GetEquippedItem() -- Gets the equipped item for the inventory

        return self.EquippedItem

    end

    function Inventory:SetEquippedItem(EquippedItem) -- Sets the item gui (its class) that was equipped to the inventory equipped variable

        self.EquippedItem = EquippedItem

    end

    function Inventory:GetopenedItemGui() -- Gets the Item Gui (its class) that is opened
        return self.openedItemGui
    end

    function Inventory:SetopenedItemGui(ItemGui) -- Sets the item gui (its class) to the variable that stores an opened item gui
        self.openedItemGui = ItemGui
        if self.openedItemGui ~= nil then

            print(ItemGui.ItemGui.Name.."Has just been opened")

        end
        
    end

    function Inventory:GuiEvents(ItemGui, item, player) -- Connects all gui events in this function
        local GuiEvents = setmetatable({}, Inventory) -- Creates a class under Inventory for the new item gui

        GuiEvents.ItemGui = ItemGui -- The Item gui itself
        GuiEvents.Itemopened = false -- Whether the item gui is opened or not
        GuiEvents.VP = ItemGui.ViewportFrame -- The ViewportFrame itself
        GuiEvents.Equipbutton = ItemGui.Equip -- The equipbutton itself
        GuiEvents.Deletebutton = ItemGui.Delete -- The delete button itself
        GuiEvents.Stats = ItemGui.Stats -- The Stats button itself
        GuiEvents.StatsDamage = GuiEvents.Stats.Damage -- The damage image label itself
        GuiEvents.VPCamera = ItemGui.Camera -- The Camera for the ViewPort itself
        GuiEvents.defaultcframe = GuiEvents.VPCamera.CFrame -- The Cframe of the Camera
        GuiEvents.Equipped = false -- Whether the item of the item gui was equipped or not
        GuiEvents.Item = item -- The Category name for the item
        GuiEvents.ItemClass = nil -- The item Class from the EquipmentModule

        function GuiEvents:EquipItem() -- This Accesses the EquipmentModule to create the actual physical item

            self.ItemClass = EquipmentModule:new(GuiEvents.Item, player)
            print("We have called the module to create the item")

        end

        function GuiEvents:UnequipItem() -- This Accesses the EquipmentModule to delete the actual physcial item

            self.ItemClass:DeleteEquipment()
            print("We have called the moduel to delete the item")

        end

        function GuiEvents:GetGuiOpened() -- Gets whether or not the item gui itself was opened (clicked)

            print(self.ItemGui.Name.."is opened: "..tostring(self.Itemopened))
            return self.Itemopened

        end

        function GuiEvents:SetGuiOpened(bool) -- Sets the item gui opened (clicked) to the bool value

            self.Itemopened = bool
            print(self.ItemGui.Name.."was changed to: "..tostring(self.Itemopened))

        end

        function GuiEvents:GetEquipped() -- Checks whether the item is equipped

            return self.Equipped

        end

        function GuiEvents:SetEquipped(bool) -- Sets whether the item is equipped to the bool

            self.Equipped = bool

        end

        ItemGui.MouseEnter:Connect(function() -- Controls when the Mouse enters the Item gui
        
            local goal = {}
            goal.CFrame = GuiEvents.VPCamera.CFrame * CFrame.Angles(0,0,math.pi)

            local tweeninfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, math.huge)

            local tween = TweenService:Create(GuiEvents.VPCamera, tweeninfo, goal)
            
            GuiEvents.Stats.Visible = true
            tween:Play()
        
        end)
        
        ItemGui.MouseLeave:Connect(function() -- Controls when the Mouse leaves the Item gui

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

        ItemGui.MouseButton1Click:Connect(function(input) -- Controls when the Item gui is clicked

            if Inventory:GetopenedItemGui() ~= nil then -- If the inventory has an open Item gui

                if Inventory:GetopenedItemGui() == GuiEvents then -- and the item gui's are the same

                    GuiEvents.Equipbutton.Visible = false
                    GuiEvents.Deletebutton.Visible = false
                    GuiEvents.Stats.Visible = false

                    Inventory:SetopenedItemGui(nil)
                    GuiEvents:SetGuiOpened(false)

                    print("This gui should close")

                elseif Inventory:GetopenedItemGui() ~= GuiEvents then -- if it is not the same

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

            elseif Inventory:GetopenedItemGui() == nil then -- Elseif the Inventory doesn't have an opened Item Gui

                Inventory:SetopenedItemGui(GuiEvents)
                
                GuiEvents:SetGuiOpened(true)

                GuiEvents.Equipbutton.Visible = true
                GuiEvents.Deletebutton.Visible = true

                print(GuiEvents.ItemGui.Name.." opened when none was opened")

            end
        
        end)

        GuiEvents.Equipbutton.MouseButton1Click:Connect(function() -- Controls when the equip button is clicked

            if Inventory:GetEquippedItem() ~= nil then -- If an Item is equipped on the inventory

                if Inventory:GetEquippedItem() == GuiEvents then -- and if it is this item gui

                    if GuiEvents:GetEquipped() == true then -- and the gui is equipped (Not Needed?)

                        GuiEvents.Equipbutton.TextLabel.Text = "Equip"
                        GuiEvents:SetEquipped(false)
                        Inventory:SetEquippedItem(nil)
                        GuiEvents:UnequipItem()
                        print(GuiEvents.ItemGui.Name.." Just clicked the Unequiped the Item button.")
            
                    end

                elseif Inventory:GetEquippedItem() ~= GuiEvents then -- if it is not this item Gui

                    local OtherItem = Inventory:GetEquippedItem()
                    OtherItem:SetEquipped(false)
                    OtherItem.Equipbutton.TextLabel.Text = "Equip"

                    GuiEvents.Equipbutton.TextLabel.Text = "Unequip"
                    GuiEvents:SetEquipped(true)
                    Inventory:SetEquippedItem(GuiEvents)
                    OtherItem:UnequipItem()
                    print(GuiEvents.ItemGui.Name.." Just clicked the Equiped the Item button. Another Item was equipped.")
            
                end

            elseif Inventory:GetEquippedItem() == nil then -- If not Item is equipped on the inventory

                GuiEvents.Equipbutton.TextLabel.Text = "Unequip"
                GuiEvents:SetEquipped(true)
                Inventory:SetEquippedItem(GuiEvents)
                GuiEvents:EquipItem()
                print(GuiEvents.ItemGui.Name.." Just clicekd the Equiped the Item button. No ther Item was equipped.")

            end
        
        end)

        return GuiEvents
    end
    local loop = 1

    Inventory.GuiIsNil = false -- Variable for moving the default item gui
    Inventory.DefaultGui = nil -- The default item gui

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

                print(invname)

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
        
                    for index, sword in ipairs(Swords) do
                        
                        print(sword.Name)
                        print(item)
                        if item == sword.Name then
        
                            local VPSword = sword:Clone()
                            VPSword.Position = Vector3.new(0, 0, 0)
                            VPSword.Parent = VP
                            VPCamera.CFrame = CFrame.new(Vector3.new(0,0,-7), VPSword.Position)
                            Inventory:GuiEvents(NewInvItem, item, player)
                            loop = loop + 1
                            break
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
                            Inventory:GuiEvents(NewInvItem, item, player)
                            loop = loop + 1
                        end
        
                    end
                    
                end
        
            end

        end

    end

end

return Inventory