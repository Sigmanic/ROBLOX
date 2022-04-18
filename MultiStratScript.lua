local library = loadstring(game:HttpGet("https://pastebin.com/raw/L1WAZA8D", true))()
local w = library:CreateWindow('Elavator')
w:Section('Status:')
w:Section('Status')
for i,v in pairs(game.CoreGui:GetDescendants()) do
    if v:IsA("TextLabel") and v.Name == "section_lbl" and v.Text == "Status" then
        getgenv().status = v
    end
end
getgenv().Maps = {["Wrecked Battlefield"] = {"Ace Pilot", "Military Base", "nil", "nil", "nil"},
["Autumn Falling"] = {"Ace Pilot", "Military Base", "nil", "nil", "nil"}}
getgenv().Mode = "Hardcore"
spawn(function()
	function prints(mess)
		appendfile("TDS_AutoStrat/LastPrintLog.txt",tostring(mess).."\n")
		print(tostring(mess))
	end
    local RS = game:WaitForChild('ReplicatedStorage')
    local RSRF = RS:WaitForChild("RemoteFunction")
    local RSRE = RS:WaitForChild("RemoteEvent")
    function EquipTroop(troop)
        if game.PlaceId ~= 5591597781 then
        local args = {
            [1] = "Inventory",
            [2] = "Execute",
            [3] = "Troops",
            [4] = "Add",
            [5] = {
                ["Name"] = tostring(troop)
            }
        }
        game.ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
        end
    end
    function UnEquip()
        for TowerName, Tower in next, game.ReplicatedStorage.RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
            if (Tower.Equipped) then
                local args = {
                    [1] = "Inventory",
                    [2] = "Execute",
                    [3] = "Troops",
                    [4] = "Remove",
                    [5] = {
                        ["Name"] = TowerName
                    }
                }
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
            end;
        end;
    end
    if game.PlaceId == 5591597781 then
        getgenv().map = game:GetService("ReplicatedStorage").State.Map.Value
    else
        spawn(function()
			getgenv().timer = 0
			while wait(1) do
				getgenv().timer = getgenv().timer + 1
			end
		end)
        getgenv().repeating = true
		spawn(function()
			while wait(1) do
				if getgenv().repeating then
					getgenv().repeating = false
					local jc = true --Wait Mode
					for _, Elevators in pairs(game:GetService('Workspace').Elevators:GetChildren()) do
						local Name = Elevators.State.Map.Title
						local plrs = Elevators.State.Players
                        local Modes = require(Elevators.Settings).Type
						if getgenv().Maps[Name.Value] ~= nil and Modes == getgenv().Mode then
							if (plrs.Value <= 0) then
								jc = false -- Change to Joined Mode
								prints("Join attempt...")
								getgenv().status.Text = "Joining..."
								RSRF:InvokeServer("Elevators","Enter",Elevators)
								UnEquip()
								for i,v in next, getgenv().Maps[Name.Value] do
                                    EquipTroop(v)
								end
								prints("Joined elavator...")
								getgenv().status.Text = "Joined"
								while wait() do
									getgenv().status.Text = "Joined ("..Elevators.State.Timer.Value.."s)"
									if Elevators.State.Timer.Value == 0 then
										local s = true --Teleporting...
										for c = 1,100 do --This Progress Will Leave Elevator If A Player is Joining In 0 Second
                                            if (plrs.Value > 1) then
                                                prints("Someone joined, leaving elevator...")
                                                getgenv().status.Text = "Someone joined..."
                                                RSRF:InvokeServer("Elevators","Leave")
                                                getgenv().repeating = true -- Reset Progress
                                                s = false
                                                break
                                            end
                                            wait(0.01)
										end
										if Elevators.State.Timer.Value == 0 and s then --Check Elevator Information
											getgenv().status.Text = "Teleporting..."
											wait(60)
											getgenv().status.Text = "Teleport failed!"
											RSRF:InvokeServer("Elevators","Leave")
										else
											getgenv().status.Text = "Teleport failed! (Timer)"
											RSRF:InvokeServer("Elevators","Leave")
											getgenv().repeating = true -- Reset Progress
										end
									end
									if getgenv().Maps[Name.Value] ~= nil then --This Progress Will Leave Elevator If A Player is Joining In
										if antimulti then
											if (plrs.Value > 1) then
												RSRF:InvokeServer("Elevators","Leave")
												prints("Someone joined, leaving elevator...")
												getgenv().status.Text = "Someone joined..."
												getgenv().repeating = true -- Reset Progress
												break
											elseif (plrs.Value == 0) then --Idk What is this maybe check player is in elevator?
												wait(1)
												if (plrs.Value == 0) then
													wait(1)
													if (plrs.Value == 0) then
														wait(1)
														if (plrs.Value == 0) then
															wait(1)
															if (plrs.Value == 0) then
                                                                prints("Error")
                                                                getgenv().status.Text = "Error occured, check dev con"
                                                                prints("Error occured, please open ticket on Money Maker Development discord server!")
                                                                RSRF:InvokeServer("Elevators","Leave")
                                                                getgenv().repeating = true -- Reset Progress
                                                                break
															end
														end
													end
												end
											end
										end
									else --Leave When Map Change Pretty Rare To Occur
										RSRF:InvokeServer("Elevators","Leave")
										prints("Map changed while joining, leaving...")
										getgenv().status.Text = "Map changed..."
										getgenv().repeating = true
										break
									end
								end
							end
						end
					end
					if jc == true then
						getgenv().repeating = true
						prints("Waiting for map...")
						getgenv().status.Text = "Waiting for map..."
						if getgenv().timer >= 15 then -- Change Map After 15 sec
                            getgenv().status.Text = "Force changing maps..."
                            getgenv().timer = 0
                            for i, v in pairs(game:GetService("Workspace").Elevators:GetChildren()) do
                                local plrs = v.State.Players
                                local Modes = require(v.Settings).Type
                                if plrs.Value <= 0 and Modes == getgenv().Mode then
                                    RSRF:InvokeServer("Elevators","Enter",v)
                                    wait(1)
                                    RSRF:InvokeServer("Elevators","Leave")
                                end
                            end
                            wait(0.6)
                            RSRF:InvokeServer("Elevators","Leave")
                            wait(1)
					    end
				    end
			    end
		    end
	    end)
    end
end)