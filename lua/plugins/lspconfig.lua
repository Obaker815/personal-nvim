return {
  "neovim/nvim-lspconfig",
  config = function()
    -- handle both pre-0.11 and 0.11+ Neovim
    local cfg = vim.lsp.configs or vim.lsp._configs
    if not cfg then
      vim.notify("LSP configs table not found; using fallback", vim.log.levels.WARN)
      return
    end

    local function ensure_started(config)
      -- safe wrapper around vim.lsp.start
      if not config then return end
      pcall(vim.lsp.start, config)
    end

    ---------------------------------------------------------------------------
    -- LUA --------------------------------------------------------------------
    ---------------------------------------------------------------------------
    if not cfg.lua_ls then
      cfg.lua_ls = {
        default_config = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_dir = vim.fs.dirname(
            vim.fs.find({ ".luarc.json", ".stylua.toml", ".git", "init.lua" }, { upward = true })[1]
          ),
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
            },
          },
        },
      }
    end
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua",
      callback = function() ensure_started(cfg.lua_ls.default_config) end,
    })

    ---------------------------------------------------------------------------
    -- PYTHON -----------------------------------------------------------------
    ---------------------------------------------------------------------------
    if not cfg.pyright then
      cfg.pyright = {
        default_config = {
          cmd = { "pyright-langserver", "--stdio" },
          filetypes = { "python" },
          root_dir = vim.fs.dirname(
            vim.fs.find({ "pyproject.toml", "setup.py", ".git" }, { upward = true })[1]
          ),
        },
      }
    end
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function() ensure_started(cfg.pyright.default_config) end,
    })

    ---------------------------------------------------------------------------
    -- JSON -------------------------------------------------------------------
    ---------------------------------------------------------------------------
    if not cfg.jsonls then
      cfg.jsonls = {
        default_config = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          root_dir = vim.fs.dirname(
            vim.fs.find({ "package.json", ".git" }, { upward = true })[1]
          ),
        },
      }
    end
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json", "jsonc" },
      callback = function() ensure_started(cfg.jsonls.default_config) end,
    })
  end,
}
