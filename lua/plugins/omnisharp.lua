return {
  "neovim/nvim-lspconfig",
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local omnisharp_path = vim.fn.expand("$LOCALAPPDATA") .. "\\omnisharp\\OmniSharp.exe"

    if vim.fn.filereadable(omnisharp_path) == 0 then
      vim.notify("OmniSharp not found at " .. omnisharp_path, vim.log.levels.ERROR)
      return
    end

    -- Autostart OmniSharp when opening .cs files
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.cs",
      callback = function(args)
        local root_files = { "*.sln", "*.csproj", ".git" }
        local root = vim.fs.dirname(vim.fs.find(root_files, { upward = true, path = args.file })[1])
        if not root then
          vim.notify("OmniSharp: could not determine project root for " .. args.file, vim.log.levels.WARN)
          return
        end

        -- Check if there's already a client attached for this root
        for _, client in ipairs(vim.lsp.get_clients({ name = "omnisharp" })) do
          if client.config.root_dir == root then
            vim.lsp.buf_attach_client(args.buf, client.id)
            return
          end
        end

        -- Otherwise, start a new OmniSharp instance
        local config = vim.lsp.config.new({
          name = "omnisharp",
          cmd = { omnisharp_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          root_dir = root,
          filetypes = { "cs", "vb" },
          settings = {
            FormattingOptions = { EnableEditorConfigSupport = true },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
              AnalyzeOpenDocumentsOnly = false,
            },
          },
          capabilities = capabilities,
        })

        vim.lsp.start(config)
      end,
    })
  end,
}
