local player = game.Players.LocalPlayer
local savedPosition = nil

local UserInputService = game:GetService("UserInputService")

-- Création ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Frame principale (menu)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 250, 0, 190)
frame.Position = UDim2.new(0.5, -125, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 15)
cornerMain.Parent = frame

local strokeMain = Instance.new("UIStroke")
strokeMain.Color = Color3.fromRGB(0,170,255)
strokeMain.Thickness = 2
strokeMain.Parent = frame

-- Titre
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "POSITION MENU"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Bouton SET POSITION
local setButton = Instance.new("TextButton")
setButton.Parent = frame
setButton.Size = UDim2.new(0.8,0,0,40)
setButton.Position = UDim2.new(0.1,0,0.32,0)
setButton.Text = "SET POSITION"
setButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
setButton.TextColor3 = Color3.fromRGB(255,255,255)
setButton.TextScaled = true
setButton.Font = Enum.Font.GothamBold
setButton.BorderSizePixel = 0

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0,10)
corner1.Parent = setButton

-- Bouton TP
local tpButton = Instance.new("TextButton")
tpButton.Parent = frame
tpButton.Size = UDim2.new(0.8,0,0,40)
tpButton.Position = UDim2.new(0.1,0,0.60,0)
tpButton.Text = "TP TO SAVED POSITION"
tpButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.TextScaled = true
tpButton.Font = Enum.Font.GothamBold
tpButton.BorderSizePixel = 0

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0,10)
corner2.Parent = tpButton

-- Petit texte KEYBIND
local keybindLabel = Instance.new("TextLabel")
keybindLabel.Parent = frame
keybindLabel.Size = UDim2.new(1,0,0,25)
keybindLabel.Position = UDim2.new(0,0,0.82,0)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "G = KEYBIND"
keybindLabel.TextColor3 = Color3.fromRGB(180,180,180)
keybindLabel.TextScaled = true
keybindLabel.Font = Enum.Font.Gotham

---------------------------------------------------
-- FONCTION TELEPORT
---------------------------------------------------
local function teleportToSaved()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") and savedPosition then
		character:MoveTo(savedPosition + Vector3.new(0,3,0))
	end
end

---------------------------------------------------
-- SET POSITION
---------------------------------------------------
setButton.MouseButton1Click:Connect(function()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		savedPosition = character.HumanoidRootPart.Position
		setButton.Text = "POSITION SAVED ✅"
		task.wait(1)
		setButton.Text = "SET POSITION"
	end
end)

---------------------------------------------------
-- BOUTON TP
---------------------------------------------------
tpButton.MouseButton1Click:Connect(function()
	teleportToSaved()
end)

---------------------------------------------------
-- KEYBIND G
---------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.G then
		teleportToSaved()
	end
end)
