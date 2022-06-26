--|| Variables

local Placing = {};
Placing.__index = Placing;

local SpawnCF = nil;
local Height = 0;

--||

--|| Functions

local function MouseRay(BlackList: Instance)
    local UIS = game:GetService("UserInputService");
    local Camera = workspace.CurrentCamera;

    local MousePos = UIS:GetMouseLocation();
    local MouseRC = Camera:ViewportPointToRay(MousePos.X, MousePos.Y);

    local RayParams = RaycastParams.new();
    RayParams.FilterType = Enum.RaycastFilterType.Blacklist;
    RayParams.FilterDescendantsInstances = {BlackList};

    local RayResult = workspace:Raycast(MouseRC.Origin, MouseRC.Direction * 500, RayParams);

    return RayResult;
end

local function HoldPart(TargetPart: Instance)
    local player = game.Players.LocalPlayer;
    local character = player.Character;
    local mouse = player:GetMouse();

    local ReplicatedStorage = game.ReplicatedStorage;
    local Remotes = ReplicatedStorage.Remotes;

    local Size = Vector3.new(TargetPart.Size.X, TargetPart.Size.Y, TargetPart.Size.Z);

    mouse.TargetFilter = TargetPart;

    SpawnCF = CFrame.new(mouse.Hit.Position.X, mouse.Hit.Position.Y + Size.Y / 2 + Height, mouse.Hit.Position.Z);

    Remotes.PickUpPart:FireServer(SpawnCF, TargetPart);
    Remotes.ChangePartOwner:FireServer(true, TargetPart);
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
                    RunService:BindToRenderStep("HoldBlock", Enum.RenderPriority.Input.Value, function() HoldPart(TargetPart) end);
                end      
            end
        end
    else
        if self.Values.PartSelected.Value:GetAttribute("HeldBy") == self.Name then
            self.Mouse.TargetFilter = nil;

            self.Values.PartSelected.Value:SetAttribute("IsPickedUp", false);
            Remotes.ChangePartOwner:FireServer(false, self.Values.PartSelected.Value);

            RunService:UnbindFromRenderStep("HoldBlock");
        end
    end
end

--||

return Placing;