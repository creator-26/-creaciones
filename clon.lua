-- Script en ServerScriptService

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        -- Esperar un poco a que cargue bien
        task.wait(2)

        -- Clonar el personaje
        local clon = char:Clone()
        clon.Name = player.Name .. "_Clone"
        clon.Parent = workspace

        -- Hacer que te siga
        while clon and clon:FindFirstChild("Humanoid") and char and char:FindFirstChild("HumanoidRootPart") do
            local humanoid = clon:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(2,0,2)) -- a tu costado
            end
            task.wait(0.5)
        end
    end)
end)
