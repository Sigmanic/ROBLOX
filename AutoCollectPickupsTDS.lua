if game.PlaceId ~= 5591597781 then return end
getgenv().DefaultCam = 1
repeat wait() until game:IsLoaded()
local ItemName = "Pumpkin"
local LocalPlayer = game:GetService("Players").LocalPlayer
local Pickups = Workspace.Pickups
while true do
    for Index, Object in next, Pickups:GetChildren() do
        if Object:IsA("MeshPart") and string.find(Object.Name:lower(),ItemName:lower()) and Object.CFrame.Y < 200 then
            if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = Object.CFrame
        end
    end
    task.wait()
end

--[[
local ItemTable = {}
for Index, Object in next, Pickups:GetChildren() do
    if Object:IsA("MeshPart") and string.find(Object.Name:lower(),ItemName:lower()) and not table.find(ItemTable,Object) then
        table.insert(ItemTable,Object)
    end
end
Pickups.ChildAdded:Connect(function(Object)
    wait(.5)
    if Object:IsA("MeshPart") and string.find(Object.Name:lower(),ItemName:lower()) and not table.find(ItemTable,Object) then
        table.insert(ItemTable,Object)
    end
end)
task.spawn(function()
    while true do
        task.wait()
        for i = 1,#ItemTable do
            if ItemTable[i] and ItemTable[i].CFrame.Y < 200 then
                if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                end
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
                LocalPlayer.Character.HumanoidRootPart.CFrame = ItemTable[i].CFrame
            elseif not ItemTable[i] then
                table.remove(ItemTable,i)
            end
        end
    end
end)]]
