--|| Variables

require(script.Networking);

--||

--|| PlayerAdded Listener

game.Players.PlayerAdded:Connect(function(player)
    local Values = Instance.new("Folder");
    Values.Name = "Values";
    Values.Parent = player;

    local PartSelected = Instance.new("ObjectValue");
    PartSelected.Name = "PartSelected";
    PartSelected.Parent = Values;
end)

--||