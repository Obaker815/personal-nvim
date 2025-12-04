local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local fzf = require("fzf-lua")

-- ========================
-- Commands
-- ========================
cmd('W', function()
  vim.cmd('wall')
  vim.notify('All buffers written.', vim.log.levels.INFO)
end, {})

cmd('Term', function(opts)
  local dir = vim.fn.expand('%:p:h')
  vim.cmd('botright split')
  vim.cmd('resize 12')
  vim.cmd('lcd ' .. vim.fn.fnameescape(dir))
  vim.cmd('terminal ' .. (opts.args or ''))
  vim.cmd('startinsert')
end, { nargs = '*', desc = 'Open terminal in split at current file directory' })

cmd('WriteSession', function(opts)
  local sessions = require('mini.sessions')
  local name = opts.args ~= '' and opts.args or sessions.get_latest()
  if not name or name == '' then
    name = vim.fn.input('Session name: ')
  end
  sessions.write(name)
  vim.notify('Session saved: ' .. name, vim.log.levels.INFO)
end, { nargs = '?', desc = 'Write a named session' })

cmd('LoadSession', function(opts)
  local sessions = require('mini.sessions')
  sessions.read(opts.args)
  vim.notify('Session loaded: ' .. opts.args, vim.log.levels.INFO)
end, { nargs = 1, complete = 'file', desc = 'Load a session by name' })

-- ========================
-- Normal mode
-- ========================
map('n', 'Y',       'y$',       { noremap = true, silent = true })
map('n', 'n',       'nzz',      { noremap = true, silent = true })
map('n', 'N',       'Nzz',      { noremap = true, silent = true })
map('n', '<C-d>',   '<C-d>zz',  { noremap = true, silent = true })
map('n', '<C-u>',   '<C-u>zz',  { noremap = true, silent = true })

map('n', '<A-[>',       ':bp<CR>',          { noremap = true, silent = true })
map('n', '<A-]>',       ':bn<CR>',          { noremap = true, silent = true })
map('n', '<C-Insert>',  ':tabnew<CR>',      { noremap = true, silent = true })
map('n', '<C-Delete>',  ':tabclose<CR>',    { noremap = true, silent = true })
map('n', '<C-End>',     ':tabn<CR>',        { noremap = true, silent = true })
map('n', '<C-Home>',    ':tabp<CR>',        { noremap = true, silent = true })
map('n', '<F2>',        ':Explore<CR>',     { noremap = true, silent = true })
map('n', '<F5>',        ':Term<CR>',        { noremap = true, silent = true })

-- ========================
-- Visual / Terminal mode
-- ========================
map('v', '<Leader>y',   '"*y',                  { noremap = true, silent = true })
map('n', '<Leader>p',   '"*p',                  { noremap = true, silent = true })
map('t', '<C-w>',       [[<C-\><C-n><C-w>]],    { noremap = true, silent = true })
map('t', '<C-n>',       [[<C-\><C-n>]],         { noremap = true, silent = true })

-- ========================
-- FZF-Lua keymaps
-- ========================
map("n", "<leader>ff", function()
  local cwd = vim.fn.expand("%:p:h")
  fzf.files({ cwd = cwd, actions = { ["default"] = _G._fzf_open_files } })
end, { desc = "Find files in current file directory" })

map("n", "<leader>fp", function()
  fzf.files({ cwd = vim.loop.cwd(), actions = { ["default"] = _G._fzf_open_files } })
end, { desc = "Find files in project root" })

map("n", "<leader>fb", fzf.buffers, { desc = "Find open buffers" })

map("n", "<leader>fg", function()
  local cwd = vim.fn.expand("%:p:h")
  fzf.live_grep({ cwd = cwd })
end, { desc = "Live grep in current directory" })

-- ========================
-- UndoTree
-- ========================
map('n', '<leader>ut', ':UndotreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle UndoTree" })

-- ========================
-- Todo-Comments
-- ========================
map('n', '<leader>t', ':TodoTelescope<CR>', { noremap = true, desc = "Open TODO comments" })
map('n', ']t', function()
  require("todo-comments").jump_next({keywords = { "ERROR", "WARNING", "TODO", "HACK", "NOTE" }})
end, { desc = "Next todo comment" })
map('n', '[t', function()
  require("todo-comments").jump_prev({keywords = { "ERROR", "WARNING", "TODO", "HACK", "NOTE" }})
end, { desc = "Previous todo comment" })

-- ========================
-- LSP / Language Server
-- ========================
-- Go-to definitions, hover, references, rename
map('n', '<leader>gd',  vim.lsp.buf.definition,     { desc = "Go to definition" })
map('n', '<leader>gr',  vim.lsp.buf.references,     { desc = "List references" })
map('n', '<leader>K' ,  vim.lsp.buf.hover,          { desc = "Hover documentation" })
map('n', '<leader>rn',  vim.lsp.buf.rename,         { desc = "Rename symbol" })
map('n', '<leader>ca',  vim.lsp.buf.code_action,    { desc = "Code action" })

-- ========================
-- Tabby (tabline)
-- ========================
map('n', '<leader>1',   '1gt',          { desc = "Go to tab 1" })
map('n', '<leader>2',   '2gt',          { desc = "Go to tab 2" })
map('n', '<leader>3',   '3gt',          { desc = "Go to tab 3" })
map('n', '<leader>4',   '4gt',          { desc = "Go to tab 4" })
map('n', '<leader>5',   '5gt',          { desc = "Go to tab 5" })
map('n', '<leader>l',   ':tablast<CR>', { desc = "Go to last tab" })

-- ========================
-- Omnisharp (C#)
-- ========================
-- Go to definition, references, rename, etc.
map('n', '<leader>cd',  vim.lsp.buf.definition,     { desc = "OmniSharp: Go to definition" })
map('n', '<leader>cr',  vim.lsp.buf.references,     { desc = "OmniSharp: List references" })
map('n', '<leader>cn',  vim.lsp.buf.rename,         { desc = "OmniSharp: Rename symbol" })
map('n', '<leader>ca',  vim.lsp.buf.code_action,    { desc = "OmniSharp: Code action" })
