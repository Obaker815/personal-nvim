-- =======================================
-- Keymaps & Custom Commands (Modernized)
-- =======================================

-- Safer helper
local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

-- -------------------------
-- Commands
-- -------------------------

-- Safer :W command (writes all buffers)
cmd('W', function()
  vim.cmd('wall') -- write all
  vim.notify('All buffers written.', vim.log.levels.INFO)
end, {})

-- Custom terminal launcher (horizontal split)
cmd('Term', function(opts)
  local dir = vim.fn.expand('%:p:h')
  local height = 12
  vim.cmd('botright split')
  vim.cmd('resize ' .. height)
  vim.cmd('lcd ' .. vim.fn.fnameescape(dir))
  vim.cmd('terminal ' .. (opts.args or ''))
  vim.cmd('startinsert')
end, { nargs = '*', desc = 'Open terminal in split at current file directory' })

-- Session handling (MiniSessions)
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
  local name = opts.args
  sessions.read(name)
  vim.notify('Session loaded: ' .. name, vim.log.levels.INFO)
end, { nargs = 1, complete = 'file', desc = 'Load a session by name' })

-- -------------------------
-- Normal mode behavior
-- -------------------------

-- Standardize Y like y$
map('n', 'Y', 'y$', { noremap = true, silent = true })
map('n', '<S-y>', 'y$')

-- Keep search results centered
map('n', 'n', 'nzz', { noremap = true, silent = true })
map('n', 'N', 'Nzz', { noremap = true, silent = true })
map('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
map('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })

-- Buffer management
map('n', '<A-[>', ':bp<CR>', { noremap = true, silent = true })
map('n', '<A-]>', ':bn<CR>', { noremap = true, silent = true })

-- Tab management
map('n', '<C-Insert>', ':tabnew<CR>', { noremap = true, silent = true })
map('n', '<C-Delete>', ':tabclose<CR>', { noremap = true, silent = true })
map('n', '<C-End>', ':tabn<CR>', { noremap = true, silent = true })
map('n', '<C-Home>', ':tabp<CR>', { noremap = true, silent = true })

-- File explorer
map('n', '<F2>', ':Explore<CR>', { noremap = true, silent = true })

-- Terminal launcher
map('n', '<F5>', ':Term<CR>', { noremap = true, silent = true })
map('n', '<F1>', '', { noremap = true, silent = true })

-- Clipboard yank/paste
map('v', '<Leader>y', '"*y', { noremap = true, silent = true })
map('n', '<Leader>p', '"*p', { noremap = true, silent = true })

-- -------------------------
-- Terminal mode navigation
-- -------------------------
map('t', '<C-w>', [[<C-\><C-n><C-w>]], { noremap = true, silent = true })
map('t', '<C-n>', [[<C-\><C-n>]], { noremap = true, silent = true })
