local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= (getgenv().ringAuraRadius or 10) then
                        ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                        ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

KillingV2Tab:AddLabel("---Single Kill---")
KillingV2Tab:AddTextBox("Player Username", function(name)
    getgenv().targetPlayerName = name
end)
KillingV2Tab:AddSwitch("Auto Fast Kill Player", function(state)
    getgenv().autoFastKillPlayer = state
    task.spawn(function()
        while getgenv().autoFastKillPlayer and LocalPlayer.Character and getgenv().targetPlayerName do
            local target = Players:FindFirstChild(getgenv().targetPlayerName)
            if target and target.Character and target.Character.HumanoidRootPart then
                if getgenv().killMethod == "Teleport" then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position)
                end
                ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
            end
            task.wait(0.05)
        end
    end)
end)
KillingV2Tab:AddSwitch("Spy Player", function(state)
    getgenv().spyPlayer = state
    task.spawn(function()
        while getgenv().spyPlayer and getgenv().targetPlayerName do
            local target = Players:FindFirstChild(getgenv().targetPlayerName)
            if target and target.Character then
                Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
            end
            task.wait(1)
        end
        if LocalPlayer.Character then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    -- Aguarda o Humanoid para evitar nil errors
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        if getgenv().setWalkspeed then
            humanoid.WalkSpeed = getgenv().walkspeed or 16
        end
        if getgenv().jumpPower then
            humanoid.JumpPower = getgenv().jumpPower or 50
        end
        if getgenv().hipHeight then
            humanoid.HipHeight = getgenv().hipHeight or 0
        end
    end
end)