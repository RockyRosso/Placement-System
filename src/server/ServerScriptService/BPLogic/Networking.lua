--|| Variables

local Networking = {};

--||

--|| Get Remotes

for _, object in ipairs(game.ReplicatedStorage.Remotes:GetChildren()) do
    if object:IsA("RemoteEvent") then
        local rEvent = object;

        rEvent.OnServerEvent:Connect(function(plr, arg1, arg2)
            if rEvent.Name == "PickUpPart" then
                local CF = arg1;
                local TargetPart = arg2;
                
                TargetPart.CFrame = CF;
            elseif rEvent.Name == "ChangePartOwner" then
                local SetNameToPLR = arg1;
                local TargetPart = arg2;

                if SetNameToPLR == true then
                    TargetPart:SetAttribute("HeldBy", plr.Name);
                    plr.Values.PartSelected.Value = TargetPart;
                else
                    TargetPart:SetAttribute("HeldBy", "");
                    plr.Values.PartSelected.Value = nil;
                end
            end
        end)
    end
end

--||

return Networking;