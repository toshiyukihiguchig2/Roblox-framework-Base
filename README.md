# Roblox-framework-Base

Roblox ゲームを**ジャンルごとに量産**するためのフレームワークです。  
Knit（クライアント・サーバー）、Fusion（UI）、Rojo / Wally で構成されています。

## 3 層の役割

| 層 | 役割 | 場所 |
|----|------|------|
| **core** | 基盤ライブラリ（Knit, Fusion, Wally 等） | `Packages` / `ServerPackages` |
| **framework** | 共通エンジン（起動・テンプレ・UI 基盤） | `src/framework` |
| **games** | 個別ゲーム（ジャンル別） | `src/games/<ジャンル>` |

---

## フォルダ構成

```
src/
├── framework/                 ← 共通エンジン（全ゲームで共有）
│   ├── client/               ← 起動ファイル・Controller テンプレ・utils
│   ├── server/               ← 起動ファイル・Service テンプレ・systems・managers
│   ├── shared/               ← 共通モジュール・utils・types
│   └── ui/                   ← Fusion ブートストラップ・App・components・screens
│
└── games/                     ← ジャンル別ゲーム
    ├── obby/
    │   ├── server/
    │   │   ├── systems/       ← StageSystem, CheckpointSystem 等
    │   │   └── services/      ← ObbyService（Knit）
    │   ├── client/
    │   │   └── controllers/  ← ObbyController（Knit）
    │   └── shared/
    │       └── config/        ← StageConfig 等
    ├── tycoon/
    ├── simulator/
    └── tower-defense/
```

- **framework** の `init` が、Framework と**選択中ゲーム**の Service / Controller をまとめて読み込みます。
- **どのゲームを選択するか**は、Rojo で使うプロジェクトファイルで決まります（後述）。

---

## 必要な環境

- [Rojo](https://rojo.space/) … ファイル同期
- [Wally](https://github.com/UpliftGames/wally) … パッケージ管理
- Roblox Studio（Rojo プラグイン推奨）

---

## 初回セットアップ

```bash
wally install
rojo serve
```

`default.project.json` を使うと、**obby** が選択された状態で同期されます。

---

## ゲームの切り替え（Rojo）

同期するゲームを切り替えるには、**別のプロジェクトファイル**を指定します。

| やりたいこと | コマンド例 |
|--------------|------------|
| obby を開発 | `rojo serve`（または `rojo serve default.project.json`） |
| tycoon を開発 | `rojo serve tycoon.project.json` |
| simulator を開発 | `rojo serve simulator.project.json` |
| tower-defense を開発 | `rojo serve tower-defense.project.json` |

Studio の Rojo プラグインで「Sync」するときも、あらかじめ同じプロジェクトファイルを指定して `rojo serve` を起動しておきます。

---

## 新しいゲームを作るときのマニュアル

### 1. 起動ファイルは触らない

次の 2 本は **framework** にあり、そのまま使います。

| ファイル | 役割 |
|----------|------|
| `src/framework/client/init.client.luau` | Framework + 選択中ゲームの Controller を読み込み、Knit 起動 |
| `src/framework/server/init.server.luau` | Framework + 選択中ゲームの Service を読み込み、Knit 起動 |

### 2. 新規ゲーム（ジャンル）を追加する

1. **フォルダを作る**: `src/games/<ジャンル名>/` の下に `server/`、`client/`、`shared/` を用意。
2. **Knit 用**:
   - サーバー: `server/services/<名前>Service.lua`（テンプレは `framework/server/_templates/ServiceTemplate.lua` をコピー）
   - クライアント: `client/controllers/<名前>Controller.lua`（テンプレは `framework/client/_templates/ControllerTemplate.lua` をコピー）
3. **システム・設定**:
   - サーバー用の普通モジュール: `server/systems/<名前>System.lua`
   - 共通設定: `shared/config/<名前>Config.lua`
4. **プロジェクトファイルを追加**: `default.project.json` をコピーし、`Game` と `GameShared` の `$path` を `src/games/<ジャンル>/server`、`.../client`、`.../shared` に合わせた `<ジャンル>.project.json` を作成する。

### 3. 既存ゲームに Service / Controller を追加する

- **Service**: `src/framework/server/_templates/ServiceTemplate.lua` をコピー → `src/games/<ジャンル>/server/services/<名前>Service.lua` に置き、名前を変更。
- **Controller**: `src/framework/client/_templates/ControllerTemplate.lua` をコピー → `src/games/<ジャンル>/client/controllers/<名前>Controller.lua` に置き、名前を変更。

init の修正は不要です（Framework の init が Game の services / controllers を自動で読み込みます）。

### 4. 共通コードの参照

| 種類 | 参照例 |
|------|--------|
| Framework 共通 | `ReplicatedStorage.FrameworkShared.modules.X` / `.utils` / `.types` |
| ゲーム固有 | `ReplicatedStorage.GameShared.config.X` 等 |

### 5. UI（Fusion）

UI は **framework** 側のみです（`src/framework/ui`）。  
ゲームごとの画面は、framework の `App.luau` の Children に追加するか、ゲームの Controller から framework の UI モジュールを require して利用します。

- 新規画面: `src/framework/ui/screens/` に追加し、`App.luau` から参照。
- 新規コンポーネント: `src/framework/ui/components/Base.luau` をコピーして拡張。

### 6. コーディングで守ること

- モジュールは必ず table を返す
- グローバル変数は使わない
- 非同期は Promise、イベントは Signal、破棄は Trove
- 依存はできるだけ引数で渡す（依存性注入）

---

## マッピング（Rojo → Roblox）

| フォルダ / パス | Roblox 上の場所 |
|-----------------|------------------|
| `src/framework/shared` | ReplicatedStorage/FrameworkShared |
| `src/games/<game>/shared` | ReplicatedStorage/GameShared |
| `src/framework/server` | ServerScriptService/Framework |
| `src/games/<game>/server` | ServerScriptService/Game |
| `src/framework/client` | StarterPlayerScripts/Framework |
| `src/games/<game>/client` | StarterPlayerScripts/Game |
| `src/framework/ui` | StarterGui/MainGui |
| `Packages` | ReplicatedStorage/Packages |
| `ServerPackages` | ServerScriptService/ServerPackages |

---

## クイックリファレンス

| やりたいこと | やること |
|--------------|----------|
| 別ジャンルのゲームを同期する | 対応する `*.project.json` を指定して `rojo serve` |
| ゲームに Service を追加 | `framework/server/_templates/ServiceTemplate.lua` をコピー → `games/<ジャンル>/server/services/` で名前変更 |
| ゲームに Controller を追加 | `framework/client/_templates/ControllerTemplate.lua` をコピー → `games/<ジャンル>/client/controllers/` で名前変更 |
| ゲームにシステム（非 Knit）を追加 | `games/<ジャンル>/server/systems/<名前>System.lua` に配置 |
| ゲームの設定を共有 | `games/<ジャンル>/shared/config/<名前>Config.lua` に配置 |

このベースを fork またはコピーし、ジャンルごとにゲームを追加して利用してください。

---

## ビルド・リリース

Studio でプレイするだけなら `rojo serve` で十分です。**.rbxl** を出力して別環境で開いたり、Roblox にアップロードする場合は次のようにします。

### .rbxl の出力

```bash
# デフォルト（obby）用の place をビルド
rojo build -o build/obby.rbxl

# 別ゲーム用
rojo build tycoon.project.json -o build/tycoon.rbxl
rojo build simulator.project.json -o build/simulator.rbxl
rojo build tower-defense.project.json -o build/tower-defense.rbxl
```

- 初回は `mkdir build` などで `build/` を用意してください。
- 出力された `.rbxl` は Studio で「ファイル → 開く」から開けます。

### アップロード

- **手動**: Studio で該当 place を開き、「ファイル → Publish to Roblox」でアップロード。
- **CLI**: [rojo upload](https://github.com/rojo-rbx/rojo#uploading) や [Roblox CLI](https://create.roblox.com/docs/studio/roblox-cli) を使う場合は、各ツールの手順に従ってください。

ゲームごとに別 place にする場合は、**ゲームごとに別の `.project.json` でビルド**し、それぞれの place にアップロードする形になります。

---

## セキュリティの前提

クライアントから呼べる Knit の Service メソッドは、**クライアントの送信内容をそのまま信頼しない**前提で書きます。

### サーバー側で必ずやること

| 項目 | 内容 |
|------|------|
| **呼び出し元の検証** | メソッドの第 1 引数は `player`。その `player` が正当な Player インスタンスか、現在のセッションにいるか確認する。 |
| **パラメータの検証** | クライアントから渡された数値・文字列・テーブルは「型・範囲・長さ」をサーバーでチェックする。想定外の値は無視するかエラーで返す。 |
| **権限の確認** | 「このプレイヤーがその操作をしていいか」（所持金・所持アイテム・クールダウン等）をサーバー側のデータだけを見て判定する。 |

### 悪い例・よい例（イメージ）

```lua
-- 悪い例: クライアントの値をそのまま使う
function MoneyService.Client:AddMoney(player, amount)
    self.Server:AddMoneyInternal(player, amount)  -- amount を未検証で使用
end

-- よい例: 型・範囲をチェックしてから処理
function MoneyService.Client:AddMoney(player, amount)
    if type(amount) ~= "number" or amount <= 0 or amount > 1000 then
        return
    end
    self.Server:AddMoneyInternal(player, amount)
end
```

- ルール（`.cursor/rules`）にも「Client-callable Service: 必ずサーバーで検証」とあります。新規 Service を書くときはこの前提を守ってください。

---

## フレームワークの完成度と今後の拡張

現状の構成で「量産用の土台」としては完成しています。以下は**あるとより安心・運用しやすくなる**追加案です。

### すぐ入れておくとよいもの（いずれも対応済み）

| 項目 | 内容 |
|------|------|
| **エラー・ログ** | `framework/shared/modules/Logger.lua` でログレベル（DEBUG / INFO / WARN / ERROR）と error 時のスタック出力を用意。init では `Knit.Start():catch(Logger.error)` を使用。本番では `Logger.setLevel(Logger.LEVEL.INFO)` などでレベルを変更可能。 |
| **セキュリティの前提** | 上記「[セキュリティの前提](#セキュリティの前提)」に、呼び出し元・パラメータ・権限の検証と悪い例・よい例を記載。ルールにも同一方針を記載済み。 |
| **ビルド手順** | 上記「[ビルド・リリース](#ビルドリリース)」に、`rojo build` でゲーム別 .rbxl を出力する手順とアップロードのメモを記載。 |

### ゲームが増えてから検討するとよいもの

| 項目 | 内容 |
|------|------|
| **プレイヤーデータ** | ProfileStore を使う場合、「どの Service が DataStore を扱うか」の規約（例: framework に `PlayerDataService` を 1 本だけ用意し、ゲームはそこを経由する）を決めておくと、データ設計がぶれにくくなります。 |
| **テスト** | ルールに TestEZ とあるので、`test/` や `src/framework/test/` を用意し、サンプル 1 本と「テストの実行方法」を README に書いておくと、あとからテストを増やしやすくなります。 |
| **環境切り替え** | 開発用と本番用で DataStore やログレベルを変えたい場合は、`framework/shared/modules/Config.lua` で `RunService:IsStudio()` などを見て切り替えるパターンを 1 つ用意しておくと便利です。 |
| **新規ゲームのひな型** | フォルダと `*.project.json` を手でコピーする代わりに、`scripts/new-game.lua` やドキュメントの「コピー元」を 1 セット固定しておくと、ミスが減ります。 |

### 運用で意識するとよいこと

- **Require** は「必要になるまで遅延」にすると、起動が軽くなりやすいです（特に UI やゲーム固有モジュール）。
- **イベント**（BindableEvent / RemoteEvent の Connect）は **Trove でまとめて disconnect** すると、メモリ漏れや二重登録を防ぎやすくなります（ルールにすでに Trove 推奨とあります）。
- フレームワーク自体の**バージョン**（例: README の 1 行や git タグ）を決めておくと、複数ゲームを並行して開発するときに「どのベースか」を追いやすくなります。
