-- sql2lua: Generate Lua functions from SQL queries.
-- Copyright 2016 crowl <crowl@mm.st>
-- MIT Licensed.

local lustache = require "lustache"
local parser = require "sql2lua.parser"

local function env (queries)
	return {
		queries = queries,
		params = function (self)
			local params = {}
			for _, v in ipairs(self.parts) do
				if type(v) == "table" then table.insert(params, v.param) end
			end
			return table.concat(params, ", ")
		end,
		body = function (self)
			local statement = {}
			for _, v in ipairs (self.parts) do
				if type(v) == "table" then
					table.insert(statement, "escape(" .. v.param .. ")")
				else
					table.insert(statement, "\"" .. v .. "\"")
				end
			end
			return table.concat(statement, " ..\n\t\t")
		end
	}
end

local template = [[
local type = type
local tostring = tostring

local function escape (val)
	local exp_type = type(val)
	if "number" == exp_type then
		return tostring(val)
	elseif "string" == exp_type then
		return "'" .. tostring((val:gsub("'", "''"))) .. "'"
	elseif "boolean" == exp_type then
		return val and "TRUE" or "FALSE"
	else
		return tostring(val)
	end
end

local _M = {}

{{#queries}}
function _M.{{name}} ({{params}})
	return {{&body}}
end

{{/queries}}
return _M
]]

return function (sql)
	local queries = assert(parser.parse(sql))
	local luastring = lustache:render(template, env(queries))
	return assert(loadstring(luastring))()
end
