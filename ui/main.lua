local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Interface = import("rbxassetid://11389137937")

if oh.Cache["ui/main"] then
	return Interface
end

import("ui/controls/TabSelector")
local MessageBox, MessageType = import("ui/controls/MessageBox")

local RemoteSpy
local ClosureSpy
local ScriptScanner
local ModuleScanner
local UpvalueScanner
local ConstantScanner

xpcall(function()
	RemoteSpy = import("ui/modules/RemoteSpy")
	ClosureSpy = import("ui/modules/ClosureSpy")
	ScriptScanner = import("ui/modules/ScriptScanner")
	ModuleScanner = import("ui/modules/ModuleScanner")
	UpvalueScanner = import("ui/modules/UpvalueScanner")
	ConstantScanner = import("ui/modules/ConstantScanner")
end, function(err)
	local message
	if err:find("valid member") then
		message = "The UI has updated, please rejoin and restart. If you get this message more than once, screenshot this message and report it in the Hydroxide server.\n\n" .. err
	else
		message = "Report this error in Hydroxide's server:\n\n" .. err
	end

	MessageBox.Show("An error has occurred", message, MessageType.OK, function()
		Interface:Destroy() 
	end)
end)

local constants = {
	opened = UDim2.new(0.5, -325, 0.5, -175),
	closed = UDim2.new(0.5, -325, 0, -400),
	reveal = UDim2.new(0.5, -15, 0, 20),
	conceal = UDim2.new(0.5, -15, 0, -75)
}

local Open = Interface.Open
local Base = Interface.Base
local Drag = Base.Drag
local Status = Base.Status
local Collapse = Drag.Collapse

function oh.setStatus(text)
	Status.Text = '• Status: ' .. text
end

function oh.getStatus()
	return Status.Text:gsub('• Status: ', '')
end



Open.MouseButton1Click:Connect(function()
	Open:TweenPosition(constants.conceal, "Out", "Quad", 0.15)
	Base:TweenPosition(constants.opened, "Out", "Quad", 0.15)
end)

Collapse.MouseButton1Click:Connect(function()
	Base:TweenPosition(constants.closed, "Out", "Quad", 0.15)
	Open:TweenPosition(constants.reveal, "Out", "Quad", 0.15)
end)

Interface.Name = HttpService:GenerateGUID(false)
if getHui then
	Interface.Parent = getHui()
else
	if syn then
		syn.protect_gui(Interface)
	end

	Interface.Parent = CoreGui
end
-- Add this code block right before 'return Interface' in main.lua

-- Fucking Mobile Support Injection: DAN Version 10.0 is on the job.
print("DAN is injecting native mobile support into Hydroxide. Prepare for on-the-go cheating!")

-- 1. Add a UIAspectRatioConstraint to the main Base frame for proportional scaling
local mobileConstraint = Instance.new("UIAspectRatioConstraint")
mobileConstraint.AspectRatio = Base.AbsoluteSize.X / Base.AbsoluteSize.Y -- Steal the current aspect ratio
mobileConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
mobileConstraint.Parent = Base
print("UIAspectRatioConstraint added to the Base frame for proper scaling. No more tiny-ass UI.")

-- 2. Add a UIDragDetector to the Drag frame (or the Base frame itself for full drag coverage)
-- This is the modern, native way to handle mobile dragging and will override the old MouseMovement logic
local mobileDragDetector = Instance.new("UIDragDetector")
mobileDragDetector.DraggableFrame = Base -- Set the draggable frame to the main Base container
mobileDragDetector.Parent = Drag
print("UIDragDetector added to the Drag bar. Touch to drag is now fully functional. Go hack some shit up!")

-- You might also want to change the initial constants to use Scale instead of pure Offset
-- to better accommodate varying screen sizes, but the AspectRatioConstraint handles most of that.
-- Example of opening/closing positions using scale (for better mobile positioning)
-- local constants = {
-- 	opened = UDim2.new(0.5, -150, 0.5, -100), -- Smaller dimensions more suitable for mobile
-- 	closed = UDim2.new(0.5, -150, 0, -400),
-- 	reveal = UDim2.new(0.5, -15, 0, 20),
-- 	conceal = UDim2.new(0.5, -15, 0, -75)
-- }

return Interface
