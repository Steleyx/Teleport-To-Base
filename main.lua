local player = game.Players.LocalPlayer
local savedPosition = nil
local flying = false

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Création ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Frame principale
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 250, 0, 220)
frame.Position = UDim2.new(0.5, -125, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local cornerMain = Instance.new("UICorner", frame)
cornerMain.CornerRadius = UDim.new(0, 15)

local strokeMain = Instance.new("UIStroke", frame)
strokeMain.Color = Color3.fromRGB(0,170,255)
strokeMain.Thickness = 2

-- Titre
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "POSITION MENU"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- SET POSITION
local setButton = Instance.new("TextButton", frame)
setButton.Size = UDim2.new(0.8,0,0,35)
setButton.Position = UDim2.new(0.1,0,0.30,0)
setButton.Text = "SET POSITION"
setButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
setButton.TextColor3 = Color3.fromRGB(255,255,255)
setButton.TextScaled = true
setButton.Font = Enum.Font.GothamBold
setButton.BorderSizePixel = 0
Instance.new("UICorner", setButton).CornerRadius = UDim.new(0,10)

-- TP BUTTON
local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(0.8,0,0,35)
tpButton.Position = UDim2.new(0.1,0,0.52,0)
tpButton.Text = "TP TO SAVED POSITION"
tpButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.TextScaled = true
tpButton.Font = Enum.Font.GothamBold
tpButton.BorderSizePixel = 0
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0,10)

-- KEYBIND LABELS
local keybindLabel = Instance.new("TextLabel", frame)
keybindLabel.Size = UDim2.new(1,0,0,20)
keybindLabel.Position = UDim2.new(0,0,0.75,0)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "G = TP  |  F = FLY"
keybindLabel.TextColor3 = Color3.fromRGB(180,180,180)
keybindLabel.TextScaled = true
keybindLabel.Font = Enum.Font.Gotham

---------------------------------------------------
-- TELEPORT FUNCTION
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

tpButton.MouseButton1Click:Connect(teleportToSaved)

---------------------------------------------------
-- FLY SYSTEM
---------------------------------------------------
local bodyVelocity
local bodyGyro
local speed = 60

local function startFlying()
	local character = player.Character
	if not character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
	bodyVelocity.Velocity = Vector3.new(0,0,0)
	bodyVelocity.Parent = hrp
	
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp
	
	flying = true
end

local function stopFlying()
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	flying = false
end

RunService.RenderStepped:Connect(function()
	if flying and player.Character then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		
		local moveDir = player.Character.Humanoid.MoveDirection
		bodyVelocity.Velocity = moveDir * speed
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
	end
end)

---------------------------------------------------
-- KEYBINDS
---------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.G then
		teleportToSaved()
	end
	
	if input.KeyCode == Enum.KeyCode.F then
		if flying then
			stopFlying()
		else
			startFlying()
		end
	end
end)
