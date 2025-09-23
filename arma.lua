-- 🔫 Pistola con Auto-Aim estilo Free Fire (LocalScript)
local Tool = script.Parent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera
local remote = game.ReplicatedStorage:WaitForChild("GunShoot")

-- función para encontrar jugador más cercano al centro de pantalla
local function getClosestPlayer()
    local closest, closestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local screenPos = Vector2.new(pos.X, pos.Y)
                local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                local dist = (screenPos - center).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = hrp
                end
            end
        end
    end
    return closest
end

-- cuando se dispara
Tool.Activated:Connect(function()
    local target = getClosestPlayer()
    if target then
        remote:FireServer(target.Position) -- auto-aim al jugador más cercano
    else
        remote:FireServer(mouse.Hit.Position) -- normal si no hay nadie
    end
end)
