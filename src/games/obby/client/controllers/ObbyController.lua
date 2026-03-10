--[[
	Obby: クライアント側 Obby コントローラー
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ObbyController = Knit.CreateController { Name = "ObbyController" }

function ObbyController:KnitStart()
	-- local ObbyService = Knit.GetService("ObbyService")
end

return ObbyController
