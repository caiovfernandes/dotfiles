local wezterm = require("wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local config = wezterm.config_builder()
local w = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

config.window_close_confirmation = "NeverPrompt"
-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

-- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- you have to use this instead, but note that this will not work
-- in all cases (e.g. over an SSH connection). Also note that
-- `pane:get_foreground_process_name()` can have high and highly variable
-- latency, so the other implementation of `is_vim()` will be more
-- performant as well.
local function is_vim(pane)
	-- This gsub is equivalent to POSIX basename(3)
	-- Given "/foo/bar" returns "bar"
	-- Given "c:\\foo\\bar" returns "bar"
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL",
		action = w.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "CTRL|SHIT" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.enable_tab_bar = true

config.font = wezterm.font({
	family = "JetBrains Mono",
})
config.native_macos_fullscreen_mode = true
config.max_fps = 120
config.animation_fps = 120
config.send_composed_key_when_right_alt_is_pressed = false
config.send_composed_key_when_left_alt_is_pressed = true
config.mouse_wheel_scrolls_tabs = true
config.tab_max_width = 50
local gpus = wezterm.gui.enumerate_gpus()

config.webgpu_preferred_adapter = gpus[1]
config.front_end = "WebGpu"
config.dpi = 144
config.custom_block_glyphs = false
config.keys = {

	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),

	--Fullscreen
	{
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},

	-- Search
	{ key = "f", mods = "CTRL", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },

	-- Rename tab
	{
		key = "u",
		mods = "CMD|SHIFT",
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
		key = "V",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Split horizontally
	{
		key = "D",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Kill pane
	{
		key = "p",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- -- Windows Movement
	-- {
	-- 	key = "l",
	-- 	mods = "OPT",
	-- 	action = wezterm.action.ActivatePaneDirection("Right"),
	-- },
	-- {
	-- 	key = "k",
	-- 	mods = "OPT",
	-- 	action = wezterm.action.ActivatePaneDirection("Up"),
	-- },
	-- {
	-- 	key = "j",
	-- 	mods = "OPT",
	-- 	action = wezterm.action.ActivatePaneDirection("Down"),
	-- },
	-- {
	-- 	key = "h",
	-- 	mods = "OPT",
	-- 	action = wezterm.action.ActivatePaneDirection("Left"),
	-- },
	-- Bind CopyMode to CMD + x
	{
		key = "x",
		mods = "CMD",
		action = wezterm.action.ActivateCopyMode,
	},
	-- Resize window and font
	{
		key = "0",
		mods = "CMD|SHIFT",
		action = wezterm.action.ResetFontAndWindowSize,
	},
	{
		key = ";",
		mods = "CMD",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "e",
		mods = "CMD",
		action = act.EmitEvent("trigger-vim-with-scrollback"),
	},
	-- Enable Debug Ovbverlay
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ShowDebugOverlay,
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

-- config.color_scheme = "Abernathy"
-- config.color_scheme = "Atom"
config.color_scheme = "Duckbones"

-- config.color_scheme = "Floraverse"
-- config.color_scheme = "Laser"
-- config.color_scheme = "Material Vivid (base16)"
-- config.color_scheme = "midnight-in-mojave"
-- config.color_scheme = "Mikazuki (terminal.sexy)"
config.font_size = 16
config.line_height = 1.2
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.7
config.macos_window_background_blur = 50
config.use_fancy_tab_bar = false
tabline.setup()
config.notification_handling = "AlwaysShow"
config.anti_alias_custom_block_glyphs = true
config.audible_bell = "SystemBeep"
config.bold_brightens_ansi_colors = true
config.font_shaper = "Harfbuzz"

config.set_environment_variables = {
	SHELL = "/bin/zsh",
}
wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	-- Retrieve the text from the pane
	local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewWindow({
			args = { "/opt/homebrew/bin/nvim", name },
		}),
		pane
	)

	-- Wait "enough" time for vim to read the file before we remove it.
	-- The window creation and process spawn are asynchronous wrt. running
	-- this script and are not awaitable, so we just pick a number.
	--
	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

return config
