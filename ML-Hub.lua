
-- ML-Hub.lua (usando VisualHub custom: https://raw.githubusercontent.com/creator-26/-creaciones/refs/heads/main/VisualHub.lua)
local VisualHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/creator-26/-creaciones/refs/heads/main/VisualHub.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local main = VisualHub:Create("ML-Hub (Creative Edition)")
local ypos = 50

-- AUTO FARM
local autofarm = false
VisualHub:AddSwitch(main, "Auto Farm", function(state)
    autofarm = state
    if autofarm then
        spawn(function()
          while autofarm do
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
              if tool:IsA("Tool") then
                tool.Parent = LocalPlayer.Character
                ReplicatedStorage.muscleEvent:FireServer("rep")
                wait(0.11)
              end
            end
            wait(0.5)
          end
        end)
    end
end, ypos) ypos = ypos+40

-- PROTEIN EGG
VisualHub:AddButton(main, "Usar Protein Egg", function()
    local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg") or LocalPlayer.Character:FindFirstChild("Protein Egg")
    if egg then
        egg.Parent = LocalPlayer.Character
        ReplicatedStorage.muscleEvent:FireServer("rep")
    end
end, ypos) ypos = ypos+40

-- AUTO REBIRTH
local autorebirth = false
VisualHub:AddSwitch(main, "Auto Rebirth", function(state)
    autorebirth = state
    if autorebirth then
        spawn(function()
          while autorebirth do
            ReplicatedStorage.rebirthEvent:FireServer()
            wait(3)
          end
        end)
    end
end, ypos) ypos = ypos+40

-- AUTO JOIN BRAWL
local autobrawl = false
VisualHub:AddSwitch(main, "Auto Join Brawl", function(state)
    autobrawl = state
    if autobrawl then
        spawn(function()
          while autobrawl do
            ReplicatedStorage.rEvents.joinBrawl:FireServer()
            wait(1)
          end
        end)
    end
end, ypos) ypos = ypos+40

-- TIEMPO 
VisualHub:AddButton(main, "Noche", function() Lighting.ClockTime = 0 end, ypos) ypos = ypos+35
VisualHub:AddButton(main, "Mañana", function() Lighting.ClockTime = 6 end, ypos) ypos = ypos+35
VisualHub:AddButton(main, "Día", function() Lighting.ClockTime = 12 end, ypos) ypos = ypos+35

-- Puedes seguir agregando muchas más funciones usando VisualHub:AddSwitch o VisualHub:AddButton
-- por ejemplo: auto equip, aura punch, stat glitch, abrir huevos, auto gym, antilag, cámara, etc.
-- Usa el parámetro ypos para ir desplazando nuevos botones/switches.

--[[]]

-- Fin del ML-Hub
