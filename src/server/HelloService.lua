local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- サービスの定義
local HelloService = Knit.CreateService {
    Name = "HelloService",
    Client = {}, -- クライアントから呼び出せる関数を入れる場所
}

-- クライアント（プレイヤー）が呼び出せる関数
function HelloService.Client:GetGreeting(player)
    return "Hello World from Knit Server!"
end

function HelloService:KnitInit()
    print("HelloService が初期化されました")
end

function HelloService:KnitStart()
    print("HelloService が起動しました")
end

return HelloService