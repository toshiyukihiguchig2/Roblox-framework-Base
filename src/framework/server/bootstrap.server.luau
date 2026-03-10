--[[
	Server 起動ファイル（単一エントリ）
	Framework + 選択中ゲームの Service を読み込み、Knit を起動する。
	※ init.server.luau だと Rojo が親を Script に変換するため、bootstrap にしている。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Logger = require(ReplicatedStorage.FrameworkShared.modules.Logger)

-- Framework のサービス（ServerScriptService/FrameworkServer）
Knit.AddServices(script.Parent.services)

-- ゲームのサービス（ServerScriptService/<game>/Server/services）
local serverScriptService = script.Parent.Parent
for _, child in serverScriptService:GetChildren() do
	if child.Name ~= "FrameworkServer" and child.Name ~= "ServerPackages" then
		local serverFolder = child:FindFirstChild("Server")
		if serverFolder then
			local services = serverFolder:FindFirstChild("services")
			if services then
				Knit.AddServices(services)
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
							Logger.info("Loaded game (server):", info.displayName or info.name)
						end
					end
				end
				break
			end
		end
	end
end

Knit.Start():catch(Logger.error)
