--[[
	Fusion コンポーネントのベーステンプレート
	コピーして components/ に新規コンポーネントとして配置し、中身を実装する。
	規則: scope は呼び出し元から渡す / 破棄は scope:doCleanup() でまとめて行う。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

export type Props = {
	Parent: Instance?,
	Size: UDim2?,
	Position: UDim2?,
}

return function(scope, props: Props?)
	props = props or {}

	local frame = scope:New "Frame" {
		Name = "Base",
		Parent = props.Parent,
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
	}

	return frame
end
