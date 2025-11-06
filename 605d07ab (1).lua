--[[ Deobfuscated by MLRTAKEN | Full Source Leak ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= (getgenv().ringAuraRadius or 10) then
                        ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                        ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)
BoostTab:AddLabel("Fast Rebirths")
BoostTab:AddSwitch("Fast Rebirths | Required New Packs |", function(state)
    getgenv().fastRebirths = state
    task.spawn(function()
        while getgenv().fastRebirths and LocalPlayer.Character do
            ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            task.wait(0.1)
        end
    end)
end)
BoostTab:AddSwitch("Fast Gain", function(state)
    getgenv().fastGain = state
    task.spawn(function()
        while getgenv().fastGain and LocalPlayer.Character do
            ReplicatedStorage.muscleEvent:FireServer("rep")
            task.wait(0.05)
        end
    end)
end)
BoostTab:AddSwitch("Hide Frames", function(state)
    getgenv().hideFrames = state
    task.spawn(function()
        while getgenv().hideFrames do
            for _, frame in pairs(game:GetService("CoreGui"):GetDescendants()) do
                if frame:IsA("Frame") then
                    frame.Visible = false
                end
            end
            task.wait(0.1)
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if getgenv().setws and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = getgenv().ws or 16
    end
    if getgenv().jumpPower and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = getgenv().jumpPower or 50
    end
    if getgenv().hipHeight and char:FindFirstChild("Humanoid") then
        char.Humanoid.HipHeight = getgenv().hipHeight or 0
    end
end)