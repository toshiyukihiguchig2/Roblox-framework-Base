--[[
	Server 起動ファイル（単一エントリ）
	Framework + 選択中ゲームの Service を読み込み、Knit を起動する。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Logger = require(ReplicatedStorage.FrameworkShared.modules.Logger)

-- Framework のサービス
Knit.AddServices(script.Parent.services)

-- ゲームのサービス（Game が存在する場合）
local game = script.Parent.Parent:FindFirstChild("Game")
if game then
	local services = game:FindFirstChild("services")
	if services then
		Knit.AddServices(services)
	end
end

Knit.Start():catch(Logger.error)
