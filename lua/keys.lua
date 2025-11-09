vim.api.nvim_create_user_command('W', function() end, {})

-- Yank and search behavior
vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true }) -- standardize Y like y$
vim.keymap.set("n", "<S-y>", "y$")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Buffer management
vim.keymap.set('n', '<A-[>', ':bp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-]>', ':bn<CR>', { noremap = true, silent = true })

-- Tab management
vim.keymap.set('n', '<C-Insert>', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Delete>', ':tabclose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-End>', ':tabn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Home>', ':tabp<CR>', { noremap = true, silent = true })

-- File explorer (from your .vimrc)
vim.keymap.set('n', '<F2>', ':Explore<CR>', { noremap = true, silent = true })

-- Terminal launcher
vim.keymap.set('n', '<F5>', ':Term<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<F1>', '', { noremap = true, silent = true })

-- Clipboard yank/paste
vim.keymap.set('v', '<Leader>y', '"*y')
vim.keymap.set('n', '<Leader>p', '"*p')

-- Custom terminal command that opens in a horizontal split
vim.api.nvim_create_user_command('Term', function(opts)
  local dir = vim.fn.expand('%:p:h')  -- current file directory
  local term_height = 10
  vim.cmd("botright split")            -- horizontal split on the bottom
  vim.cmd("resize " .. term_height)    -- set the height
  vim.cmd("lcd " .. dir)               -- set local cwd for the split
  vim.cmd("terminal " .. (opts.args or "")) -- run terminal
  vim.cmd("startinsert")               -- go straight into insert mode
end, { nargs = "*" })                  -- allows passing arguments to terminal

-- Session handling
vim.api.nvim_create_user_command('WriteSession', function(opts)
  local name = opts.args ~= '' and opts.args or require('mini.sessions').get_latest()
  if name == nil then
    name = vim.fn.input('Session name: ')
  end
  require('mini.sessions').write(name)
end, { nargs = '?' })

vim.api.nvim_create_user_command('LoadSession', function(opts)
  local name = opts.args
  require('mini.sessions').read(name)
  print('Loaded session "' .. name .. '"')
end, { nargs = 1 })

-- Terminal mode window navigation
vim.api.nvim_set_keymap('t', '<C-w>', [[<C-\><C-n><C-w>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-n>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Telescope shortcuts
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
