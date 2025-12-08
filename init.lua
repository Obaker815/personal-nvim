-- Leader keys
vim.g.mapleader = ','
vim.g.localmapleader = '\\'

-- Set powershell as the default terminal
vim.opt.shell = "powershell.exe"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- Bootstrap lazy.nvim & load plugins
require("config.lazy")

-- Load core modules
require("set")
require("keys")
