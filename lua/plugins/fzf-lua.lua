return {
    {
        "ibhagwan/fzf-lua",
        config = function()
            if vim.fn.has("nvim-0.9") ~= 1 then
                vim.notify("Fzf-lua requires Neovim >= v0.9", vim.log.levels.ERROR, { title = "fzf-lua" })
                return
            end

            local fzf = require("fzf-lua")

            -- Function to safely open selected files on Windows
            local function open_files(selected, opts)
                local cwd = opts.cwd or vim.loop.cwd()
                for _, path in ipairs(selected) do
                    -- Do not trim spaces, just normalize slashes
                    path = path:gsub("/", "\\")

                    -- Detect if path is already absolute (starts with a drive letter)
                    local fullpath = path
                    if not path:match("^[A-Za-z]:\\") then
                        fullpath = vim.fn.fnamemodify(cwd .. "\\" .. path, ":p")
                    end

                    if vim.fn.filereadable(fullpath) == 1 then
                        vim.cmd("edit " .. vim.fn.fnameescape(fullpath))
                    else
                        vim.notify("File not found: " .. fullpath, vim.log.levels.WARN)
                    end
                end
            end

            -- Basic fzf-lua setup (no icons, simple display)
            fzf.setup({
                winopts = {
                    border = "rounded",
                    preview = { layout = "vertical" },
                },
                files = {
                    prompt = "Files> ",
                    file_icons = false,
                    color_icons = false,
                    git_icons = false,
                    actions = {
                        ["default"] = open_files,             -- Enter = open selected files
                        ["ctrl-s"] = fzf.actions.file_split,  -- Ctrl+S = open in split
                        ["ctrl-v"] = fzf.actions.file_vsplit, -- Ctrl+V = open in vsplit
                        ["ctrl-t"] = fzf.actions.file_tabedit -- Ctrl+T = open in tab
                    },
                },
                grep = {
                    prompt = "Grep> ",
                    file_icons = false,
                },
                buffers = {
                    prompt = "Buffers> ",
                    file_icons = false,
                },
            })

            -- Keymaps

            -- <leader>ff : find files in the current file's directory
            vim.keymap.set("n", "<leader>ff", function()
                local cwd = vim.fn.expand("%:p:h")
                require("fzf-lua").files({ cwd = cwd })
            end, { desc = "Find files in current file directory" })

            -- <leader>fp : find files in project root
            vim.keymap.set("n", "<leader>fp", function()
                require("fzf-lua").files({ cwd = vim.loop.cwd() })
            end, { desc = "Find files in project root" })

            -- <leader>fb : list open buffers
            vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find open buffers" })

            -- <leader>fg : live grep in current file's directory
            vim.keymap.set("n", "<leader>fg", function()
                local cwd = vim.fn.expand("%:p:h")
                require("fzf-lua").live_grep({ cwd = cwd })
            end, { desc = "Live grep in current directory" })
        end,
    },
}
