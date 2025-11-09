return {
  "nanozuki/tabby.nvim",
  config = function()
    -- Custom highlights
    vim.api.nvim_set_hl(0, "MyTabActive", { fg = "#d1982c", bg = "#27273b", bold = true })
    vim.api.nvim_set_hl(0, "MyTabInactive", { fg = "#d1982c", bg = "#191921" })

    require("tabby").setup({
        line = function(line)
        return {
            line.tabs().foreach(function(tab)
            return {
                " " .. tab.number() .. "   ",
                hl = tab.is_current() and "MyTabActive" or "MyTabInactive",
                margin = " ",
            }
        end)
        }
      end,
    })

  end,
}

