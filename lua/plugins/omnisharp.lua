return {
  "neovim/nvim-lspconfig",
  config = function()
    local lsp = vim.lsp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local omnisharp_path = vim.fn.expand("$LOCALAPPDATA") .. "\\omnisharp\\OmniSharp.exe"

    if vim.fn.filereadable(omnisharp_path) == 0 then
      vim.notify("OmniSharp not found at " .. omnisharp_path, vim.log.levels.ERROR)
      return
    end

    local function find_root(file)
      local root_files = { "*.sln", "*.csproj", ".git" }
      local match = vim.fs.find(root_files, { upward = true, path = file })[1]
      return match and vim.fs.dirname(match) or nil
    end

    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.cs",
      callback = function(args)
        local root = find_root(args.file)
        if not root then
          vim.notify("OmniSharp: could not determine project root for " .. args.file, vim.log.levels.WARN)
          return
        end

        -- Reuse client if already running for this root
        for _, client in ipairs(lsp.get_clients({ name = "omnisharp" })) do
          if client.config.root_dir == root then
            lsp.buf_attach_client(args.buf, client.id)
            return
          end
        end

        -- Full OmniSharp configuration
        local config = {
          name = "omnisharp",
          cmd = { omnisharp_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          root_dir = root,
          filetypes = { "cs", "vb" },
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
              AnalyzeOpenDocumentsOnly = false,
            },
            -- These extra flags ensure full Roslyn command support
            EnableAsyncCompletion = true,
            EnableDecompilationSupport = true,
            EnableImportCompletion = true,
            EnableEditorConfigSupport = true,
          },
          capabilities = capabilities,
        }

        if type(config.cmd) ~= "table" or #config.cmd == 0 then
          vim.notify("OmniSharp: invalid command configuration", vim.log.levels.ERROR)
          return
        end

        -- Start the language server
        local client_id = lsp.start(config)
        if client_id then
          vim.defer_fn(function()
            local client = lsp.get_client_by_id(client_id)
            if client and not client.server_capabilities.executeCommandProvider then
              vim.notify(
                "OmniSharp: this build does not support workspace/executeCommand.\nSome commands (e.g. organizeUsings) will not work.",
                vim.log.levels.WARN
              )
            end
          end, 500)
        end
      end,
    })
  end,
}
