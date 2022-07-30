--|| Variables

local player = game.Players.LocalPlayer;
local mouse = player:GetMouse();

local UIS = game:GetService("UserInputService");

local ReplicatedStorage = game.ReplicatedStorage;
local Modules = ReplicatedStorage.Modules;

local PlacingModule = require(Modules.Placing).new();

--||

--|| Input Listener

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.E then
        PlacingModule:Toggle();
    elseif input.KeyCode == Enum.KeyCode.Q then
        PlacingModule:Throw();
    end
end)

mouse.WheelForward:Connect(function()
    PlacingModule:ZoomOut();
end)

mouse.WheelBackward:Connect(function()
    PlacingModule:ZoomIn();
end)

--||