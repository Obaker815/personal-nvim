-- Basic Neovim options
local o = vim.opt

-- Numbers
o.number = true
o.relativenumber = true

-- Tabs / indentation
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.autoindent = true
o.smartindent = true

-- Search
o.incsearch = true
o.hlsearch = true
o.showmatch = true

-- Colors
o.termguicolors = true
o.background = "dark"

-- Disable bells / backups
o.errorbells = false
o.visualbell = false
o.belloff = "all"
o.swapfile = false
o.backup = false

-- Python
vim.g.python3_host_prog = "%localappdata%/Programs/Python/Python312/python.exe"

-- Tabline
o.showtabline = 2

-- Transparent background highlight
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
]])
