--[[
	Client 起動ファイル（単一エントリ）
	Framework + 選択中ゲームの Controller を読み込み、Knit を起動する。
	※ init.client.luau だと Rojo が親を LocalScript に変換するため、bootstrap にしている。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Logger = require(ReplicatedStorage.FrameworkShared.modules.Logger)

-- Framework のコントローラー（StarterPlayerScripts/Framework）
Knit.AddControllers(script.Parent.controllers)

-- ゲームのコントローラー（StarterPlayerScripts/<game>/Client/controllers）
local playerScripts = script.Parent.Parent
for _, child in playerScripts:GetChildren() do
	if child ~= script.Parent then
		local clientFolder = child:FindFirstChild("Client")
		if clientFolder then
			local controllers = clientFolder:FindFirstChild("controllers")
			if controllers then
				Knit.AddControllers(controllers)
			end
		end
	end
end

-- 読み込んだゲームを GameInfo から取得（ReplicatedStorage/<game>/Shared）
do
	for _, child in ReplicatedStorage:GetChildren() do
		if child.Name ~= "FrameworkShared" and child.Name ~= "Packages" then
			local sharedFolder = child:FindFirstChild("Shared")
			if sharedFolder then
				local config = sharedFolder:FindFirstChild("config")
				if config then
					local GameInfo = config:FindFirstChild("GameInfo")
					if GameInfo then
						local ok, info = pcall(require, GameInfo)
						if ok and info and info.name then
							ReplicatedStorage:SetAttribute("GameName", info.name)
							Logger.info("Loaded game (client):", info.displayName or info.name)
						end
					end
				end
				break
			end
		end
	end
end

Knit.Start():catch(Logger.error)
