return {
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.opt.background = "dark"
    vim.g.everforest_background = "hard"
    vim.g.everforest_enable_italic = true
    vim.g.everforest_transparent_background = 1
    pcall(vim.cmd, "colorscheme everforest")
  end,
}
