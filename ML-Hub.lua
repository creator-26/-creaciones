
-- ML-Hub-VH COMPLETO (VisualHub, ocultable con RightShift)
local VisualHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/creator-26/-creaciones/refs/heads/main/VisualHub.lua"))()
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService('Workspace')
local Lighting = game:GetService('Lighting')
local main = VisualHub:Create('ML-Hub Completo')
local ypos = 50
[[ Deobfuscated by MLRTAKEN | Full Source Leak ]]

 local Lighting = game:GetService("Lighting")



 LocalPlayersFolder:AddSwitch("Auto Eat Protein Egg Every 30 Minutes", function(state)
     getgenv().autoEatProteinEggActive = state
     task.spawn(function()
         while getgenv().autoEatProteinEggActive and LocalPlayer.Character do
             local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg") or LocalPlayer.Character:FindFirstChild("Protein Egg")
                 ReplicatedStorage.muscleEvent:FireServer("rep")
 LocalPlayersFolder:AddSwitch("Auto Eat Protein Egg Every 1 hour", function(state)
     getgenv().autoEatProteinEggHourly = state
     task.spawn(function()
         while getgenv().autoEatProteinEggHourly and LocalPlayer.Character do
             local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg") or LocalPlayer.Character:FindFirstChild("Protein Egg")
                 ReplicatedStorage.muscleEvent:FireServer("rep")
 local MiscFolder = MainTab:AddFolder("Misc")
 MiscFolder:AddSwitch("Auto Farm (Equip Any tool)", function(state)
     task.spawn(function()
                     ReplicatedStorage.muscleEvent:FireServer("rep")
 MiscFolder:AddLabel("---Script Hub---")
 MiscFolder:AddButton("Permanent ShiftLock", function()
 MiscFolder:AddLabel("---Time---")
 MiscFolder:AddButton("Night", function()
     Lighting.ClockTime = 0
 MiscFolder:AddButton("Morning", function()
     Lighting.ClockTime = 6
 MiscFolder:AddButton("Day", function()
     Lighting.ClockTime = 12
 MiscFolder:AddLabel("----Farming----")
 AutoBrawlFolder:AddSwitch("Auto Win Brawl", function(state)
     task.spawn(function()
             ReplicatedStorage.rEvents.joinBrawl:FireServer("Win")
 AutoBrawlFolder:AddSwitch("Auto Join Brawl (For Farming)", function(state)
     task.spawn(function()
             ReplicatedStorage.rEvents.joinBrawl:FireServer("Farm")
 OpStuffFolder:AddSwitch("Anti Knockback", function(state)
     getgenv().antiKnockback = state
     LocalPlayer.CharacterAdded:Connect(function(char)
         if getgenv().antiKnockback then
OpStuffFolder:AddSwitch("Auto Pushups with Rock (10M) and Auto Punch", function(state)
     getgenv().autoPushups10M = state
     task.spawn(function()
         while getgenv().autoPushups10M and LocalPlayer.Character do
             local punch = LocalPlayer.Backpack:FindFirstChild("Pushups") or LocalPlayer.Character:FindFirstChild("Pushups")
                 ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                 ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
                 local rock = Workspace.machinesFolder:FindFirstChild("King Rock")
                 if rock and LocalPlayer:FindFirstChild("Durability") and LocalPlayer.Durability.Value >= 10000000 then
                     firetouchinterest(rock.Rock, LocalPlayer.Character.RightHand, 0)
                     firetouchinterest(rock.Rock, LocalPlayer.Character.LeftHand, 0)
                     firetouchinterest(rock.Rock, LocalPlayer.Character.RightHand, 1)
                     firetouchinterest(rock.Rock, LocalPlayer.Character.LeftHand, 1) 
 OpStuffFolder:AddSwitch("Free AutoLift Gamepass", function(state)
     task.spawn(function()
 OpStuffFolder:AddSwitch("Walk on Water", function(state)
 OpStuffFolder:AddButton("Remove Ad Portal", function()

 local KillingTab = Window:AddTab("Killing")
 KillingTab:AddSwitch("Auto Equip Punch", function(state)
     getgenv().autoEquipPunch = state
     task.spawn(function()
         while getgenv().autoEquipPunch and LocalPlayer.Character do
                 LocalPlayer.Character.Humanoid:UnequipTools()
 KillingTab:AddSwitch("Auto Punch {With Movement}", function(state)
     task.spawn(function()
                 ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                 ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
                 LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * 0.5
 KillingTab:AddSwitch("Auto Punch", function(state)
     task.spawn(function()
                 ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                 ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 KillingTab:AddSwitch("Unlock Fast Punch", function(state)
     getgenv().fastPunch = state
     task.spawn(function()
         while getgenv().fastPunch and LocalPlayer.Character do
                 ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                 ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 KillingTab:AddTextBox("Whitelist Player", function(name)
 KillingTab:AddButton("Clear Whitelist", function()
 KillingTab:AddSwitch("Auto Kill", function(state)
     getgenv().autokill = state
     task.spawn(function()
         while getgenv().autokill and LocalPlayer.Character do
                         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position)
                         ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                         ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 KillingTab:AddSwitch("Auto Kill Players", function(state)
     getgenv().autoKillPlayers = state
             task.spawn(function()
                 while getgenv().autoKillPlayers and player.Character and LocalPlayer.Character do
                         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position)
                         ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                         ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
     Players.PlayerRemoving:Connect(function(player)
         if getgenv().autoKillPlayers then
 KillingTab:AddDropdown("Players", function()
 KillingTab:AddTextBox("Kill Player", function(name)
         task.spawn(function()
                 LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position)
                 ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                 ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 KillingTab:AddLabel("---------------")
 KillingTab:AddTextBox("View Player", function(name)
         Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
 KillingTab:AddButton("Unview Player", function()
         Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid

 local StatsTab = Window:AddTab("Stats")
 local StatsFolder = StatsTab:AddFolder("Stats")
 StatsFolder:AddButton("Show Kills Gui", function()
     local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
     if leaderstats then
         local killsLabel = StatsFolder:AddLabel("Kills: " .. (leaderstats.Kills and leaderstats.Kills.Value or 0))
         local strengthLabel = StatsFolder:AddLabel("Strength: " .. (leaderstats.Strength and leaderstats.Strength.Value or 0))
         local durabilityLabel = StatsFolder:AddLabel("Durability: " .. (leaderstats.Durability and leaderstats.Durability.Value or 0))
         if leaderstats.Kills then
             leaderstats.Kills.Changed:Connect(function(value)
                 killsLabel.Text = "Kills: " .. value
         if leaderstats.Strength then
             leaderstats.Strength.Changed:Connect(function(value)
                 strengthLabel.Text = "Strength: " .. math.ceil(value)
         if leaderstats.Durability then
             leaderstats.Durability.Changed:Connect(function(value)
                 durabilityLabel.Text = "Durability: " .. value
         LocalPlayer.CharacterAdded:Connect(function()
             killsLabel:Destroy()
             strengthLabel:Destroy()
             durabilityLabel:Destroy()
         LocalPlayer.CharacterRemoving:Connect(function()
             killsLabel:Destroy()
             strengthLabel:Destroy()
             durabilityLabel:Destroy()
 StatsTab:AddFolder("Stats Gained")
 Players.PlayerAdded:Connect(function() end)
 Players.PlayerRemoving:Connect(function() end)

 AutoGymFolder:AddLabel("Jungle Gym")
     ["Jungle Bench"] = "autoJungleBench",
     AutoGymFolder:AddSwitch("Auto " .. machineName, function(state)
         task.spawn(function()
                     LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(machine.interactSeat.Position)
                     ReplicatedStorage.muscleEvent:FireServer("rep")
 local AutoEquipFolder = FarmPlusTab:AddFolder("Auto Equip Weight Tools")
     ["Auto Pushups"] = "Pushups",
 for label, toolName in pairs(toolSwitches) do
     AutoEquipFolder:AddSwitch(label, function(state)
         getgenv()[label] = state
         task.spawn(function()
             while getgenv()[label] and LocalPlayer.Character do
                     ReplicatedStorage.muscleEvent:FireServer("rep")

 EggsTab:AddTextBox("Select Pet", function(petName)
     getgenv().selectedPet = petName
 EggsTab:AddSwitch("Auto Buy Pet", function(state)
     getgenv().autoBuyPet = state
     task.spawn(function()
         while getgenv().autoBuyPet and LocalPlayer.Character do
           if getgenv().selectedPet then 
                 ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet")
                 ReplicatedStorage.rEvents.buyPetEvent:FireServer(getgenv().selectedPet)
 EggsTab:AddDropdown("Select Crystal", crystals, function(crystal)
 EggsTab:AddSwitch("Auto Hatch Crystal", function(state)
     getgenv().autoHatchCrystal = state
     task.spawn(function()
         while getgenv().autoHatchCrystal and LocalPlayer.Character do
                 ReplicatedStorage.rEvents.openCrystalRemote:InvokeServer("openCrystal", getgenv().crystal)

 PlayersTab:AddTextBox("Walkspeed", function(value)
     getgenv().ws = tonumber(value)
 PlayersTab:AddSwitch("Set Walkspeed", function(state)
     getgenv().setws = state
     task.spawn(function()         while getgenv().setws and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") do
             local ws = getgenv().ws or 16
             LocalPlayer.Character.Humanoid.WalkSpeed = ws
 PlayersTab:AddTextBox("JumpPower", function(value)
 PlayersTab:AddTextBox("HipHeight", function(value)
 PlayersTab:AddTextBox("Max Zoom Distance", function(value)
     LocalPlayer.CameraMaxZoomDistance = tonumber(value) or 128
 PlayersTab:AddLabel("--------")
 PlayersTab:AddSwitch("Lock Client Position", function(state)
         getgenv().lockedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
         getgenv().lockConnection = RunService.Heartbeat:Connect(function()
                 LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().lockedPos
 PlayersTab:AddButton("Remove Punch", function()
 PlayersTab:AddButton("Recover Punch", function()
 PlayersTab:AddSwitch("Infinite Jump", function(state)
     game:GetService("UserInputService").JumpRequest:Connect(function()
 PlayersTab:AddSwitch("Noclip", function(state)
     getgenv().noclip = state
         StarterGui:SetCore("SendNotification", {Title = "Player", Text = "Noclip enabled", Duration = 5})
         getgenv().noclipConnection = RunService.Stepped:Connect(function()
         StarterGui:SetCore("SendNotification", {Title = "Player", Text = "Noclip disabled", Duration = 5})
         if getgenv().noclipConnection then
             getgenv().noclipConnection:Disconnect()
 PlayersTab:AddButton("Anti AFK", function()
     game:GetService("VirtualUser").CaptureController:ClickButton2(Vector2.new())
     game:GetService("VirtualUser").Idled:Connect(function()
         game:GetService("VirtualUser").CaptureController:ClickButton2(Vector2.new())
 PlayersTab:AddButton("Anti Lag", function()
 PlayersTab:AddButton("ChatSpy", function()

 local CreditsTab = Window:AddTab("Credits")
 CreditsTab:AddLabel("This Script made by Doca")
 CreditsTab:AddLabel("Roblox: Xx_GPWArka")
 CreditsTab:AddLabel("Discord: itsdocas_60003")
 CreditsTab:AddButton("Copy Discord Invite link", function()

 BoostTab:AddSwitch("Auto Kill Good Karma", function(state)
     getgenv().autoKillGoodKarma = state
     task.spawn(function()
         while getgenv().autoKillGoodKarma and LocalPlayer.Character do
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position)
                     ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                     ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 BoostTab:AddSwitch("Auto Kill Evil Karma", function(state)
     getgenv().autoKillEvilKarma = state
     task.spawn(function()
         while getgenv().autoKillEvilKarma and LocalPlayer.Character do
                     LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position)
                     ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                     ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 BoostTab:AddLabel("Ring Aura")
 BoostTab:AddTextBox("Whitelist Player", function(name)
 BoostTab:AddButton("Clear Whitelist", function()
 BoostTab:AddTextBox("Ring Aura Radius", function(value)
     getgenv().ringAuraRadius = tonumber(value) or 10
 BoostTab:AddSwitch("Ring Aura", function(state)
     getgenv().ringAura = state
     task.spawn(function()
         while getgenv().ringAura and LocalPlayer.Character do
                     if distance <= (getgenv().ringAuraRadius or 10) then
                         ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                         ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
 BoostTab:AddLabel("Fast Rebirths")
 BoostTab:AddSwitch("Fast Rebirths | Required New Packs |", function(state)
     getgenv().fastRebirths = state
     task.spawn(function()
         while getgenv().fastRebirths and LocalPlayer.Character do
 BoostTab:AddSwitch("Fast Gain", function(state)
     getgenv().fastGain = state
     task.spawn(function()
         while getgenv().fastGain and LocalPlayer.Character do
             ReplicatedStorage.muscleEvent:FireServer("rep")
 BoostTab:AddSwitch("Hide Frames", function(state)
     getgenv().hideFrames = state
     task.spawn(function()
         while getgenv().hideFrames do
             for _, frame in pairs(game:GetService("CoreGui"):GetDescendants()) do
                 if frame:IsA("Frame") then
                     frame.Visible = false

 LocalPlayer.CharacterAdded:Connect(function(char)
     if getgenv().setws and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = getgenv().ws or 16
