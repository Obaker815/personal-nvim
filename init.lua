-- Leader keys
vim.g.mapleader = ','
vim.g.localmapleader = '\\'

-- Load core modules
require("set")
require("keys")

-- Bootstrap lazy.nvim & load plugins
require("config.lazy")
