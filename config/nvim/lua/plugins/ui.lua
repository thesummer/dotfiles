-- lua/plugins/ui.lua
-- UI-related plugins: colorscheme, statusline, etc.

return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Load this before all other start plugins
    init = function()
      -- Load the colorscheme
      -- Options: "tokyonight-night", "tokyonight-storm", "tokyonight-moon", "tokyonight-day"
      vim.cmd.colorscheme("tokyonight-night")
      
      -- Custom highlight overrides
      vim.cmd.hi("Comment gui=none")
    end,
  },
  
  -- Status line and other mini plugins
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Statusline configuration
      local statusline = require("mini.statusline")
      -- Use icons if Nerd Font is available
      statusline.setup({ use_icons = vim.g.have_nerd_font })
      
      -- Customize statusline sections
      -- This sets the cursor location to LINE:COLUMN format
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
      
      -- Note: The other mini.nvim modules (ai, surround, etc.)
      -- should be moved to the editor.lua file
    end,
  },
  
  -- You can add other UI-related plugins here, such as:
  -- - Indentation guides
  -- - Dashboard/start screen
  -- - Tab line
  -- - Notifications
}
