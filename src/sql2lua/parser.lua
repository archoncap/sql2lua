local lpeg = require "lpeg"

local P, S, R, V = lpeg.P, lpeg.S, lpeg.R, lpeg.V
local C, Cg, Cf, Cc = lpeg.C, lpeg.Cg, lpeg.Cf, lpeg.Cc

local lower                 = R("az")
local upper                 = R("AZ")
local numeral               = R("09")
local alpha                 = lower + upper
local alphanum              = alpha + numeral
local space                 = S" \t"^1
local newline               = P"\n" + P"\r\n"
local blankline             = S" \t"^0 * newline
local name_tag              = P"name:"
local name                  = (lower^1 * (alphanum + P"_")^0)^1
local comment_marker        = P"--"
local line                  = (alphanum^1 + S".,?<>+-*/=:()_'")^1
local named_parameter       = P":" * C((alpha^1 * (alpha + P"_")^0)^1)
local placeholder_parameter = P"?"
local parameter             = Cg(named_parameter + C(placeholder_parameter))^1 * blankline^-1

local function wrap_param (p)
	return p / function (name) return { param = name } end
end

local function wrap_statement (p)
	return p / function (...) return {...} end
end

local statement_parser = P{
	"statement",
	statement = wrap_statement(V"string" * (wrap_param(parameter) * V"string")^0),
	string    = C(space^-1 * ((line - parameter)^1 * space^-1)^0)
}

local function query_as_table (p)
	return p / function (name, statement)
		return {
			name = name,
			parts = statement_parser:match(statement)
		}
	end
end

local function join (a, b)
	return a .. " " .. b
end

local function table_append (t, v)
	t[#t + 1] = v
	return t
end

local queryfile_parser = P{
	"queries",
	queries   = Cf(Cc({}) * V"query"^0, table_append) * -1,
	query     = query_as_table(V"name" * V"statement"),
	statement = Cf(V"line"^1, join),
	name      = space^-1 * comment_marker * space^0 * name_tag * space^1 * C(name) * space^-1 * newline,
	line      = space^-1 * -comment_marker * (C(line) * space^-1)^0 * newline
}

return function (str)
	return queryfile_parser:match(str)
end
