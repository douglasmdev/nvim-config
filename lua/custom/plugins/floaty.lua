local M = {}

local state = { window = nil, buffer = nil, job = nil }

local open_floating_terminal = function()
	local buffer = state.buffer

	if buffer == nil or not vim.api.nvim_buf_is_valid(buffer) then
		buffer = vim.api.nvim_create_buf(false, false)
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.7)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local window = vim.api.nvim_open_win(buffer, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
	})

	local buftype = vim.api.nvim_get_option_value("buftype", { buf = buffer })
	if buftype ~= "terminal" then
		state.job = vim.fn.jobstart(vim.o.shell, { term = true })
	end

	vim.cmd("startinsert")
	return window, buffer
end

function M.toggle()
	if state.window and vim.api.nvim_win_is_valid(state.window) then
		vim.api.nvim_win_close(state.window, true)
		return
	end

	local window, buffer = open_floating_terminal()
	state.window, state.buffer = window, buffer
end

vim.api.nvim_create_user_command("Floaty", function()
	M.toggle()
end, {})

vim.keymap.set("n", "<c-t>", function()
	M.toggle()
end, { noremap = true })

vim.keymap.set("t", "<c-t>", function()
	local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>:Floaty<CR>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end, { noremap = true, silent = true })

return M
