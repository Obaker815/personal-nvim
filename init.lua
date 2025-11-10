vim.g.mapleader = ','
vim.g.localmapleader = '\\'

-- Load core modules
require("config.lazy")
require("set")
require("keys")

-- LSP setup


-- Plugins
require("plugins.undotree")
require("plugins.cmp")
require("plugins.todo")
require("plugins.tabby")
require("plugins.fzf-lua")

vim.o.showtabline = 2

-- Python path
vim.g.python3_host_prog = "%localappdata%/Programs/Python/Python312/python.exe"

-- Auto change directory to home on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("cd ~")
  end,
})

-- automatically apply your colorscheme if everforest is installed
pcall(function()

end)

-- Lightline colors if using lightline plugin


-- Uncomment if you want color highlighting from LSP
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client.server_capabilities.colorProvider then
--       vim.lsp.document_color.enable(true, args.buf)
--     end
--   end,
-- })
