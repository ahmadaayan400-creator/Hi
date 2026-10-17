--// THE KING'S V3 - SETUP SEQUENCE (LocalScript)
--// Replaces the old intro. Paste this where the old INTRO section was.
--// Afterwards you have: playerName, gangName, targetName (local variables)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CLEAN OLD COPIES (no duplicates on re-execute)
--==================================================
local oldGui = PlayerGui:FindFirstChild("KINGS_V3_SETUP")
if oldGui then oldGui:Destroy() end
local oldBlur = Lighting:FindFirstChild("KINGS_V3_BLUR")
if oldBlur then oldBlur:Destroy() end

local setupGui = Instance.new("ScreenGui")
setupGui.Name = "KINGS_V3_SETUP"
setupGui.ResetOnSpawn = false
setupGui.IgnoreGuiInset = true
setupGui.DisplayOrder = 500
setupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
setupGui.Parent = PlayerGui

local blur = Instance.new("BlurEffect")
blur.Name = "KINGS_V3_BLUR"
blur.Size = 0
blur.Parent = Lighting

--==================================================
-- THEME
--==================================================
local BLUE = Color3.fromRGB(0, 170, 255)
local PURPLE = Color3.fromRGB(160, 60, 255)
local PINK = Color3.fromRGB(235, 60, 255)
local DARK = Color3.fromRGB(8, 8, 20)
local FIELD = Color3.fromRGB(16, 16, 36)
local MUTED = Color3.fromRGB(150, 150, 190)

local function gradient(parent, c0, c1, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c0, c1)
	g.Rotation = rotation or 0
	g.Parent = parent
	return g
end

local function tween(obj, t, props, style, dir)
	local tw = TweenService:Create(
		obj,
		TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props
	)
	tw:Play()
	return tw
end

--==================================================
-- AVATAR
--==================================================
local avatarImage = ""
do
	local ok, img = pcall(function()
		return Players:GetUserThumbnailAsync(
			player.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size150x150
		)
	end)
	if ok and img then avatarImage = img end
end

--==================================================
-- ONE STEP (returns the submitted text, or nil if closed)
--==================================================
local function runStep(heading, subtitle, placeholder, iconText, buttonText)
	local result = nil
	local submitted = false
	local finished = Instance.new("BindableEvent")

	local card = Instance.new("CanvasGroup")
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.new(0.5, 0, 0.5, 0)
	card.Size = UDim2.new(0, 360, 0, 330)
	card.BackgroundColor3 = DARK
	card.BorderSizePixel = 0
	card.GroupTransparency = 1
	card.Parent = setupGui

	local sizeLimit = Instance.new("UISizeConstraint")
	sizeLimit.MaxSize = Vector2.new(360, 330)
	sizeLimit.Parent = card

	local scale = Instance.new("UIScale")
	scale.Scale = 0.85
	scale.Parent = card

	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 20)

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2.5
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Parent = card
	local strokeGrad = gradient(stroke, BLUE, PINK, 0)

	gradient(card, Color3.fromRGB(12, 10, 30), Color3.fromRGB(5, 5, 14), 90)

	-- avatar ring
	local ring = Instance.new("Frame")
	ring.AnchorPoint = Vector2.new(0.5, 0)
	ring.Position = UDim2.new(0.5, 0, 0, 18)
	ring.Size = UDim2.new(0, 84, 0, 84)
	ring.BackgroundColor3 = Color3.fromRGB(10, 20, 60)
	ring.BorderSizePixel = 0
	ring.Parent = card
	Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
	local ringStroke = Instance.new("UIStroke")
	ringStroke.Thickness = 3
	ringStroke.Color = Color3.new(1, 1, 1)
	ringStroke.Parent = ring
	local ringGrad = gradient(ringStroke, BLUE, PINK, 45)

	local avatar = Instance.new("ImageLabel")
	avatar.AnchorPoint = Vector2.new(0.5, 0.5)
	avatar.Position = UDim2.new(0.5, 0, 0.5, 0)
	avatar.Size = UDim2.new(1, -10, 1, -10)
	avatar.BackgroundTransparency = 1
	avatar.Image = avatarImage
	avatar.ScaleType = Enum.ScaleType.Crop
	avatar.Parent = ring
	Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

	-- heading
	local head = Instance.new("TextLabel")
	head.AnchorPoint = Vector2.new(0.5, 0)
	head.Position = UDim2.new(0.5, 0, 0, 112)
	head.Size = UDim2.new(1, -30, 0, 34)
	head.BackgroundTransparency = 1
	head.Text = heading
	head.TextColor3 = Color3.new(1, 1, 1)
	head.Font = Enum.Font.GothamBlack
	head.TextScaled = true
	head.Parent = card
	local headLimit = Instance.new("UITextSizeConstraint")
	headLimit.MaxTextSize = 24
	headLimit.MinTextSize = 12
	headLimit.Parent = head
	gradient(head, BLUE, PINK, 0)

	local sub = Instance.new("TextLabel")
	sub.AnchorPoint = Vector2.new(0.5, 0)
	sub.Position = UDim2.new(0.5, 0, 0, 148)
	sub.Size = UDim2.new(1, -40, 0, 18)
	sub.BackgroundTransparency = 1
	sub.Text = subtitle
	sub.TextColor3 = MUTED
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 13
	sub.Parent = card

	-- input
	local field = Instance.new("Frame")
	field.AnchorPoint = Vector2.new(0.5, 0)
	field.Position = UDim2.new(0.5, 0, 0, 182)
	field.Size = UDim2.new(1, -40, 0, 44)
	field.BackgroundColor3 = FIELD
	field.BorderSizePixel = 0
	field.Parent = card
	Instance.new("UICorner", field).CornerRadius = UDim.new(0, 12)
	local fieldStroke = Instance.new("UIStroke")
	fieldStroke.Thickness = 1.5
	fieldStroke.Color = Color3.fromRGB(80, 50, 200)
	fieldStroke.Parent = field

	local icon = Instance.new("TextLabel")
	icon.Position = UDim2.new(0, 10, 0, 0)
	icon.Size = UDim2.new(0, 28, 1, 0)
	icon.BackgroundTransparency = 1
	icon.Text = iconText
	icon.TextSize = 18
	icon.TextColor3 = MUTED
	icon.Font = Enum.Font.GothamBold
	icon.Parent = field

	local box = Instance.new("TextBox")
	box.Position = UDim2.new(0, 42, 0, 0)
	box.Size = UDim2.new(1, -52, 1, 0)
	box.BackgroundTransparency = 1
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(120, 120, 160)
	box.Text = ""
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.GothamMedium
	box.TextSize = 15
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ClearTextOnFocus = false
	box.ClipsDescendants = true
	box.Parent = field

	-- button
	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(0.5, 0)
	button.Position = UDim2.new(0.5, 0, 0, 242)
	button.Size = UDim2.new(1, -40, 0, 46)
	button.BackgroundColor3 = Color3.new(1, 1, 1)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Text = buttonText .. "  →"
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBlack
	button.TextSize = 17
	button.Parent = card
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)
	gradient(button, Color3.fromRGB(20, 130, 255), Color3.fromRGB(180, 40, 255), 0)
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1.5
	btnStroke.Color = Color3.fromRGB(0, 230, 255)
	btnStroke.Parent = button

	local hint = Instance.new("TextLabel")
	hint.AnchorPoint = Vector2.new(0.5, 0)
	hint.Position = UDim2.new(0.5, 0, 0, 298)
	hint.Size = UDim2.new(1, -40, 0, 18)
	hint.BackgroundTransparency = 1
	hint.Text = "Press Enter to continue"
	hint.TextColor3 = MUTED
	hint.Font = Enum.Font.Gotham
	hint.TextSize = 12
	hint.Parent = card

	-- close button
	local close = Instance.new("TextButton")
	close.Position = UDim2.new(1, -38, 0, 10)
	close.Size = UDim2.new(0, 28, 0, 28)
	close.BackgroundColor3 = FIELD
	close.Text = "✕"
	close.TextColor3 = Color3.new(1, 1, 1)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 14
	close.AutoButtonColor = false
	close.ZIndex = 5
	close.Parent = card
	Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
	local closeStroke = Instance.new("UIStroke")
	closeStroke.Thickness = 1
	closeStroke.Color = Color3.fromRGB(80, 80, 140)
	closeStroke.Parent = close

	-- animated border / ring
	local alive = true
	task.spawn(function()
		local rot = 0
		while alive and card.Parent do
			rot = (rot + 2) % 360
			strokeGrad.Rotation = rot
			ringGrad.Rotation = -rot
			task.wait(0.03)
		end
	end)

	-- hover effects
	button.MouseEnter:Connect(function()
		tween(button, 0.15, { Size = UDim2.new(1, -34, 0, 48) })
	end)
	button.MouseLeave:Connect(function()
		tween(button, 0.15, { Size = UDim2.new(1, -40, 0, 46) })
	end)
	box.Focused:Connect(function()
		tween(fieldStroke, 0.2, { Color = Color3.fromRGB(0, 200, 255) })
	end)
	box.FocusLost:Connect(function()
		tween(fieldStroke, 0.2, { Color = Color3.fromRGB(80, 50, 200) })
	end)

	-- animate in
	tween(blur, 0.5, { Size = 20 })
	tween(card, 0.45, { GroupTransparency = 0 })
	tween(scale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)

	-- animate out + finish
	local function closeCard(value)
		if submitted then return end
		submitted = true
		result = value
		alive = false
		tween(card, 0.3, { GroupTransparency = 1 })
		local out = tween(scale, 0.3, { Scale = 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		out.Completed:Wait()
		card:Destroy()
		finished:Fire()
	end

	local function shake()
		local origin = field.Position
		for _, dx in ipairs({ 8, -8, 5, -5, 0 }) do
			field.Position = origin + UDim2.new(0, dx, 0, 0)
			task.wait(0.03)
		end
		field.Position = origin
	end

	local function trySubmit()
		if submitted then return end
		local text = box.Text:gsub("^%s+", ""):gsub("%s+$", "")
		if text == "" then
			tween(fieldStroke, 0.1, { Color = Color3.fromRGB(255, 70, 90) })
			task.spawn(shake)
			box.PlaceholderText = "This field can't be empty"
			task.delay(0.8, function()
				if not submitted then
					tween(fieldStroke, 0.2, { Color = Color3.fromRGB(80, 50, 200) })
					box.PlaceholderText = placeholder
				end
			end)
			return
		end
		task.spawn(closeCard, text)
	end

	button.Activated:Connect(trySubmit)
	box.FocusLost:Connect(function(enterPressed)
		if enterPressed then trySubmit() end
	end)
	close.Activated:Connect(function()
		task.spawn(closeCard, nil)
	end)

	finished.Event:Wait()
	finished:Destroy()
	return result
end

--==================================================
-- STATUS TOAST
--==================================================
local function showStatus(text, good)
	local toast = Instance.new("CanvasGroup")
	toast.AnchorPoint = Vector2.new(0.5, 0)
	toast.Position = UDim2.new(0.5, 0, 0, -60)
	toast.Size = UDim2.new(0, 300, 0, 48)
	toast.BackgroundColor3 = DARK
	toast.BorderSizePixel = 0
	toast.GroupTransparency = 1
	toast.Parent = setupGui
	Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 14)
	local s = Instance.new("UIStroke")
	s.Thickness = 2
	s.Color = good and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(255, 170, 60)
	s.Parent = toast
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -16, 1, 0)
	l.Position = UDim2.new(0, 8, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.new(1, 1, 1)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 14
	l.TextWrapped = true
	l.Parent = toast

	tween(toast, 0.4, { Position = UDim2.new(0.5, 0, 0, 30), GroupTransparency = 0 }, Enum.EasingStyle.Back)
	task.delay(4, function()
		local out = tween(toast, 0.4, { Position = UDim2.new(0.5, 0, 0, -60), GroupTransparency = 1 })
		out.Completed:Wait()
		toast:Destroy()
	end)
end

--==================================================
-- CHAT HELPER
--==================================================
local function getChannel()
	if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
		return nil
	end
	local channels = TextChatService:FindFirstChild("TextChannels")
	if not channels then
		channels = TextChatService:WaitForChild("TextChannels", 5)
	end
	if not channels then return nil end
	return channels:FindFirstChild("RBXGeneral") or channels:WaitForChild("RBXGeneral", 5)
end

local function sendChat(channel, message)
	if not channel then return false end
	local ok, err = pcall(function()
		channel:SendAsync(message)
	end)
	if not ok then
		warn("[V3] Chat message failed: " .. tostring(err))
	end
	return ok
end

--==================================================
-- RUN THE THREE STEPS
--==================================================
local playerName = runStep("ENTER YOUR NAME", "Your name will be used in the script", "Enter your name...", "👤", "ENTER")
local gangName, targetName

if playerName then
	gangName = runStep("ENTER YOUR GANG NAME", "Your gang name will be used in the script", "Enter your gang name...", "👥", "ENTER")
end
if gangName then
	targetName = runStep("ENTER YOUR TARGET NAME", "Type the name you want to mention", "Enter target name...", "🎯", "ENTER")
end

-- remove blur smoothly (only ours)
local blurOut = tween(blur, 0.5, { Size = 0 })
blurOut.Completed:Connect(function()
	if blur then blur:Destroy() end
end)

if not (playerName and gangName and targetName) then
	-- user closed the setup; stop here
	task.delay(0.6, function() setupGui:Destroy() end)
	return
end

--==================================================
-- CHAT MESSAGES (2 seconds apart, sent once)
--==================================================
local channel = getChannel()

local sent1 = sendChat(
	channel,
	"SCRIPT BY " .. playerName .. " _________________________THE KING'S V3 IS HERE_________________________MADE BY " .. playerName .. "___V3 LOADED"
)

task.wait(2)

local sent2 = sendChat(
	channel,
	"THE FATHER OF " .. targetName .. " TERA BAP AGYA 🥰😭 ___" .. gangName .. " ON TOP"
)

--==================================================
-- FINAL STATUS
--==================================================
if sent1 and sent2 then
	showStatus("V3 LOADED  •  by " .. playerName, true)
else
	showStatus("V3 LOADED  •  by " .. playerName .. "  (chat message not sent)", false)
end

-- playerName, gangName, targetName are now available below this point.
