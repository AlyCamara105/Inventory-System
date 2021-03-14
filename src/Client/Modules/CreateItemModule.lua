-- Create Item Module
-- Username
-- March 10, 2021



local CreateItemModule = {}

CreateItemModule.__index = CreateItemModule

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

CreateItemModule.openedItemGui = nil

function CreateItemModule:GetopenedItemGui()
    return self.openedItemGui
end

function CreateItemModule:SetopenedItemGui(ItemGui)
    self.openedItemGui = ItemGui
    if self.openedItemGui ~= nil then

        print(ItemGui.ItemGui.Name.."Has just been opened")

    end
    
end

function CreateItemModule:GuiEvents(ItemGui)
    local GuiEvents = setmetatable({}, CreateItemModule)

    GuiEvents.ItemGui = ItemGui
    GuiEvents.Itemopened = false
    GuiEvents.VP = ItemGui.ViewportFrame
    GuiEvents.Equipbutton = ItemGui.Equip
    GuiEvents.Deletebutton = ItemGui.Delete
    GuiEvents.Unequippedbutton = ItemGui.Unequip
    GuiEvents.Stats = ItemGui.Stats
    GuiEvents.VPCamera = ItemGui.Camera
    GuiEvents.defaultcframe = GuiEvents.VPCamera.CFrame

    function GuiEvents:GetGuiOpened()

        print(self.ItemGui.Name.."is opened: "..tostring(self.Itemopened))
        return self.Itemopened

    end

    function GuiEvents:SetGuiOpened(bool)

        self.Itemopened = bool
        print(self.ItemGui.Name.."was changed to: "..tostring(self.Itemopened))

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

    ItemGui.InputBegan:Connect(function(input)
    
        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            if CreateItemModule:GetopenedItemGui() ~= nil then

                if CreateItemModule:GetopenedItemGui() == GuiEvents then

                    GuiEvents.Equipbutton.Visible = false
                    GuiEvents.Unequippedbutton.Visible = false
                    GuiEvents.Deletebutton.Visible = false
                    GuiEvents.Stats.Visible = false

                    CreateItemModule:SetopenedItemGui(nil)
                    GuiEvents:SetGuiOpened(false)

                    print("This gui should close")

                elseif CreateItemModule:GetopenedItemGui() ~= GuiEvents then

                    local OtherItemGui = CreateItemModule:GetopenedItemGui()
                    OtherItemGui.Equipbutton.Visible = false
                    OtherItemGui.Unequippedbutton.Visible = false
                    OtherItemGui.Deletebutton.Visible = false
                    OtherItemGui.Stats.Visible = false
                    OtherItemGui:SetGuiOpened(false)

                    CreateItemModule:SetopenedItemGui(GuiEvents)
                    
                    GuiEvents:SetGuiOpened(true)

                    GuiEvents.Equipbutton.Visible = true
                    GuiEvents.Unequippedbutton.Visible = true
                    GuiEvents.Deletebutton.Visible = true

                    print(GuiEvents.ItemGui.Name.." was opened when "..OtherItemGui.ItemGui.Name.." was")

                end 

            elseif CreateItemModule:GetopenedItemGui() == nil then

                CreateItemModule:SetopenedItemGui(GuiEvents)
                
                GuiEvents:SetGuiOpened(true)

                GuiEvents.Equipbutton.Visible = true
                GuiEvents.Unequippedbutton.Visible = true
                GuiEvents.Deletebutton.Visible = true

                print(GuiEvents.ItemGui.Name.." opened when none was opened")

            end
        
        end
    
    end)

    return GuiEvents
end
local loop = 1
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
                    CreateItemModule:GuiEvents(NewInvItem)
                    loop = loop + 1
                end

            end
            
        end

    end

end

return CreateItemModule