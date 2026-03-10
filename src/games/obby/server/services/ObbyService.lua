--[[
	Obby: クライアント向け Obby サービス
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ObbyService = Knit.CreateService {
	Name = "ObbyService",
	Client = {},
}

function ObbyService:KnitStart()
	-- 必要に応じて StageSystem / CheckpointSystem を require
end

return ObbyService
