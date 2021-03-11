-- Create Item Module
-- Username
-- March 10, 2021



local CreateItemModule = {}

CreateItemModule.Items = {

    ["one"] = {

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

CreateItemModule.CreateItem = function(item, ItemGui)

    for invname, info in pairs(CreateItemModule.Items) do

        if item == invname then

            print("Name: "..info.Name.." Damage: "..info.Damage.." Desc: "..info.Desc)

        end

    end

end


return CreateItemModule