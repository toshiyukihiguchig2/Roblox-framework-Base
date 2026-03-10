--[[
	Fusion UI のルートコンポーネント（ベース）
	MainGui 直下にルート Frame を組み、screens / components をここに差し込む。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

return function(scope, parent: Instance)
	-- ルート: 全画面のコンテナ（必要に応じて Children で画面を追加）
	scope:New "Frame" {
		Name = "Root",
		Parent = parent,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		-- [Fusion.Children] = { ... screens ... }
	}
end
