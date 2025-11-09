return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
      require("nvim-tressitter.install").update({ with_sync = true })
  end,
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { "lua", "python", "javascript", "c_sharp", "cpp" },
      highlight = {
        enable = true,
      },
    }
  end,

  opts = {
      testobjects ={
          move = {
              enable = true,
              goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer"},
              goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer"},
          }
      }
  }
}

