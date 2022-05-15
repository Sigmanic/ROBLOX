--[[
	This Script Is Open-source, Feel Free To Change Anything.
	Credit: Sigmanic (Sigmanic#6607 --Main Account, Thomas Andrew#8787 --Second Account)
]]--
--getgenv().PreferDouble = true
local CancelLoop = false
if not getgenv().troops then
	getgenv().troops = {		--Contain number and tower instance
		Commander1 = {1},
		Commander2 = {2},
		Commander3 = {3},
		Commander4 = {4},
		Commander5 = {5},
		Commander6 = {6}
	}
end
function Single()
	local Status = {}
	local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
	local w = library:CreateWindow('Auto Chain Single')
	local Toggle = w:Toggle('Toggle Auto Chain', {flag = "autochain"})
	w:Section('Commander 1: None')
	w:Section('Commander 2: None')
	w:Section('Commander 3: None')
	w:Button("Switch To Double Chain",function()
		for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
			if v:IsA("Frame") and v.Name == "Auto Chain Single" then
				v.Parent.Parent:Destroy()
			end
		end
		CancelLoop = true
		TowerAdded:Disconnect()
		TowerRemoved:Disconnect()
		Double()
	end)
	for i,v in pairs(game.CoreGui:GetDescendants()) do
		if v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 1: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 2: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 3: None" then
			table.insert(Status,v)
		end
	end
	for i,v in next,troops do
		local Index = v[1]
		local Values = v[2]
		--print(i,Index,Values)
		if Values and (Index >= 1 and Index <= 3) then
			Status[Index].Text = "Commander "..Index..": Selected"
		end
	end
	function SelectedTower(Tower,Value)
		if Value == true then --Select Tower
			if not troops["Commander1"][2] then
				table.insert(troops["Commander1"],2,Tower)
				Status[1].Text = "Commander 1: Selected"
			elseif not troops["Commander2"][2] then
				table.insert(troops["Commander2"],2,Tower)
				Status[2].Text = "Commander 2: Selected"
			elseif not troops["Commander3"][2] then
				table.insert(troops["Commander3"],2,Tower)
				Status[3].Text = "Commander 3: Selected"
			end
		elseif Value == false then --Remove Tower
			for i,v in next,troops do
				local Index = v[1]
				local Values = v[2]
				if Values == Tower then
					table.remove(troops[i],2)
					Status[Index].Text = "Commander "..Index..": None"
				end
			end
		end
	end
	for i,v in pairs(game:GetService("Workspace").Towers:GetChildren()) do
		if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true)
		end
	end
	TowerAdded = game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
		wait(.7)
		if not v:FindFirstChild("Replicator") then
			repeat wait() until v:FindFirstChild("Replicator")
		end
		if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true)
		end
	end)
	TowerRemoved = game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
		wait()
		if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,false)
		end
	end)
	function Chain(Tower,Info)
		if not Info then
			Info = 0
		end
		if Tower then
			if Tower.Replicator:GetAttribute("Upgrade") >= 2 then
				if not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false and Tower.Replicator:GetAttribute("Upgrade") >= 2 then
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
					Status[Info].Text = "Commander "..Info..": Actived"
					task.wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				else
					Status[Info].Text = "Commander "..Info..": Stunning"
					repeat wait() 
					until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
					Status[Info].Text = "Commander "..Info..": Actived"
					task.wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				end
			elseif Tower.Replicator:GetAttribute("Upgrade") < 2 then
				Status[Info].Text = "Commander "..Info..": Low Level"
				task.wait(10.01)
				Status[Info].Text = "Commander "..Info..": Waiting"
			end
		else
			Status[Info].Text = "Commander "..Info..": Skipping"
			task.wait(10.01)
			Status[Info].Text = "Commander "..Info..": Waiting"
		end
	end
	task.spawn(function()
		while task.wait() do
			if w.flags.autochain and not CancelLoop then
				Chain(troops["Commander1"][2],troops["Commander1"][1])
				Chain(troops["Commander2"][2],troops["Commander2"][1])
				Chain(troops["Commander3"][2],troops["Commander3"][1])
			elseif CancelLoop then
				CancelLoop = false
				break
			end
		end
	end)
end
function Double()
	local Status = {}
	local MaxDistant = 15
	local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
	local w = library:CreateWindow('Auto Chain Double')
	local Toggle = w:Toggle('Auto Chain Group 1', {flag = "autochain"})
	w:Section('Commander 1: None')
	w:Section('Commander 2: None')
	w:Section('Commander 3: None')
	local Toggle = w:Toggle('Auto Chain Group 2', {flag = "autochain1"})
	w:Section('Commander 4: None')
	w:Section('Commander 5: None')
	w:Section('Commander 6: None')
	w:Button("Switch To Single Chain",function()
		for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
			if v:IsA("Frame") and v.Name == "Auto Chain Double" then
				v.Parent.Parent:Destroy()
			end
		end
		CancelLoop = true
		TowerAdded:Disconnect()
		TowerRemoved:Disconnect()
		Single()
	end)
	for i,v in pairs(game.CoreGui:GetDescendants()) do
		if v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 1: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 2: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 3: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 4: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 5: None" then
			table.insert(Status,v)
		elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 6: None" then
			table.insert(Status,v)
		end
	end
	for i,v in next,troops do
		local Index = v[1]
		local Values = v[2]
		if Values then
			Status[Index].Text = "Commander "..Index..": Selected"
		end
	end
	function SelectedTower(Tower,Value,Group)
		--print(Tower,Value,Group)
		if Value == true then --Select Tower
			if Group == 0 then
				return
			end
			if not troops["Commander1"][2] and Group == 1 then
				table.insert(troops["Commander1"],2,Tower)
				Status[1].Text = "Commander 1: Selected"
			elseif not troops["Commander2"][2] and Group == 1 then
				table.insert(troops["Commander2"],2,Tower)
				Status[2].Text = "Commander 2: Selected"
			elseif not troops["Commander3"][2] and Group == 1 then
				table.insert(troops["Commander3"],2,Tower)
				Status[3].Text = "Commander 3: Selected"
			elseif not troops["Commander4"][2] and Group == 2 then
				table.insert(troops["Commander4"],2,Tower)
				Status[4].Text = "Commander 4: Selected"
			elseif not troops["Commander5"][2] and Group == 2 then
				table.insert(troops["Commander5"],2,Tower)
				Status[5].Text = "Commander 5: Selected"
			elseif not troops["Commander6"][2] and Group == 2 then
				table.insert(troops["Commander6"],2,Tower)
				Status[6].Text = "Commander 6: Selected"
			end
		elseif Value == false then --Remove Tower
			for i,v in next,troops do
				local Index = v[1]
				local Values = v[2]
				if Values == Tower then
					table.remove(troops[i],2)
					Status[Index].Text = "Commander "..Index..": None"
				end
			end
		end
	end
	function CheckDistant(Tower1) --Tower1: Tower Will Be Checked
		local Tower2 = troops["Commander1"][2] or troops["Commander2"][2] or troops["Commander3"][2]
		if Tower2 and Tower2:FindFirstChild("Torso") and Tower2:FindFirstChild("Torso") then
			if troops["Commander1"][2] and troops["Commander2"][2] and troops["Commander3"][2] then
				if Tower1 == troops["Commander1"][2] or Tower1 == troops["Commander2"][2] and Tower1 == troops["Commander3"][2] then
					return 0
				end
				return 2
			elseif (Tower1.Torso.Position*Vector3.new(1, 0, 1) - Tower2.Torso.Position*Vector3.new(1, 0, 1)).magnitude <= MaxDistant then --First Group
				return 1
			elseif (Tower1.Torso.Position*Vector3.new(1, 0, 1) - Tower2.Torso.Position*Vector3.new(1, 0, 1)).magnitude > MaxDistant then --Second Group
				return 2
			end
		elseif not Tower2 then
			Tower2 = troops["Commander4"][2] or troops["Commander5"][2] or troops["Commander6"][2]
			if Tower2 and Tower2:FindFirstChild("Torso") and Tower2:FindFirstChild("Torso") then
				if troops["Commander4"][2] and troops["Commander5"][2] and troops["Commander6"][2] then
					if Tower1 == troops["Commander4"][2] or Tower1 == troops["Commander5"][2] and Tower1 == troops["Commander6"][2] then
						return 0
					end
					return 1
				elseif (Tower1.Torso.Position*Vector3.new(1, 0, 1) - Tower2.Torso.Position*Vector3.new(1, 0, 1)).magnitude <= MaxDistant then --First Group
					return 2
				elseif (Tower1.Torso.Position*Vector3.new(1, 0, 1) - Tower2.Torso.Position*Vector3.new(1, 0, 1)).magnitude > MaxDistant then --Second Group
					return 1
				end
			elseif not Tower2 then --When there are no more towers to check :v
				return 1
			end
		end
	end
	for i,v in pairs(game:GetService("Workspace").Towers:GetChildren()) do
		if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true,CheckDistant(v))
		end
	end
	TowerAdded = game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
		wait(.7)
		if not v:FindFirstChild("Replicator") then
			repeat wait() until v:FindFirstChild("Replicator")
		end
		if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true,CheckDistant(v))
		end
	end)
	TowerRemoved = game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
		wait()
		if v:FindFirstChild("Owner").Value and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,false)
		end
	end)
	function Chain(Tower,Info)
		if not Info then
			Info = 0
		end
		if Tower then
			if Tower.Replicator:GetAttribute("Upgrade") >= 2 then
				if not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false and Tower.Replicator:GetAttribute("Upgrade") >= 2 then
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
					Status[Info].Text = "Commander "..Info..": Actived"
					task.wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				else
					Status[Info].Text = "Commander "..Info..": Stunning"
					repeat task.wait() 
					until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
					Status[Info].Text = "Commander "..Info..": Actived"
					task.wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				end
			elseif Tower.Replicator:GetAttribute("Upgrade") < 2 then
				Status[Info].Text = "Commander "..Info..": Low Level"
				task.wait(10.01)
				Status[Info].Text = "Commander "..Info..": Waiting"
			end
		else
			Status[Info].Text = "Commander "..Info..": Skipping"
			task.wait(10.01)
			Status[Info].Text = "Commander "..Info..": Waiting"
		end
	end
	task.spawn(function()
		while task.wait() do
			if w.flags.autochain and not CancelLoop then
				Chain(troops["Commander1"][2],troops["Commander1"][1])
				Chain(troops["Commander2"][2],troops["Commander2"][1])
				Chain(troops["Commander3"][2],troops["Commander3"][1])
			elseif CancelLoop then
				CancelLoop = false
				break
			end
		end
	end)
	task.spawn(function()
		while task.wait() do
			if w.flags.autochain1 and not CancelLoop then
				Chain(troops["Commander4"][2],troops["Commander4"][1])
				Chain(troops["Commander5"][2],troops["Commander5"][1])
				Chain(troops["Commander6"][2],troops["Commander6"][1])
			elseif CancelLoop then
				CancelLoop = false
				break
			end
		end
	end)
end
if getgenv().PreferDouble ~= true then
	Single()
elseif getgenv().PreferDouble == true then
	Double()
end
