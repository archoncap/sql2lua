package = "sql2lua"
version = "0.0.1-1"
source = {
	url = "git://github.com/crowl/sql2lua"
}
description = {
	summary = "Generate lua functions from SQL queries",
	detailed = [[
       This is an example for the LuaRocks tutorial.
       Here we would put a detailed, typically
       paragraph-long description.
    ]],
	homepage = "https://github.com/crowl/sql2lua",
	license = "MIT/X11"
}
dependencies = {
	"lua ~> 5.1",
	"lpeg >= 1.0.0-1",
	"lustache >= 1.3.1-0"
}
build = {
	type = "builtin",
	modules = {
		sql2lua = "src/sql2lua.lua",
		["sql2lua.parser"] = "src/sql2lua/parser.lua"
	}
}
