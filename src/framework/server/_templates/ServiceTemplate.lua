--[[
	Service テンプレート
	コピーして services/ に配置し、Name とファイル名を用途に合わせて変更してください。
	Knit 規則: 全モジュールが table を返す / Promise・Signal・Trove を推奨。
	クライアント公開メソッドは ServiceName.Client に定義する。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ServiceTemplate = Knit.CreateService {
	Name = "ServiceTemplate",
	Client = {},
}

-- クライアントから呼べるメソッド例
-- function ServiceTemplate.Client:DoSomething(player)
--     return self.Server:DoSomethingInternal(player)
-- end

function ServiceTemplate:KnitInit()
	-- 他モジュールの require や初期状態の設定
end

function ServiceTemplate:KnitStart()
	-- 他サービス・システムとの連携や定期処理の開始
end

return ServiceTemplate
