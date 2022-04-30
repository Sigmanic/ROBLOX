getgenv().PreferSingle = true
getgenv().PreferDouble = true
if getgenv().PreferSingle ~= true and getgenv().PreferDouble ~= true then
	local library = loadstring(game:HttpGet("https://pastebin.com/raw/L1WAZA8D", true))()
	local w = library:CreateWindow('Auto Chain Settings')
	w:Section('Choose The Version')
	w:Button("Single Chain",function()
		for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
			if v:IsA("Frame") and v.Name == "Auto Chain Settings" then
				v.Parent.Parent:Destroy()
			end
		end
		Single()
	end)
	w:Button("Double Chain",function()
		for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
			if v:IsA("Frame") and v.Name == "Auto Chain Settings" then
				v.Parent.Parent:Destroy()
			end
		end
		Double()
	end)
end
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
	local library = loadstring(game:HttpGet("https://pastebin.com/raw/L1WAZA8D", true))()
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
		print(i,Index,Values)
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
		if v.Replicator:GetAttribute("OwnerName") then 
			if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
				SelectedTower(v,true)
			end
		end
	end
	TowerAdded = game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
		wait(.2)
		if not v:FindFirstChild("Replicator") then
			repeat wait() until v:FindFirstChild("Replicator")
		end
		if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true)
		end
	end)
	TowerRemoved = game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
		wait()
		if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
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
					wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				else
					Status[Info].Text = "Commander "..Info..": Stunning"
					repeat wait() 
					until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
					Status[Info].Text = "Commander "..Info..": Actived"
					wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				end
			elseif Tower.Replicator:GetAttribute("Upgrade") < 2 then
				Status[Info].Text = "Commander "..Info..": Low Level"
				wait(10.01)
				Status[Info].Text = "Commander "..Info..": Waiting"
			end
		else
			Status[Info].Text = "Commander "..Info..": Skipping"
			wait(10.01)
			Status[Info].Text = "Commander "..Info..": Waiting"
		end
	end
	task.spawn(function()
		while wait() do
			if w.flags.autochain then
				Chain(troops["Commander1"][2],troops["Commander1"][1])
				Chain(troops["Commander2"][2],troops["Commander2"][1])
				Chain(troops["Commander3"][2],troops["Commander3"][1])
			end
		end
	end)
end
function Double()
	local Status = {}
	local MaxDistant = 16
	local library = loadstring(game:HttpGet("https://pastebin.com/raw/L1WAZA8D", true))()
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
			if not troops["Commander1"][2] and Group == 0 then
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
	function CheckDistant(Coor1,Coor2)
		print(Coor1,Coor2)
		if Coor2 and Coor1:FindFirstChild("Torso") and Coor2:FindFirstChild("Torso") and (Coor2.Torso.Position*Vector3.new(1, 0, 1) - Coor1.Torso.Position*Vector3.new(1, 0, 1)).magnitude <= MaxDistant then --First Group
			return 1
		elseif Coor2 and Coor1:FindFirstChild("Torso") and Coor2:FindFirstChild("Torso") and (Coor2.Torso.Position*Vector3.new(1, 0, 1) - Coor1.Torso.Position*Vector3.new(1, 0, 1)).magnitude > MaxDistant then --Second Group
			return 2
		elseif not Coor2 and (troops["Commander2"][2] and (Coor1.Torso.Position*Vector3.new(1, 0, 1) - troops["Commander2"][2].Torso.Position*Vector3.new(1, 0, 1)).magnitude <= MaxDistant) or (troops["Commander3"][2] and (Coor1.Torso.Position*Vector3.new(1, 0, 1) - troops["Commander3"][2].Torso.Position*Vector3.new(1, 0, 1)).magnitude <= MaxDistant) then --Set commander 1 which will be use to check distant
			return 0
		else
			return 0
		end
	end
	for i,v in pairs(game:GetService("Workspace").Towers:GetChildren()) do
		if v.Replicator:GetAttribute("OwnerName") then 
			if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
				SelectedTower(v,true,CheckDistant(v,troops["Commander1"][2]))
			end
		end
	end
	TowerAdded = game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
		wait(.2)
		if not v:FindFirstChild("Replicator") then
			repeat wait() until v:FindFirstChild("Replicator")
		end
		if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true,CheckDistant(v,troops["Commander1"][2]))
		end
	end)
	TowerRemoved = game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
		wait()
		if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
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
					wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				else
					Status[Info].Text = "Commander "..Info..": Stunning"
					repeat wait() 
					until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false
					game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
					Status[Info].Text = "Commander "..Info..": Actived"
					wait(10.01)
					Status[Info].Text = "Commander "..Info..": Waiting"
				end
			elseif Tower.Replicator:GetAttribute("Upgrade") < 2 then
				Status[Info].Text = "Commander "..Info..": Low Level"
				wait(10.01)
				Status[Info].Text = "Commander "..Info..": Waiting"
			end
		else
			Status[Info].Text = "Commander "..Info..": Skipping"
			wait(10.01)
			Status[Info].Text = "Commander "..Info..": Waiting"
		end
	end
	task.spawn(function()
		while wait() do
			if w.flags.autochain then
				Chain(troops["Commander1"][2],troops["Commander1"][1])
				Chain(troops["Commander2"][2],troops["Commander2"][1])
				Chain(troops["Commander3"][2],troops["Commander3"][1])
			end
		end
	end)
	task.spawn(function()
		while wait() do
			if w.flags.autochain1 then
				Chain(troops["Commander4"][2],troops["Commander4"][1])
				Chain(troops["Commander5"][2],troops["Commander5"][1])
				Chain(troops["Commander6"][2],troops["Commander6"][1])
			end
		end
	end)
end
if getgenv().PreferSingle == true then
	Single()
elseif getgenv().PreferDouble == true then
	Double()
end
