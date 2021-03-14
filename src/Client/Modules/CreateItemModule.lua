-- Create Item Module
-- Username
-- March 10, 2021



local CreateItemModule = {}

local TweenService = game:GetService("TweenService")

CreateItemModule.Items = {

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

local openedItemGui = nil

function CreateItemModule:GetopenedItemGui()
    return openedItemGui
end

function CreateItemModule:SetopenedItemGui(ItemGui)
    local openedItemGui = ItemGui
    print(ItemGui.Name.."Has just been opened")
end

function CreateItemModule:GuiEvents(ItemGui)

    local Itemopened = false

    function CreateItemModule.GuiEvents:GetGuiOpened()
        print("We are checking if the item was clicked")
        return Itemopened  
    end

    function CreateItemModule.GuiEvents:SetopenedItemGui(bool)
        Itemopened = bool
        print("The item was clicked!")
    end

    local VP = ItemGui.ViewportFrame
    local Equipbutton = ItemGui.Equip
    local Deletebutton = ItemGui.Delete
    local Unequippedbutton = ItemGui.Unequip
    local Stats = ItemGui.Stats

    local VPCamera = ItemGui.Camera

    local defaultCframe = VPCamera.CFrame

    ItemGui.MouseEnter:Connect(function()

        local goal = {}
        goal.CFrame = VPCamera.CFrame * CFrame.Angles(0,0,math.pi)

        local tweeninfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, math.huge)

        local tween = TweenService:Create(VPCamera, tweeninfo, goal)
        
        Stats.Visible = true
        tween:Play()

    end)

    ItemGui.MouseLeave:Connect(function()

        local goal2 = {}
        goal2.CFrame = defaultCframe

        local tweeninfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

        local tween2 = TweenService:Create(VPCamera, tweeninfo2, goal2)

        if CreateItemModule.GuiEvents:GetopenedItemGui() == true then

            print("Don't close the stats frame")

        else

            Stats.Visible = false
            print("We closed the stats frame because the itemgui wasn't clicked")

        end

        tween2:Play()

    end)

    ItemGui.InputBegan:Connect(function(input)
    
        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            if CreateItemModule:GetopenedItemGui() ~= nil then 

                local OtherItemGui = CreateItemModule:GetopenedItemGui()
                OtherItemGui.Equip.Visible = false
                OtherItemGui.Unequip.Visible = false
                OtherItemGui.Delete.Visible = false
                OtherItemGui.Stats.Visible = false

                CreateItemModule:SetopenedItemGui(ItemGui)

            else

                CreateItemModule:SetopenedItemGui(ItemGui)

            end

            CreateItemModule.GuiEvents:SetopenedItemGui(true)

            Equipbutton.Visible = true
            Unequippedbutton.Visible = true
            Deletebutton.Visible = true
        
        end
    
    end)

end

function CreateItemModule:LoadInventory(item, player)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Swords = ReplicatedStorage:WaitForChild("Swords", 3):GetChildren()

    local InventoryScreen = player.PlayerGui["Inventory 2.0"]
    local Inventory = InventoryScreen["Overall Frame"].Inventoryframe.Inventory
    local defaultitem = Inventory.Itemframe

    for invname, info in pairs(CreateItemModule.Items) do

        if item == invname then

            local NewInvItem = defaultitem:Clone()
            NewInvItem.Parent = Inventory

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
                    CreateItemModule:GuiEvents(NewInvItem)
                end

            end
            
        end

    end

end

return CreateItemModule