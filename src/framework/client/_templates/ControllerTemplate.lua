--[[
	Controller テンプレート
	コピーして controllers/ に配置し、Name とファイル名を用途に合わせて変更してください。
	Knit 規則: 全モジュールが table を返す / Promise・Signal・Trove を推奨。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ControllerTemplate = Knit.CreateController { Name = "ControllerTemplate" }

function ControllerTemplate:KnitInit()
	-- 他モジュールの require や初期状態の設定
end

function ControllerTemplate:KnitStart()
	-- 他サービスへの接続や UI/入力の初期化
	-- local SomeService = Knit.GetService("SomeService")
end

return ControllerTemplate
