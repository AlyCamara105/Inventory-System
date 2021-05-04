-- Equipment Module
-- Username
-- March 18, 2021




local EquipmentModule = {}
EquipmentModule.__index = EquipmentModule

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SwordsFolder = ReplicatedStorage:WaitForChild("Swords",3):GetChildren()

function EquipmentModule:new(item, player)

	local Equipment = setmetatable({}, EquipmentModule)

	Equipment.Name = item
	Equipment.ItemPhysical = nil

	for index, Swordinlist in ipairs(SwordsFolder) do

		if item == Swordinlist.Name then

			local SwordItem = Swordinlist:Clone()
			SwordItem.CFrame = player.Character.HumanoidRootPart.CFrame:ToWorldSpace(CFrame.new(0,0,-5))
			SwordItem.Anchored = true
			SwordItem.Parent = player.Character
			self.ItemPhysical = SwordItem
			print("The Item has been created")

		end

	end

	function EquipmentModule:DeleteEquipment()

		self.ItemPhysical:Destroy()
		print("We have deleted the item")

	end

	return Equipment

end


return EquipmentModule