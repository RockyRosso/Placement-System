--|| Variables

local Placing = {};
Placing.__index = Placing;

local Distance = 10;

local MaxDistance = 20;
local MinDistance = 5;

--||

--|| Functions

local function HoldPart(TargetPart: Instance)
    local player = game.Players.LocalPlayer;
    local mouse = player:GetMouse();
    local character = player.Character;

    local pos = character.HumanoidRootPart.Position + (mouse.Hit.Position - character.HumanoidRootPart.Position).Unit * Distance;
    TargetPart:WaitForChild("BodyPosition").Position = pos;
    TargetPart.BodyGyro.CFrame = TargetPart.CFrame;

    TargetPart.BodyGyro.CFrame = TargetPart.BodyGyro.CFrame * CFrame.Angles(0, 0.1, 0);
end

--||

--|| Module Functions

function Placing.new()
    local self = setmetatable({}, Placing);

    --|| Player

    self.Player = game.Players.LocalPlayer;
    self.Name = self.Player.Name;
    self.Character = self.Player.Character;

    self.Mouse = self.Player:GetMouse();

    self.Values = self.Player:WaitForChild("Values");

    return self;
end

function Placing:Toggle()
    local RunService = game:GetService("RunService");

    local TargetPart = self.Mouse.Target;

    local ReplicatedStorage = game.ReplicatedStorage;
    local Remotes = ReplicatedStorage.Remotes;
    
    if self.Values.PartSelected.Value == nil then
        if TargetPart:GetAttribute("IsPickedUp") ~= nil then
            if not TargetPart:GetAttribute("IsPickedUp") then
    
                if TargetPart:GetAttribute("HeldBy") == "" then
                    TargetPart:SetAttribute("IsPickedUp", true);

                    Remotes.PickUpPart:FireServer(TargetPart, false);
                    Remotes.ChangePartOwner:FireServer(true, TargetPart);

                    RunService:BindToRenderStep("HoldBlock", Enum.RenderPriority.Input.Value, function() HoldPart(TargetPart) end);
                end
            end
        end
    else
        if self.Values.PartSelected.Value:GetAttribute("HeldBy") == self.Name then
            self.Mouse.TargetFilter = nil;

            self.Values.PartSelected.Value:SetAttribute("IsPickedUp", false);
            
            Remotes.PickUpPart:FireServer(self.Values.PartSelected.Value, true);
            Remotes.ChangePartOwner:FireServer(false, self.Values.PartSelected.Value);

            RunService:UnbindFromRenderStep("HoldBlock");
        end
    end
end

function Placing:ZoomOut()
    Distance += 1;

    if Distance >= MaxDistance then
        Distance = MaxDistance;
    end
end

function Placing:ZoomIn()
    Distance -= 1;

    if Distance <= MinDistance then
        Distance = MinDistance;
    end
end

--||

return Placing;