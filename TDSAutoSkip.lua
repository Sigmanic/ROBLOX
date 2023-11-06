local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateReplica
getgenv().GetStateReplica = function()
    if StateReplica then
        return StateReplica
    end
    repeat
        for i,v in next, ReplicatedStorage.StateReplicators:GetChildren() do
            if v:GetAttribute("MaxVotes") then
                StateReplica = v
                return v
            end
        end
        task.wait()
    until StateReplica
end
GetStateReplica():GetAttributeChangedSignal("Enabled"):Connect(function()   
    ReplicatedStorage.RemoteFunction:InvokeServer("Voting", "Skip")
end)
