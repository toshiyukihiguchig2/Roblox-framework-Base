--[[
	共通ログ（framework / games 共通）
	- ログレベルで出力を絞れる（本番では info を落とす想定）
	- error 時はスタックトレースを付与可能
	利用: init の Knit.Start():catch(Logger.error) のほか、各 Service/Controller から require して使用
]]
local RunService = game:GetService("RunService")

local LEVEL = {
	DEBUG = 0,
	INFO = 1,
	WARN = 2,
	ERROR = 3,
	NONE = 4,
}

local Logger = {}

-- 本番では INFO 以上のみ（Studio では DEBUG も可）
Logger.Level = RunService:IsStudio() and LEVEL.DEBUG or LEVEL.INFO
Logger.Prefix = "[Framework]"

function Logger._emit(level, prefix, ...)
	local n = select("#", ...)
	if n == 0 then return prefix end
	local parts = { prefix }
	for i = 1, n do
		local v = select(i, ...)
		parts[i + 1] = type(v) == "string" and v or tostring(v)
	end
	return table.concat(parts, " ")
end

function Logger.debug(...)
	if Logger.Level <= LEVEL.DEBUG then
		print(Logger._emit(LEVEL.DEBUG, Logger.Prefix, ...))
	end
end

function Logger.info(...)
	if Logger.Level <= LEVEL.INFO then
		print(Logger._emit(LEVEL.INFO, Logger.Prefix, ...))
	end
end

function Logger.warn(...)
	if Logger.Level <= LEVEL.WARN then
		warn(Logger._emit(LEVEL.WARN, Logger.Prefix, ...))
	end
end

-- Promise:catch(Logger.error) 用。メッセージ + スタックを出す。
function Logger.error(...)
	if Logger.Level <= LEVEL.ERROR then
		local msg = Logger._emit(LEVEL.ERROR, Logger.Prefix .. " ERROR", ...)
		local err = select(1, ...)
		if type(err) == "string" then
			warn(msg)
		else
			warn(msg, err)
		end
		if type(err) == "table" and err.trace then
			warn(err.trace)
		elseif RunService:IsStudio() then
			warn(debug.traceback())
		end
	end
end

-- レベルを外部から変更（例: 本番で INFO に固定）
function Logger.setLevel(level)
	Logger.Level = level
end

Logger.LEVEL = LEVEL

return Logger
