local lsp = vim.lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local keys = require("keys") -- our keys.lua module

local omnisharp_path = vim.fn.expand("$LOCALAPPDATA") .. "\\omnisharp\\OmniSharp.exe"

return {
    "neovim/nvim-lspconfig",
    ft = { "cs", "vb" },
    config = function()
        if vim.fn.filereadable(omnisharp_path) == 0 then
            vim.notify("OmniSharp not found at " .. omnisharp_path, vim.log.levels.ERROR)
            return
        end

        -- Find project root and solution file
        local function find_root(file)
            local root_files = { "*.sln", "*.csproj" }
            local match = vim.fs.find(root_files, { upward = true, path = file })[1]
            local root_dir = match and vim.fs.dirname(match) or vim.loop.cwd()
            return root_dir, match
        end

        vim.api.nvim_create_autocmd("BufReadPost", {
            pattern = "*.cs",
            callback = function(args)
                local root, solution = find_root(args.file)

                -- Reuse client if already running for this root
                for _, client in ipairs(lsp.get_clients({ name = "omnisharp" })) do
                    if client.config.root_dir == root then
                        lsp.buf_attach_client(args.buf, client.id)
                        return
                    end
                end

                -- Build OmniSharp command
                local cmd = { omnisharp_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
                if solution then
                    table.insert(cmd, "--solution")
                    table.insert(cmd, solution)
                end

                local config = {
                    name = "omnisharp",
                    cmd = cmd,
                    root_dir = root,
                    filetypes = { "cs", "vb" },
                    capabilities = capabilities,
                    settings = {
                        FormattingOptions = { EnableEditorConfigSupport = true, OrganizeImports = true },
                        RoslynExtensionsOptions = {
                            EnableAnalyzersSupport = true,
                            EnableImportCompletion = true,
                            AnalyzeOpenDocumentsOnly = false,
                        },
                        EnableAsyncCompletion = true,
                        EnableDecompilationSupport = true,
                        EnableImportCompletion = true,
                        EnableEditorConfigSupport = true,
                    },
                }

                local client_id = lsp.start(config)
                if client_id then
                    -- attach keymaps
                    keys.set_omnisharp_keymaps(args.buf)
                end
            end,
        })
    end,
}
