
local comm1,comm2,comm3
local troops = {1,2,3}
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
			v.Name = troops[1]
			Status(tonumber(v.Name)).Text = "Commander "..v.Name..": Selected"
			table.remove(troops,1)
		end
	end
end
game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
	wait(.5)
	if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" and troops[1] then
		v.Name = troops[1]
		Status(tonumber(v.Name)).Text = "Commander "..v.Name..": Selected"
		table.remove(troops,1)
	end
end)
game:GetService("Workspace").Towers.ChildRemoved:Connect(function(v)
	wait()
	if v.Name:match("%d+") then
		table.insert(troops, tonumber(v.Name))
		Status(tonumber(v.Name)).Text = "Commander "..v.Name..": None"
	end
end)
function Act(Comm)
	if game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)) then
		if not game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)).Replicator.Stuns:GetAttribute("1") or game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)).Replicator.Stuns:GetAttribute("1") == false then
			game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]=game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)),["Name"] = "Call Of Arms"})
			Status(Comm).Text = "Commander "..Comm..": Actived"
			wait(10.01)
			Status(Comm).Text = "Commander "..Comm..": Waiting"
		else
			Status(Comm).Text = "Commander "..Comm..": Stunning"
			repeat wait() until not game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)).Replicator.Stuns:GetAttribute("1") or game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)).Replicator.Stuns:GetAttribute("1") == false
			game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"]=game:GetService("Workspace").Towers:FindFirstChild(tostring(Comm)),["Name"] = "Call Of Arms"})
			Status(Comm).Text = "Commander "..Comm..": Actived"
			wait(10.01)
			Status(Comm).Text = "Commander "..Comm..": Waiting"
		end	
	else
		Status(Comm).Text = "Commander "..Comm..": Skipping"
		wait(10.01)
		Status(Comm).Text = "Commander "..Comm..": Waiting"
	end
end
while wait() do
	if w.flags.autochain then
		Act(1)
		Act(2)
		Act(3)
	end
end
--[[for c=1,3 do
	if game:GetService("Workspace").Towers:FindFirstChild(tostring(c)) then
		say("WARNING","Commander"..tostring(c).." detected")
	else
		say("WARNING","Commander "..tostring(c).." not placed, waiting to be placed...")
		conn = game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
			if v.Replicator:GetAttribute("OwnerName") then 
				if v.Replicator:GetAttribute("OwnerName") == game.Players.LocalPlayer.DisplayName and v.Replicator:GetAttribute("Type") == "Commander" then
					cc = cc + 1
					v.Name = cc
				end
			end
		end)
		repeat wait() until game:GetService("Workspace").Towers:FindFirstChild(tostring(c))
		conn:Disconnect()
	end
end]]