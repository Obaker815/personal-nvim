return {
    {
        "ibhagwan/fzf-lua",
        config = function()
            local fzf = require("fzf-lua")

            -- Set the path to your Windows fzf executable
            local fzf_path = vim.fn.expand("$LOCALAPPDATA") .. "\\fzf\\fzf.exe"

            -- Check if the executable exists
            if vim.fn.filereadable(fzf_path) == 0 then
                vim.notify("fzf.exe not found at " .. fzf_path, vim.log.levels.ERROR)
                return
            end

            -- Setup fzf-lua with native executable
            fzf.setup({
                fzf_bin = fzf_path,
                winopts = {
                    border = "rounded",
                    preview = { layout = "vertical" },
                },
                files = { file_icons = false, git_icons = false },
                grep = { file_icons = false },
                buffers = { file_icons = false },
            })

            -- Helper function for Windows path handling
            _G._fzf_open_files = function(selected, opts)
                local cwd = opts.cwd or vim.loop.cwd()
                for _, path in ipairs(selected) do
                    path = path:gsub("/", "\\")
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
        end,
    },
}
