--|| Variables

local UIS = game:GetService("UserInputService");

local ReplicatedStorage = game.ReplicatedStorage;
local Modules = ReplicatedStorage.Modules;

local PlacingModule = require(Modules.Placing).new();

--||

--|| Input Listener

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.E then
        PlacingModule:Toggle();
    end
end)

--||