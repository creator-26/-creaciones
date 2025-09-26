-- Perfecto para juegos de disparos
local function findClosestPlayer()
    local closest = nil
    local distance = math.huge
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local dist = (player.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
            if dist < distance then
                closest = player
                distance = dist
            end
        end
    end
    return closest
end
