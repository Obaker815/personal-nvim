-- Leader keys
vim.g.mapleader = ','
vim.g.localmapleader = '\\'

-- Bootstrap lazy.nvim & load plugins
require("config.lazy")

-- Load core modules
require("set")
require("keys")

vim.api.nvim_create_user_command("ReloadConfig", function()
    -- Clear cache for your modules
    for _, mod in ipairs({ "set", "keys", "config.lazy" }) do
        package.loaded[mod] = nil
        require(mod)
    end
    vim.notify("Configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim Lua configuration" })
