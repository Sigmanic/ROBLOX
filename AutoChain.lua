--[[
	The Biggest Technical Update!
	This update took a long time due to I had to finish my final examination and also lost motivation.
	Changelog:
	+Added:
	++ New Remade SelectedTower() function and Status System.
	+ Tweak a bit of CheckDistant() function.
	+ Supported low level commander, so instead of skipping it, now it will loop active ability in 10s and skip it when the ability doesn't active it in 10s.
	+ Added getgenv().KeepTracking, keep tracking getgenv().troops and updated it when a commander removed or added, even after the gui already deleted.
	+ Added Delete Gui button.
	+ Added Executed Check, prevents script from errors, can be disabled using Delete Gui button.
	+ Added getgenv().DebugModes, print all information about a function is working.
	*Changed, Fixed:
	* Changed Chain() function, now it will stop at the next commander when disabled, instead of running through a loop then stopped
	* Changed getgenv().troops, so it can work with new remade SelectedTower().
	* Change TowerAdded(), made it selected faster.
	* Fixed error in TowerRemoved() function.
	==============================Credits==============================
	This Script Is Open-source, Feel Free To Change Anything.
	Credit: Sigmanic (Sigmanic#6607 --Main Account, Thomas Andrew#8787 --Second Account)
]]--
if game.PlaceId ~= 5591597781 then return end
--getgenv().PreferDouble = true	--Remove the first "--" if you want to use double chain.
getgenv().KeepTracking = true	--Recommended turn this on.
getgenv().DebugModes = false

if getgenv().AlrExecAC then
	game.StarterGui:SetCore("SendNotification", {
	Title = "Auto Chain",
	Text = "Script Already Executed.";
	Duration = 6;
	})
	return
end
getgenv().AlrExecAC = true
if not getgenv().troops then
	getgenv().troops = {		--Contain number and tower instance
		[1] = {1},
		[2] = {2},
		[3] = {3},
		[4] = {4},
		[5] = {5},
		[6] = {6}
	}
end
function prints(...)
	if DebugModes then
		return print(...)
	else
		return
	end
end
if KeepTracking and typeof(getgenv().TowerAdded) == "RBXScriptConnection" and typeof(getgenv().TowerRemoved) == "RBXScriptConnection" then
	prints("deleted TowerAdded,TowerRemoved")
	getgenv().TowerAdded:Disconnect()
	getgenv().TowerRemoved:Disconnect()
end

local CancelLoop = false
local StatusTable = {}
getgenv().TowerAdded = nil
getgenv().TowerRemoved = nil
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
local w = library:CreateWindow('Auto Chain')
w:Toggle('Active Auto Chain', {flag = "autochain"},function(value) StatusTable["autochain"] = value end)
StatusTable[1] = w:Section('Commander 1: None')
StatusTable[2] = w:Section('Commander 2: None')
StatusTable[3] = w:Section('Commander 3: None')
w:Button("Delete Gui",function()
	w["object"].Parent.Parent:Destroy()
	CancelLoop = true
	if not KeepTracking then
		getgenv().TowerAdded:Disconnect()
		getgenv().TowerRemoved:Disconnect()
	end
	StatusTable = nil
	getgenv().AlrExecAC = false
end)
local function Status(Index,Text)
	if not StatusTable then
		return
	elseif StatusTable[Index] == nil then
		return prints(Index,"Doesn't existed")
	else
		if type(Text) == "string" then
			StatusTable[Index].Text = tostring(Text)
			return
		else 
			return StatusTable[Index]
		end
	end
end
for i,v in next,troops do
	local Values = v[2]
	if Values and Status(i) then
		prints("Status",i,v[2])
		Status(i,"Commander "..i..": Selected")
	end
end
function SelectedTower(Tower,Value)
	if Value == true then --Select Tower
		for i=1,#troops do
			if Tower == troops[i][2] then
				prints("SelectedTower()",Tower,"Already Existed")
				return
			end
		end
		for i,v in ipairs(troops) do
			if not v[2] and Status(i) then
				prints("SelectedTower()",Tower,i)
				table.insert(troops[i],2,Tower)
				Status(i,"Commander "..i..": Selected")
				return
			end
		end
	elseif Value == false then --Remove Tower
		for i,v in next,troops do
			local Values = v[2]
			if Values == Tower then
				table.remove(troops[i],2)
				Status(i,"Commander "..i..": None")
			end
		end
	end
end
for i,v in pairs(game:GetService("Workspace").Towers:GetChildren()) do
	if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game:GetService("Players").LocalPlayer.UserId and v.TowerReplicator:GetAttribute("Type") == "Commander" then
		prints(v,"Added1")
		--SelectedTower(v,true)
		task.spawn(SelectedTower,v,true)
	end
end
getgenv().TowerAdded = game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
	wait(.25)
	if not v:FindFirstChild("TowerReplicator") then
		repeat wait() until v:FindFirstChild("TowerReplicator")
	end
	if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game:GetService("Players").LocalPlayer.UserId and v.TowerReplicator:GetAttribute("Type") == "Commander" then
		prints("TowerAdded",v,"Added")
		--SelectedTower(v,true)
		task.spawn(SelectedTower,v,true)
	end
end)
getgenv().TowerRemoved = game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
	if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game:GetService("Players").LocalPlayer.UserId and v.TowerReplicator:GetAttribute("Type") == "Commander" then
		prints("TowerRemoved",v,"Removed")
		--SelectedTower(v,false)
		task.spawn(SelectedTower,v,false)
	end
	task.wait()
end)
local function Chain(Tower,Type)
	if CancelLoop then
		prints("CancelLoop 1",CancelLoop)
		return 
	end
	local Info = Tower[1]
	if not Status(Type) then
		Status(Info,"Commander "..Info..": Prepare")
		repeat task.wait() until Status(Type)
	end
	local Tower = Tower[2]
	if Tower then
		if Tower.TowerReplicator:GetAttribute("Upgrade") >= 2 then
			if not Tower.TowerReplicator.Stuns:GetAttribute("1") or Tower.TowerReplicator.Stuns:GetAttribute("1") == false and Tower.TowerReplicator:GetAttribute("Upgrade") >= 2 then
				game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"] = Tower ,["Name"] = "Call Of Arms"})
				Status(Info,"Commander "..Info..": Actived")
				task.wait(10.01)
				Status(Info,"Commander "..Info..": Waiting")
			else
				Status(Info,"Commander "..Info..": Stunning")
				repeat wait() 
				until not Tower.TowerReplicator.Stuns:GetAttribute("1") or Tower.TowerReplicator.Stuns:GetAttribute("1") == false
				game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"] = Tower ,["Name"] = "Call Of Arms"})
				Status(Info,"Commander "..Info..": Actived")
				task.wait(10.01)
				Status(Info,"Commander "..Info..": Waiting")
			end
		elseif Tower.TowerReplicator:GetAttribute("Upgrade") < 2 then
			local OldTime = os.clock()
			local Times,Exec = 0,0
			repeat
				task.spawn(function()
					if Tower:FindFirstChild("AnimationController") then
						Status(Info,"Commander "..Info..": Low Level")
					else
						Status(Info,"Commander "..Info..": Skipping")
					end
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"] = Tower ,["Name"] = "Call Of Arms"})
					Exec = Exec + 1
				end)
				Times = Times + 2.5
				--prints(Times)
				task.wait(.242)
			until (Tower:FindFirstChild("AnimationController") and tostring(Tower:FindFirstChild("AnimationController"):GetPlayingAnimationTracks()[4]) == "Stance") or Times >= 99
			--local TimeNeed = math.floor((os.clock() - OldTime)*100+0.5)/100
			local TimeLost = os.clock() - OldTime
			--prints(," Time:",os.clock() - OldTime)
			if Tower:FindFirstChild("AnimationController") and tostring(Tower:FindFirstChild("AnimationController"):GetPlayingAnimationTracks()[4]) == "Stance" then
				Status(Info,"Commander "..Info..": Actived")
				task.wait(10-0.24)
			end
			if (os.clock() - OldTime) < 9.999 then
				prints("Time Lower:",os.clock() - OldTime)
				task.wait(0.025)
			end
			local TimeTotal = os.clock() - OldTime
			Status(Info,"Commander "..Info..": Waiting")
			prints("Total Time:",TimeTotal,"Execute:",Exec)
			prints("Time Waiting",TimeTotal-TimeLost,"Time Lost",TimeLost)
		end
	else
		Status(Info,"Commander "..Info..": Skipping")
		task.wait(10.01)
		Status(Info,"Commander "..Info..": Waiting")
	end
	if not Status(Type) and (Info == 3 or Info == 6) then
		local Info = Info - 2
		Status(Info,"Commander "..Info..": Prepare")
	end
end
task.spawn(function()
	while task.wait() do
		if w.flags.autochain and not CancelLoop then
			Chain(troops[1],"autochain")
			Chain(troops[2],"autochain")
			Chain(troops[3],"autochain")
		elseif CancelLoop then
			CancelLoop = false
			break
		end
	end
end)
