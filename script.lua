-- Gui to Lua
-- Version: 3.2

-- Instances:

local LumberGui = Instance.new("ScreenGui")
local LumberFrame = Instance.new("Frame")
local DupeMoney = Instance.new("TextButton")
local SaveSlot = Instance.new("TextButton")
local LoadSlot = Instance.new("TextButton")
local SlotNumber = Instance.new("TextBox")

--Properties:

LumberGui.Name = "LumberGui"
LumberGui.Parent = LoginGui
LumberGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LumberGui.ResetOnSpawn = false

LumberFrame.Name = "LumberFrame"
LumberFrame.Parent = LumberGui
LumberFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
LumberFrame.BorderSizePixel = 0
LumberFrame.Position = UDim2.new(-0.999000013, 0, 0.542743504, 0)
LumberFrame.Size = UDim2.new(0, 178, 0, 224)

DupeMoney.Name = "DupeMoney"
DupeMoney.Parent = LumberFrame
DupeMoney.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DupeMoney.BorderColor3 = Color3.fromRGB(255, 255, 255)
DupeMoney.BorderSizePixel = 2
DupeMoney.Position = UDim2.new(0.0772919357, 0, 0.776785731, 0)
DupeMoney.Size = UDim2.new(0, 150, 0, 32)
DupeMoney.Font = Enum.Font.SourceSansBold
DupeMoney.Text = "Dupe Money"
DupeMoney.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeMoney.TextScaled = true
DupeMoney.TextSize = 14.000
DupeMoney.TextWrapped = true

SaveSlot.Name = "SaveSlot"
SaveSlot.Parent = LumberFrame
SaveSlot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SaveSlot.BorderColor3 = Color3.fromRGB(255, 255, 255)
SaveSlot.BorderSizePixel = 2
SaveSlot.Position = UDim2.new(0.0772919357, 0, 0.09375, 0)
SaveSlot.Size = UDim2.new(0, 53, 0, 32)
SaveSlot.Font = Enum.Font.SourceSansBold
SaveSlot.Text = "Save Slot"
SaveSlot.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveSlot.TextScaled = true
SaveSlot.TextSize = 14.000
SaveSlot.TextWrapped = true

LoadSlot.Name = "LoadSlot"
LoadSlot.Parent = LumberFrame
LoadSlot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LoadSlot.BorderColor3 = Color3.fromRGB(255, 255, 255)
LoadSlot.BorderSizePixel = 2
LoadSlot.Position = UDim2.new(0.622235775, 0, 0.09375, 0)
LoadSlot.Size = UDim2.new(0, 53, 0, 32)
LoadSlot.Font = Enum.Font.SourceSansBold
LoadSlot.Text = "Load Slot"
LoadSlot.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadSlot.TextScaled = true
LoadSlot.TextSize = 14.000
LoadSlot.TextWrapped = true

SlotNumber.Name = "SlotNumber"
SlotNumber.Parent = LumberFrame
SlotNumber.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
SlotNumber.BorderColor3 = Color3.fromRGB(255, 255, 255)
SlotNumber.BorderSizePixel = 2
SlotNumber.Position = UDim2.new(0.0772919357, 0, 0.415178567, 0)
SlotNumber.Size = UDim2.new(0, 149, 0, 37)
SlotNumber.Font = Enum.Font.SourceSansBold
SlotNumber.PlaceholderText = "Enter slot number"
SlotNumber.Text = ""
SlotNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
SlotNumber.TextScaled = true
SlotNumber.TextSize = 14.000
SlotNumber.TextWrapped = true

-- Scripts:

local function XHMMMS_fake_script() -- LumberFrame.LocalScript 
	local script = Instance.new('LocalScript', LumberFrame)

	local Slot = script.Parent.SlotNumber
	local DMoney = script.Parent.DupeMoney
	local SaveSlot = script.Parent.SaveSlot
	local Load = script.Parent.LoadSlot
	
	local MoneyCooldown = false
	local CurrentSlot = game.Players.LocalPlayer:WaitForChild("CurrentSaveSlot").Value
	local ScriptLoadOrSave = false
	local CurrentlySavingOrLoading = game.Players.LocalPlayer:WaitForChild("CurrentlySavingOrLoading")
	
	local function CheckIfSlotAvailable(Slot)
		for a,b in pairs(game.ReplicatedStorage.LoadSaveRequests.GetMetaData:InvokeServer(game.Players.LocalPlayer)) do
			if a == Slot then
				for c,d in pairs(b) do
					if c == "NumSaves" and d ~= 0 then
						return true
					else
						return false
					end
				end
			end
		end
	end
	
	local function CheckSlotNumber() --Checks if the slot number is right
		if Slot.Text == "1" or Slot.Text == "2" or Slot.Text == "3" or Slot.Text == "4" or Slot.Text == "5" or Slot.Text == "6" then
			local SlotNumber = tonumber(Slot.Text)
			return SlotNumber
		else return false
		end
	end
	
	local function SendNotification(Title,Text,Duration) -- Sends Notification in the bottom right of the screen
		game.StarterGui:SetCore("SendNotification", {
			Title = Title;
			Text = Text;
			Icon = nil;
			Duration = Duration
		})
	end
	
	SaveSlot.MouseButton1Down:connect(function() --Saves the slot that you want
		local CheckSlot = CheckSlotNumber()
		if CheckSlot ~= false then
			if CurrentSlot ~= -1 then
				ScriptLoadOrSave = true
				local SaveSlot = game.ReplicatedStorage.LoadSaveRequests.RequestSave:InvokeServer(CheckSlot)
				if SaveSlot == true then
					SendNotification("Save Notification", "Saved your Slot", 2)
					wait(.5)
					ScriptLoadOrSave = false
				elseif SaveSlot == false then
					SendNotification("Already Saving", "Saving/Loading is currently in Progress", 1)
					wait(.5)
					ScriptLoadOrSave = false
				end
			else
				SendNotification("Error", "Load Your Slot First before saving", 1)
			end
		else
			SendNotification("Incorrect Slot", "Enter a number in the upper field", 1)
		end
	end)
	
	Load.MouseButton1Down:connect(function() --Loads the slot you want
		ScriptLoadOrSave = true
		local CheckSlot = CheckSlotNumber()
		if CheckSlot ~= false then
			if CheckIfSlotAvailable(CheckSlot) == true then
				local LoadSlot = game.ReplicatedStorage.LoadSaveRequests.RequestLoad:InvokeServer(CheckSlot)
				if LoadSlot == false then
					SendNotification("Cooldown Notification", "You aren't abled to load now", 1)
				end
				if LoadSlot == true then
					SendNotification("Reload Notification", "Loaded Your Slot", 2)
					CurrentSlot = CheckSlot
				end
			else
				SendNotification("Slot not Available", "This Slot is not Available, please choose another slot", 2)
			end
		else
			SendNotification("Incorrect Slot", "Enter a Valid number in the upper field", 1)
		end
		ScriptLoadOrSave = false
	end)
	
	DMoney.MouseButton1Down:connect(function() --Sends the money and will come back after around 2 mins
		if MoneyCooldown == true then
			SendNotification("Cooldown Notification", "Wait for your Money to come back",2)
			return
		elseif MoneyCooldown == false then
			MoneyCooldown = true
			SendNotification("Money Sent", "Wait about 2 minutes for your Money to come back", 5)
			game.ReplicatedStorage.Transactions.ClientToServer.Donate:InvokeServer(game.Players.LocalPlayer, game.Players.LocalPlayer.leaderstats.Money.Value, 1)
			SendNotification("Money Received", "You received your money that you have sent earlier", 5)
			MoneyCooldown = false
		end
	end)
end
coroutine.wrap(XHMMMS_fake_script)()
