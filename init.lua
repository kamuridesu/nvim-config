local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function read_hostname_file()
	local file = io.open("/etc/hostname", "r")
	local content = file:read("*all")
	file:close()
	return trim(content)
end

function read_hostname_cmd()
	local cmd = io.popen("hostname")
	local hostname = cmd:read("*all")
	cmd:close()
	return trim(hostname)
end

require("config.settings")
require("config.lazy")
require("config.keymapping")
