--|| Variables

local Networking = {};

--||

--|| Get Remotes

for _, object in ipairs(game.ReplicatedStorage.Remotes:GetChildren()) do
    if object:IsA("RemoteEvent") then
        local rEvent = object;

        rEvent.OnServerEvent:Connect(function(plr, arg1, arg2)
            if rEvent.Name == "PickUpPart" then
                local TargetPart = arg1;
                local Drop = arg2;

                if not Drop then
                    if not TargetPart:FindFirstChild("BodyPosition") then
                        local BP = Instance.new("BodyPosition");
                        BP.D = 100;
                        BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
                        BP.Parent = TargetPart;
                    end
    
                    if not TargetPart:FindFirstChild("BodyGyro") then
                        local BG = Instance.new("BodyGyro");
                        BG.D = 100;
                        BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge);
                        BG.P = 0;
                        BG.Parent = TargetPart;
                    end
    
                    TargetPart.CanCollide = false;
                    TargetPart.Anchored = false;

                    TargetPart:SetAttribute("HeldBy", plr.Name);
                    plr.Values.PartSelected.Value = TargetPart;

                    TargetPart:SetNetworkOwner(plr);
                else
                    TargetPart.CanCollide = true;
                    TargetPart.Anchored = true;

                    for _, item in ipairs(TargetPart:GetChildren()) do
                        if item:IsA("BodyPosition") or item:IsA("BodyGyro") then
                            item:Destroy();
                        end
                    end

                    TargetPart:SetAttribute("HeldBy", "");
                    plr.Values.PartSelected.Value = nil;
                end
            elseif rEvent.Name == "Throw" then
                local TargetPart = arg1;
                local character = plr.Character;

                TargetPart.Anchored = false;

                local BodyVel = Instance.new("BodyVelocity");
                BodyVel.MaxForce = Vector3.new(40000, 5, 40000);
                BodyVel.Velocity = character.HumanoidRootPart.CFrame.lookVector * 100;
                BodyVel.Parent = TargetPart;

                game:GetService("Debris"):AddItem(BodyVel, 0.1);

                TargetPart:SetNetworkOwner(nil);
            end
        end)
    end
end

--||

return Networking;