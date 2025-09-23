-- AutoAim helper: devuelve una dirección (Vector3) ajustada hacia el objetivo más cercano
-- Parámetros ajustables:
local AIM_RANGE = 120       -- studs máximos para buscar objetivos
local AIM_ANGLE = 12        -- ángulo en grados (cuánto del centro de la mira se considera "cercano")

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

-- Devuelve true si 'part' pertenece a un character jugador con Humanoid y vida > 0
local function isValidTargetPart(part)
    if not part or not part.Parent then return false end
    local hum = part.Parent:FindFirstChild("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

-- main: obtiene dirección de auto-aim
-- player: LocalPlayer
-- originPos: Vector3 (punto de salida del disparo)
-- aimVector: Vector3 unitario (dirección "original" donde ibas a disparar)
-- return: Vector3 unitario (nueva dirección para disparar)
local function getAutoAimDirection(player, originPos, aimVector)
    -- seguridad
    if not player or not originPos or not aimVector then
        return aimVector or (Camera.CFrame.LookVector)
    end

    local bestTarget = nil
    local bestScore = math.huge -- menor es mejor (distancia en pantalla)
    local centerScreen = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            -- distancia 3D desde origin
            local worldDist = (hrp.Position - originPos).Magnitude
            if worldDist <= AIM_RANGE then
                -- proyectar al viewport para ver qué tan cerca está del centro
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                    -- convertir AIM_ANGLE (grados) a una tolerancia en píxeles aproximada:
                    -- esto es aproximado pero útil: a menor angulo -> menor pixel tolerancia
                    local pixelTolerance = (AIM_ANGLE / 90) * math.max(Camera.ViewportSize.X, Camera.ViewportSize.Y)
                    -- aceptar solo si está dentro del ángulo (o pantalla) y más cercano en pantalla
                    if screenDist <= pixelTolerance and screenDist < bestScore then
                        bestScore = screenDist
                        bestTarget = hrp
                    end
                end
            end
        end
    end

    if bestTarget then
        local dir = (bestTarget.Position - originPos)
        if dir.Magnitude == 0 then return aimVector end
        return dir.Unit
    end

    -- si no hay objetivo válido, devolvemos la dirección original
    return aimVector
end

-- ===== Ejemplo de uso dentro del Script de arma =====
-- local origin = Tool.Handle.Position
-- local rawDir = (mouse.Hit.p - origin).Unit  -- o Camera.CFrame.LookVector
-- local finalDir = getAutoAimDirection(Players.LocalPlayer, origin, rawDir)
-- usar finalDir para tu raycast o proyectil