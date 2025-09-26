--speed coil
_G.speedcoil = game:GetObjects('rbxassetid://99119158')[1]
_G.speedcoil.Parent = game.Players.LocalPlayer.Backpack
_G.speedcoil.Equipped:Connect(function()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
local Sound = Instance.new("Sound") 
local Id = "99173388"
Sound.Parent = game.Workspace
Sound.SoundId = "rbxassetid://"..Id
Sound.Playing = true
Sound.Looped = false
Sound.Volume = 1
end)
_G.speedcoil.Unequipped:Connect(function()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)
--gravity coil
_G.gravitycoil = game:GetObjects('rbxassetid://16688968')[1]
_G.gravitycoil.Parent = game.Players.LocalPlayer.Backpack
_G.gravitycoil.Equipped:Connect(function()
game.workspace.Gravity = 50
local Sound = Instance.new("Sound") 
local Id = "16619553"
Sound.Parent = game.Workspace
Sound.SoundId = "rbxassetid://"..Id
Sound.Playing = true
Sound.Looped = false
Sound.Volume = 1
end)
_G.gravitycoil.Unequipped:Connect(function()
game.workspace.Gravity = 196.2
end)