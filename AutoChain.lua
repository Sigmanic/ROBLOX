local comm1,comm2,comm3
local troops = {
	Commander1 = {1},
	Commander2 = {2},
	Commander3 = {3},
}
local library = loadstring(game:HttpGet("https://pastebin.com/raw/RZ49zwxL", true))()
local w = library:CreateWindow('Auto Chain')
local Toggle = w:Toggle('Toggle Auto Chain', {flag = "autochain"})
w:Section('Commander 1: None')
w:Section('Commander 2: None')
w:Section('Commander 3: None')
for i,v in pairs(game.CoreGui:GetDescendants()) do
	if v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 1: None" then
		comm1 = v
	elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 2: None" then
		comm2 = v
	elseif v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Commander 3: None" then
		comm3 = v
	end
end
function SelectedTower(Tower,Value)
	if Value == true then
		if not troops["Commander1"][2] then
			table.insert(troops["Commander1"],2,Tower)
			Status(1).Text = "Commander 1: Selected"
		elseif not troops["Commander2"][2] then
			table.insert(troops["Commander2"],2,Tower)
			Status(2).Text = "Commander 2: Selected"
		elseif not troops["Commander3"][2] then
			table.insert(troops["Commander3"],2,Tower)
			Status(3).Text = "Commander 3: Selected"
		end
	elseif Value == false then
		if troops["Commander1"][2] == Tower then
			table.remove(troops["Commander1"],2)
			Status(1).Text = "Commander 1: None"
		elseif troops["Commander2"][2] == Tower then
			table.remove(troops["Commander2"],2)
			Status(2).Text = "Commander 2: None"
		elseif troops["Commander3"][2] == Tower then
			table.remove(troops["Commander3"],2)
			Status(3).Text = "Commander 3: None"
		end
	end
end
function Status(Tower)
	if Tower == 1 then
		return comm1
	elseif Tower == 2 then
		return comm2
	elseif Tower == 3 then
		return comm3
	end
end
for i,v in pairs(game:GetService("Workspace").Towers:GetChildren()) do
	if v.Replicator:GetAttribute("OwnerName") then 
		if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
			SelectedTower(v,true)
		end
	end
end
game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
	wait(1.2)
	if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
		SelectedTower(v,true)
	end
end)
game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
	wait()
	if v.Name:match("%d+") then
		SelectedTower(v,false)
	end
end)
function Chain(Tower,Info)
	if not Info then
		Info = 0
	end
	if Tower then
		if not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false then
			game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
			Status(Info).Text = "Commander "..Info..": Actived"
			wait(10.01)
			Status(Info).Text = "Commander "..Info..": Waiting"
		else
			Status(Info).Text = "Commander "..Info..": Stunning"
			repeat wait() 
			until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false
			game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]= Tower ,["Name"] = "Call Of Arms"})
			Status(Info).Text = "Commander "..Info..": Actived"
			wait(10.01)
			Status(Info).Text = "Commander "..Info..": Waiting"
		end	
	else
		Status(Info).Text = "Commander "..Info..": Skipping"
		wait(10.01)
		Status(Info).Text = "Commander "..Info..": Waiting"
	end
end
while wait() do
	if w.flags.autochain then
		Chain(troops["Commander1"][2],troops["Commander1"][1])
		Chain(troops["Commander2"][2],troops["Commander2"][1])
		Chain(troops["Commander3"][2],troops["Commander3"][1])
	end
end
