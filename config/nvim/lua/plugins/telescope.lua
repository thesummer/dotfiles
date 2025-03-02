-- lua/plugins/telescope.lua
-- Telescope fuzzy finder configuration

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      -- Required dependency
      "nvim-lua/plenary.nvim",
      
      -- FZF sorter for better performance
      { 
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        -- Only install if make is available
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      
      -- Use telescope for UI selections (like code actions)
      { "nvim-telescope/telescope-ui-select.nvim" },
      
      -- Icons in telescope (requires Nerd Font)
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        defaults = {
          -- Use bottom pane layout by default
          layout_strategy = "bottom_pane",
          layout_config = {
            bottom_pane = {
              prompt_position = "bottom",
              -- height = require('telescope.config.resolve').resolve_height(0.999),
            },
          },
          -- Available layout styles that can be cycled with <C-j>
          cycle_layout_list = {
            {
              layout_strategy = "bottom_pane",
              layout_config = {
                bottom_pane = {
                  height = { padding = 0 },
                },
              },
            },
            "bottom_pane",
          },
          -- Custom keymaps within telescope
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions.layout").toggle_preview,
              ["<C-j>"] = require("telescope.actions.layout").cycle_layout_next,
            },
          },
        },
        -- pickers = {},
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- [[ Keymaps ]]
      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      
      -- Git file navigation
      vim.keymap.set("n", "<leader>t", builtin.git_files, { desc = "[S]earch [G]it" })
      vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[S]earch [G]it" })
      
      -- Documentation and keymaps
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      
      -- File and buffer navigation
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      
      -- Text searching
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      --vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      
      -- Diagnostics
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      
      -- Advanced search options
      
      -- Fuzzy search in current buffer
      vim.keymap.set("n", "<leader>/", function()
          builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
              winblend = 10,
              previewer = false,
          }))
      end, { desc = "[/] Fuzzily search in current buffer" })
      
      -- Custom grep search with user input
      vim.keymap.set("n", "<leader>f", function()
          local input_string = vim.fn.input("Rg ")
          if input_string == "" then
              return
          end
          require("telescope.builtin").grep_string({
              search = input_string,
          })
      end, { desc = "[f] Search [f]iles with term" })
      
      -- Search for word under cursor
      vim.keymap.set(
          "n",
          "<leader>ff",
          ":Telescope grep_string search=<C-r><C-w><cr>",
          { desc = "Search for word under cursor" }
      )
      
      -- Live grep in open files only
      vim.keymap.set("n", "<leader>s/", function()
          builtin.live_grep({
              grep_open_files = true,
              prompt_title = "Live Grep in Open Files",
          })
      end, { desc = "[S]earch [/] in Open Files" })
      
      -- Search Neovim config files
      vim.keymap.set("n", "<leader>sn", function()
          builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },
}
