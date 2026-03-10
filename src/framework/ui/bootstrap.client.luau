--[[
	UI ブートストラップ（MainGui 内の単一エントリ）
	Fusion を初期化し、App をマウント。破棄時に scope をクリーンアップする。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Trove = require(ReplicatedStorage.Packages.Trove)

local App = require(script.Parent.App)

local scope = Fusion.scoped(Fusion)
local trove = Trove.new()

-- App を ScreenGui にマウント
App(scope, script.Parent)

-- スクリプトが親から外れたらクリーンアップ（プレイヤー離脱など）
trove:Connect(script.AncestryChanged, function()
	if not script:IsDescendantOf(game) then
		Fusion.doCleanup(scope)
		trove:Destroy()
	end
end)
