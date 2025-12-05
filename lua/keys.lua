local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

-- ========================
-- Commands
-- ========================
cmd('W', function()
    vim.cmd('wall')
    vim.notify('All buffers written.', vim.log.levels.INFO)
end, {})

cmd('Term', function(opts)
    local dir = vim.fn.expand('%:p:h')
    vim.cmd('botright split')
    vim.cmd('resize 12')
    vim.cmd('lcd ' .. vim.fn.fnameescape(dir))
    vim.cmd('terminal ' .. (opts.args or ''))
    vim.cmd('startinsert')
end, { nargs = '*', desc = 'Open terminal in split at current file directory' })

cmd('WriteSession', function(opts)
    local sessions = require('mini.sessions')
    local name = opts.args ~= '' and opts.args or sessions.get_latest()
    if not name or name == '' then
        name = vim.fn.input('Session name: ')
    end
    sessions.write(name)
    vim.notify('Session saved: ' .. name, vim.log.levels.INFO)
end, { nargs = '?', desc = 'Write a named session' })

cmd('LoadSession', function(opts)
    local sessions = require('mini.sessions')
    sessions.read(opts.args)
    vim.notify('Session loaded: ' .. opts.args, vim.log.levels.INFO)
end, { nargs = 1, complete = 'file', desc = 'Load a session by name' })

-- ========================
-- Normal mode
-- ========================
map('n', 'Y',       'y$',       { noremap = true, silent = true })
map('n', 'n',       'nzz',      { noremap = true, silent = true })
map('n', 'N',       'Nzz',      { noremap = true, silent = true })
map('n', '<C-d>',   '<C-d>zz',  { noremap = true, silent = true })
map('n', '<C-u>',   '<C-u>zz',  { noremap = true, silent = true })

map('n', '<A-[>',       ':bp<CR>',          { noremap = true, silent = true })
map('n', '<A-]>',       ':bn<CR>',          { noremap = true, silent = true })
map('n', '<C-Insert>',  ':tabnew<CR>',      { noremap = true, silent = true })
map('n', '<C-Delete>',  ':tabclose<CR>',    { noremap = true, silent = true })
map('n', '<C-End>',     ':tabn<CR>',        { noremap = true, silent = true })
map('n', '<C-Home>',    ':tabp<CR>',        { noremap = true, silent = true })
map('n', '<F2>',        ':Explore<CR>',     { noremap = true, silent = true })
map('n', '<F5>',        ':Term<CR>',        { noremap = true, silent = true })

-- ========================
-- Visual / Terminal mode
-- ========================
map('v', '<Leader>y',   '"*y',                  { noremap = true, silent = true })
map('n', '<Leader>p',   '"*p',                  { noremap = true, silent = true })
map('t', '<C-w>',       [[<C-\><C-n><C-w>]],    { noremap = true, silent = true })
map('t', '<C-n>',       [[<C-\><C-n>]],         { noremap = true, silent = true })

-- ========================
-- FZF-Lua keymaps
-- ========================
local ok, fzf = pcall(require, "fzf-lua")
if ok then
    local function open_files(selected)
        for _, file in ipairs(selected) do
            vim.cmd("edit " .. vim.fn.fnameescape(file))
        end
    end

    map("n", "<leader>ff", function()
        local cwd = vim.fn.expand("%:p:h")
        fzf.files({ cwd = cwd, actions = { ["default"] = open_files } })
    end, { desc = "Find files in current file directory" })

    map("n", "<leader>fp", function()
        fzf.files({ cwd = vim.loop.cwd(), actions = { ["default"] = open_files } })
    end, { desc = "Find files in project root" })

    map("n", "<leader>fb", fzf.buffers, { desc = "Find open buffers" })

    map("n", "<leader>fg", function()
        local cwd = vim.fn.expand("%:p:h")
        fzf.live_grep({ cwd = cwd })
    end, { desc = "Live grep in current directory" })
end

-- ========================
-- UndoTree
-- ========================
map('n', '<leader>ut', ':UndotreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle UndoTree" })

-- ========================
-- Todo-Comments
-- ========================
map('n', '<leader>t', ':TodoTelescope<CR>', { noremap = true, desc = "Open TODO comments" })
map('n', ']t', function()
    require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING", "TODO", "HACK", "NOTE" } })
end, { desc = "Next todo comment" })

map('n', '[t', function()
    require("todo-comments").jump_prev({ keywords = { "ERROR", "WARNING", "TODO", "HACK", "NOTE" } })
end, { desc = "Previous todo comment" })

-- ========================
-- LSP / OmniSharp (C#)
-- ========================
local function set_omnisharp_keymaps(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>e", vim.diagnostic.open_float, opts)
    map("n", "[d", vim.diagnostic.goto_prev, opts)
    map("n", "]d", vim.diagnostic.goto_next, opts)
    map("n", "<leader>q", vim.diagnostic.setloclist, opts)

    map("n", "<leader>oi", function()
        vim.lsp.buf.execute_command({ command = "omnisharp/organizeimports", arguments = { vim.api.nvim_buf_get_name(0) } })
    end, opts)

    map("n", "<leader>cd", vim.lsp.buf.definition, opts)
    map("n", "<leader>cr", vim.lsp.buf.references, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

return {
    set_omnisharp_keymaps = set_omnisharp_keymaps
}
