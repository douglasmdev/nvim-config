local M = {}

local state = {
	window = nil,
	terminals = {},
	current = 1,
}

local function ensure_terminal(index)
	local term = state.terminals[index]
	if term and term.buffer and vim.api.nvim_buf_is_valid(term.buffer) then
		return term
	end

	local buffer = vim.api.nvim_create_buf(false, false)
	local original_buffer = vim.api.nvim_get_current_buf()
	vim.api.nvim_set_current_buf(buffer)
	local job = vim.fn.jobstart(vim.o.shell, { term = true })
	vim.api.nvim_set_current_buf(original_buffer)

	term = { buffer = buffer, job = job }
	state.terminals[index] = term
	return term
end

local function title_string()
	local total = #state.terminals
	if total == 0 then
		return "Term 0/0"
	end

	local parts = {}
	for i = 1, total do
		if i == state.current then
			parts[#parts + 1] = "[" .. i .. "]"
		else
			parts[#parts + 1] = tostring(i)
		end
	end

	return "Term " .. state.current .. "/" .. total .. " | " .. table.concat(parts, " ")
end

local function update_title()
	if state.window and vim.api.nvim_win_is_valid(state.window) then
		vim.api.nvim_win_set_config(state.window, { title = title_string(), title_pos = "center" })
	end
end

local open_floating_terminal = function()
	if #state.terminals == 0 then
		state.current = 1
		ensure_terminal(1)
	end

	local term = ensure_terminal(state.current)

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.7)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local window = vim.api.nvim_open_win(term.buffer, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		title = title_string(),
		title_pos = "center",
	})

	vim.cmd("startinsert")
	return window
end

function M.toggle()
	if state.window and vim.api.nvim_win_is_valid(state.window) then
		vim.api.nvim_win_close(state.window, true)
		return
	end

	local window = open_floating_terminal()
	state.window = window
end

function M.close()
	if state.window and vim.api.nvim_win_is_valid(state.window) then
		vim.api.nvim_win_close(state.window, true)
	end
end

function M.next_terminal()
	local total = #state.terminals
	if total == 0 then
		state.current = 1
		ensure_terminal(1)
	else
		if state.current == total then
			state.current = total + 1
			ensure_terminal(state.current)
		else
			state.current = state.current + 1
		end
	end

	if state.window and vim.api.nvim_win_is_valid(state.window) then
		local term = ensure_terminal(state.current)
		vim.api.nvim_win_set_buf(state.window, term.buffer)
		vim.cmd("startinsert")
		update_title()
	end
end

function M.prev_terminal()
	local total = #state.terminals
	if total == 0 then
		state.current = 1
		ensure_terminal(1)
	else
		if state.current == 1 then
			state.current = total
		else
			state.current = state.current - 1
		end
	end

	if state.window and vim.api.nvim_win_is_valid(state.window) then
		local term = ensure_terminal(state.current)
		vim.api.nvim_win_set_buf(state.window, term.buffer)
		vim.cmd("startinsert")
		update_title()
	end
end

vim.api.nvim_create_user_command("Floaty", function()
	M.toggle()
end, { desc = "Toggle floating terminals" })

vim.keymap.set("n", "<leader>tt", function()
	M.toggle()
end, { noremap = true, desc = "Toggle floating terminals" })

vim.keymap.set("t", "<leader>tt", function()
	local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
	vim.schedule(function()
		M.toggle()
	end)
end, { noremap = true, silent = true, desc = "Toggle floating terminals" })

vim.keymap.set("n", "<leader>tc", function()
	M.close()
end, { noremap = true, desc = "Close floating terminals window" })

vim.keymap.set("t", "<leader>tc", function()
	local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
	vim.schedule(function()
		M.close()
	end)
end, { noremap = true, silent = true, desc = "Close floating terminals window" })

vim.keymap.set("n", "<C-S-j>", function()
	M.next_terminal()
end, { noremap = true, desc = "Next floating terminal" })

vim.keymap.set("t", "<C-S-j>", function()
	local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
	vim.schedule(function()
		M.next_terminal()
	end)
end, { noremap = true, silent = true, desc = "Next floating terminal" })

vim.keymap.set("n", "<C-S-k>", function()
	M.prev_terminal()
end, { noremap = true, desc = "Previous floating terminal" })

vim.keymap.set("t", "<C-S-k>", function()
	local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
	vim.schedule(function()
		M.prev_terminal()
	end)
end, { noremap = true, silent = true, desc = "Previous floating terminal" })

return M
