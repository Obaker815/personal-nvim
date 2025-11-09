vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.g.everforest_background = "hard"

vim.cmd("colorscheme everforest")

vim.g.lightline = { colorscheme = "everforest" }

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
]])

vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.belloff = "all"
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
