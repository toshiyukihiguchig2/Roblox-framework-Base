--[[
	Client 起動ファイル（単一エントリ）
	Framework + 選択中ゲームの Controller を読み込み、Knit を起動する。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Logger = require(ReplicatedStorage.FrameworkShared.modules.Logger)

-- Framework のコントローラー
Knit.AddControllers(script.Parent.controllers)

-- ゲームのコントローラー（Game が存在する場合）
local game = script.Parent.Parent:FindFirstChild("Game")
if game then
	local controllers = game:FindFirstChild("controllers")
	if controllers then
		Knit.AddControllers(controllers)
	end
end

Knit.Start():catch(Logger.error)
