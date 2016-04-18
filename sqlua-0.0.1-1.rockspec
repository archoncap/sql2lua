package = "sqlua"
version = "0.0.1-1"
source = {
	url = "git://github.com/crowl/sqlua"
}
description = {
	summary = "Generate lua functions from SQL queries",
	detailed = [[
       This is an example for the LuaRocks tutorial.
       Here we would put a detailed, typically
       paragraph-long description.
    ]],
	homepage = "https://github.com/crowl/sqlua",
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
		sqlua = "src/sqlua.lua",
		["sqlua.parser"] = "src/sqlua/parser.lua"
	}
}
