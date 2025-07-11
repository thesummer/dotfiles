return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
        command_palette = false,
      },
      cmdline = { view = "cmdline" },
    },
  },

  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          -- Disable, I currently just jump to a certain character
          enabled = false,
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    -- opts will be merged with the parent spec
    opts = {
      -- scroll = { enabled = false },
      scroll = { animate = { duration = { steps = 15, total = 50 } } },
      indent = { animate = { enabled = false } },
      picker = {
        -- open from the bottom (for the most part), but open explorer as sidebar
        layout = {
          preset = "ivy",
        },
        git = {
          enabled = false,
        },
        sources = {
          -- Make command history also open from the bottom
          command_history = {
            layout = {
              preset = "ivy",
              position = "bottom",
            },
          },
        },
      },
    },
  },
}
