---------------------------------------------------
-- CLEAN FLY SYSTEM (UPGRADE)
---------------------------------------------------

local bodyVelocity
local bodyGyro
local flySpeed = 0
local maxSpeed = 70
local acceleration = 3

local function startFlying()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = hrp

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bodyGyro.P = 10000
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	flying = true
end

local function stopFlying()
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end

	flying = false
	flySpeed = 0
end

RunService.RenderStepped:Connect(function()
	if flying and player.Character then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if not hrp or not humanoid then return end

		local moveDir = humanoid.MoveDirection

		if moveDir.Magnitude > 0 then
			flySpeed = math.min(maxSpeed, flySpeed + acceleration)
		else
			flySpeed = math.max(0, flySpeed - acceleration * 2)
		end

		local camCF = workspace.CurrentCamera.CFrame
		local direction = camCF:VectorToWorldSpace(moveDir)

		bodyVelocity.Velocity = direction * flySpeed
		bodyGyro.CFrame = camCF
	end
end)
