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

function CreateItemModule:GuiEvents(ItemGui)

    local VP = ItemGui.ViewportFrame
    local Equipbutton = ItemGui.Equip
    local Deletebutton = ItemGui.Delete
    local Unequippedbutton = ItemGui.Unequip
    local Stats = ItemGui.Stats

    local VPCamera = ItemGui.Camera

    local defaultcframe = VPCamera.CFrame

    local goal = {}
    goal.CFrame = VPCamera.CFrame * CFrame.Angles(0,0,math.pi)

    local goal2 = {}
    goal.CFrame = defaultcframe

    local tweeninfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, math.huge)

    local tween = TweenService:Create(VPCamera, tweeninfo, goal)

    local tween2 = TweenService:Create(VPCamera, tweeninfo, goal2)

    ItemGui.MouseEnter:Connect(function()
        
        Equipbutton.Visible = true
        Deletebutton.Visible = true
        Unequippedbutton.Visible = true
        Stats.Visible = true
        
        tween:Play()

    end)

    ItemGui.MouseLeave:Connect(function()
        
        Equipbutton.Visible = false
        Deletebutton.Visible = false
        Unequippedbutton.Visible = false
        Stats.Visible = false



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