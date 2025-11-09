return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<F3>", "<cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SetFocusWhenToggle = 1
    end
  },
}

