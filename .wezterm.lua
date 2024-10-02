local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_tab_bar = true

config.font = wezterm.font("JetBrains Mono")

config.keys = {
	{ key = "f", mods = "CTRL", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Split vertically
	{
		key = "\\",
		mods = "CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Split horizontally
	{
		key = "D",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Windows Movement
	{
		key = "l",
		mods = "OPT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "OPT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "OPT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "h",
		mods = "OPT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
}

config.harfbuzz_features = {
	"calt=1",
	"liga=1",
	"ss02=1",
	"zero=1",
	"onum=1",
	"dlig=1",
	"kern=1",
	"ss01=1",
	"ss03=1",
	"ss04=1",
	"ss05=1",
	"ss06=1",
	"ss07=1",
	"ss08=1",
	"ss09=1",
	"ss10=1",
	"ss11=1",
	"ss12=1",
	"ss13=1",
	"ss14=1",
	"ss15=1",
	"ss16=1",
	"ss17=1",
	"ss18=1",
	"ss19=1",
	"ss2=1",
}

config.color_scheme = "Dracula"
config.font_size = 16
config.line_height = 1.2
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"

config.use_fancy_tab_bar = false

return config
