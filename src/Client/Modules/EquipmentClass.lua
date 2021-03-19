-- Equipment Class
-- Username
-- March 18, 2021



local EquipmentClass = {}
EquipmentClass.__index = EquipmentClass

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SwordsFolder = ReplicatedStorage:WaitForChild("Swords",3)

function EquipmentClass:new(item, player)

	local Equipment = setmetatable({}, EquipmentClass)

	Equipment.Name = item

	for index, Swordinlist in ipairs(SwordsFolder) do

		if item == Swordinlist then

			local SwordItem = Swordinlist:Clone()
			SwordItem.CFrame = player.Character.CFrame:ToWorldSpace(CFrame.new(0,0,-5))
			SwordItem.Anchored = true
			SwordItem.Parent = player.Character

		end

	end

	return Equipment

end


return EquipmentClass