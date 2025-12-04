-- Leader keys
vim.g.mapleader = ','
vim.g.localmapleader = '\\'

-- Bootstrap lazy.nvim & load plugins
require("config.lazy")

-- Load core modules
require("set")
require("keys")
