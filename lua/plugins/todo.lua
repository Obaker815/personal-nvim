return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    opts = {
        highlight = {
            keyword = "wide_bg",
            after = "fg"
        }
    },

    vim.keymap.set('n', '<Leader>t', ':TodoTelescope<CR>', {noremap = true }),

    vim.keymap.set("n", "]t", function()
      require("todo-comments").jump_next({keywords = { "ERROR", "WARNING", "TODO", "HACK", "NOTE" }})
    end, { desc = "Next todo comment" }),

    vim.keymap.set("n", "[t", function()
      require("todo-comments").jump_prev({keywords = { "ERROR", "WARNING", "TODO", "HACK", "NOTE" }})
    end, { desc = "Previous todo comment" }),
}
