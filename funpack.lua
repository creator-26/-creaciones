-- funpack.lua | compatible LuaU (Roblox)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

------------------------------------------------
-- A) Rainbow Trail
local trailFolder = Instance.new("Folder", workspace) trailFolder.Name = "Trail"
local last = root.Position
local TRAIL_SIZE = Vector3.new(2,1,2)
RunService.Heartbeat:Connect(function()
    local now = root.Position
    if (now - last).Magnitude > 3 then
        local p = Instance.new("Part")
        p.Size = TRAIL_SIZE
        p.Position = now
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromHSV(tick()%5/5,1,1)
        p.Parent = trailFolder
        last = now
        game:GetService("Debris"):AddItem(p,3)
    end
end)

------------------------------------------------
-- B) Flying Carpet
local carpet -- referencia
local flying = false
local speed = 50
local function toggleCarpet()
    if carpet and carpet.Parent then
        carpet:Destroy() flying = false return
    end
    carpet = Instance.new("Part")
    carpet.Size = Vector3.new(10,1,10)
    carpet.Material = Enum.Material.Fabric
    carpet.Color = Color3.new(1,1,1)
    carpet.Anchored = false
    carpet.CanCollide = true
    carpet.Name = "Carpet"
    carpet.CFrame = root.CFrame * CFrame.new(0,-3,0)
    carpet.Parent = workspace
    flying = true
    local bv = Instance.new("BodyVelocity", carpet)
    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    local bg = Instance.new("BodyGyro", carpet)
    bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    local function flyStep()
        if not flying or not carpet.Parent then return end
        local cam = workspace.CurrentCamera
        local vec = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then vec = vec + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vec = vec - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vec = vec - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vec = vec + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)   then vec = vec + Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vec = vec - Vector3.yAxis end
        bv.Velocity = vec * speed
        bg.CFrame = cam.CFrame
    end
    local con; con = RunService.Heartbeat:Connect(flyStep)
    carpet.AncestryChanged:Connect(function() if not carpet or not carpet.Parent then con:Disconnect() flying = false end end)
end
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.V then toggleCarpet() end
end)

------------------------------------------------
-- C) Click-Teleport
local mouse = lp:GetMouse()
mouse.Button1Down:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.yAxis * 5)
    elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        local target = mouse.Target
        if target then
            local hum2 = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
            if hum2 then
                root.CFrame = hum2.RootPart.CFrame
            end
        end
    end
end)

------------------------------------------------
print("FunPack cargado!  V = alfombra | Ctrl+Click = TP | Shift+Click = TP a jugador")
