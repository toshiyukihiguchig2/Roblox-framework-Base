local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- コントローラーの定義
local HelloController = Knit.CreateController { Name = "HelloController" }

function HelloController:KnitStart()
    -- サーバーの HelloService を取得
    local HelloService = Knit.GetService("HelloService")
    
    -- サーバーから挨拶を受け取る（非同期処理なので Promise が返る）
    HelloService:GetGreeting():andThen(function(greeting)
        print("サーバーからのメッセージ:", greeting)
    end)
end

return HelloController