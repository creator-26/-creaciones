-- Mini Hub de Farmeo
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Mini Farm", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local farming = false

-- Función para esperar un tiempo aleatorio (anti-ban básico)
local function randomWait(min, max)
    wait(math.random(min, max))
end

-- Función de farmeo
local function farm()
    while farming do
        local orbes = workspace:FindFirstChild("Orbes") or workspace:FindFirstChild("Coins") or workspace:FindFirstChild("Gems")
        if orbes then
            for _, obj in ipairs(orbes:GetChildren()) do
                if obj:IsA("BasePart") then
                    local player = game.Players.LocalPlayer.Character
                    if player and player:FindFirstChild("HumanoidRootPart") then
                        player.HumanoidRootPart.CFrame = obj.CFrame
                        randomWait(0.1, 0.3)
                        firetouchinterest(player.HumanoidRootPart, obj, 0)
                        randomWait(0.05, 0.15)
                        firetouchinterest(player.HumanoidRootPart, obj, 1)
                    end
                end
            end
        end
        randomWait(1, 2)
    end
end

-- Botones del hub
Tab:AddButton({
    Name = "Iniciar Farm",
    Callback = function()
        if not farming then
            farming = true
            farm()
        end
    end    
})

Tab:AddButton({
    Name = "Parar Farm",
    Callback = function()
        farming = false
    end    
})

OrionLib:Init()
