-- 🔫 Pistola con Auto-Aim estilo Free Fire (Setup Completo)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPack = game:GetService("StarterPack")

-- Crear RemoteEvent si no existe
local remote = ReplicatedStorage:FindFirstChild("GunShoot")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "GunShoot"
    remote.Parent = ReplicatedStorage
end

-- Crear el arma Tool si no existe
local gun = StarterPack:FindFirstChild("Gun")
if not gun then
    gun = Instance.new("Tool")
    gun.Name = "Gun"
    gun.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,1,2)
    handle.Color = Color3.fromRGB(60,60,60)
    handle.Parent = gun

    gun.Parent = StarterPack

    -- LocalScript dentro del arma
    local localScript = Instance.new("LocalScript")
    localScript.Name = "GunClient"
    localScript.Source = [[
        local Tool = script.Parent
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local remote = game.ReplicatedStorage:WaitForChild("GunShoot")
        local mouse = LocalPlayer:GetMouse()

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

        Tool.Activated:Connect(function()
            local target = getClosestPlayer()
            if target then
                remote:FireServer(target.Position)
            else
                remote:FireServer(mouse.Hit.Position)
            end
        end)
    ]]
    localScript.Parent = gun
end

-- Crear Script del servidor si no existe
local serverGun = ServerScriptService:FindFirstChild("GunServer")
if not serverGun then
    serverGun = Instance.new("Script")
    serverGun.Name = "GunServer"
    serverGun.Source = [[
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remote = ReplicatedStorage:WaitForChild("GunShoot")

        remote.OnServerEvent:Connect(function(player, targetPos)
            if not player.Character or not player.Character:FindFirstChild("Head") then return end

            local origin = player.Character.Head.Position
            local direction = (targetPos - origin).Unit * 500

            local ray = Ray.new(origin, direction)
            local part, pos = workspace:FindPartOnRay(ray, player.Character)

            if part and part.Parent:FindFirstChild("Humanoid") then
                part.Parent.Humanoid:TakeDamage(35)
            end
        end)
    ]]
    serverGun.Parent = ServerScriptService
end

print("✅ Pistola con AutoAim lista en StarterPack")
