local hostname = read_hostname_file() or read_hostname_cmd()

if hostname == "dainsleif" then

return {
	"wakatime/vim-wakatime",
	lazy = false,
}
else
    return {}
end
