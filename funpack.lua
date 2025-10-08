-- mobilefun.lua | Roblox Mobile Edition
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local char = lp.Character or lp.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

----------- UTILIDADES -----------
local function makeBtn(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.fromOffset(70, 70)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(38, 50, 56)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Parent = lp:WaitForChild("PlayerGui"):WaitForChild("ScreenGui") or Instance.new("ScreenGui", lp.PlayerGui)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

----------- 1) CARPET FLY -----------
local carpet, flying
local function toggleFly()
    if flying and carpet then
        carpet:Destroy()
        flying = false
        return
    end
    carpet = Instance.new("Part")
    carpet.Size = Vector3.new(8, 1, 8)
    carpet.Material = Enum.Material.Fabric
    carpet.Color = Color3.new(1, 1, 1)
    carpet.Anchored = false
    carpet.CanCollide = true
    carpet.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
    carpet.Parent = workspace
    flying = true
    local bv = Instance.new("BodyVelocity", carpet)
    local bg = Instance.new("BodyGyro", carpet)
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    local function step()
        if not flying then return end
        local vel = Vector3.zero
        local look = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        local right = cam.CFrame.RightVector
        -- joystick virtual del móvil
        if UIS:IsKeyDown(Enum.KeyCode.Thumbstick1) then
            local thumb = UIS:GetMovementVector()
            vel = vel + right * thumb.X + look * -thumb.Y
        end
        bv.Velocity = vel * 60 + Vector3.yAxis * (UIS:IsKeyDown(Enum.KeyCode.ButtonR2) and 30 or 0) - Vector3.yAxis * (UIS:IsKeyDown(Enum.KeyCode.ButtonL2) and 30 or 0)
        bg.CFrame = cam.CFrame
    end
    local con; con = RS.Heartbeat:Connect(step)
    carpet.AncestryChanged:Connect(function() if not carpet.Parent then con:Disconnect() flying = false end end)
end

----------- 2) RAINBOW TRAIL -----------
local trailEnabled = false
local trailFolder = Instance.new("Folder", workspace) trailFolder.Name = "TrailM"
local last = root.Position
local function toggleTrail()
    trailEnabled = not trailEnabled
end
RS.Heartbeat:Connect(function()
    if not trailEnabled then return end
    local now = root.Position
    if (now - last).Magnitude > 3 then
        local p = Instance.new("Part")
        p.Size = Vector3.new(2, 1, 2)
        p.Position = now
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromHSV(tick() % 1, 1, 1)
        p.Parent = trailFolder
        game:GetService("Debris"):AddItem(p, 2.5)
        last = now
    end
end)

----------- 3) DOBLE-TAP TP -----------
local lastTap = 0
local function tapTP(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        local now = tick()
        if now - lastTap < 0.4 then -- doble tap
            local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 1000)
            local hit, pos = workspace:FindPartOnRay(ray, char)
            if pos then
                root.CFrame = CFrame.new(pos + Vector3.yAxis * 3)
            end
        end
        lastTap = now
    end
end
UIS.InputBegan:Connect(tapTP)

----------- UI MÓVIL -----------
makeBtn("FLY",   UDim2.new(0.75, 0, 0.7, 0), toggleFly)
makeBtn("TRAIL", UDim2.new(0.75, 0, 0.85, 0), toggleTrail)

print("MobileFun activado: FLY | TRAIL | Doble-tap para TP")
