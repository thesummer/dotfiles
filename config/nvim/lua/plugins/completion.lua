-- File: lua/plugins/completion.lua
-- Autocompletion configuration and snippets setup
--
-- This module handles code completion, snippets, and related functionality.
-- 
-- Key features:
-- - Autocompletion from multiple sources (LSP, snippets, paths)
-- - Snippet expansion and navigation
-- - LSP integration for intelligent completions
-- 
-- Key mappings:
-- - <C-n>/<C-p>: Navigate completion menu
-- - <C-y>: Accept completion
-- - <C-Space>: Manually trigger completion
-- - <C-l>/<C-h>: Navigate snippet placeholders

return { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Only load when entering insert mode for better startup time
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets
                -- This step is not supported in many windows environments
                -- Remove the below condition to re-enable on windows
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
        },
        "saadparwaiz1/cmp_luasnip", -- LuaSnip completion source

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        "hrsh7th/cmp-nvim-lsp", -- LSP completion source
        "hrsh7th/cmp-path",     -- Path completion source

        -- If you want to add a bunch of pre-configured snippets,
        --    you can use this plugin to help you. It even has snippets
        --    for various frameworks/libraries/etc. but you will have to
        --    set up the ones that are useful for you.
        -- 'rafamadriz/friendly-snippets',
    },
    config = function()
        -- See `:help cmp`
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        
        -- Set up LuaSnip
        luasnip.config.setup({})

        cmp.setup({
            -- Configure snippet engine
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            
            -- Configure completion behavior
            completion = { 
                completeopt = "menu,menuone,noinsert" -- Configure how completion works
            },

            -- For an understanding of why these mappings were
            -- chosen, you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            mapping = cmp.mapping.preset.insert({
                -- Select the [n]ext item
                ["<C-n>"] = cmp.mapping.select_next_item(),
                
                -- Select the [p]revious item
                ["<C-p>"] = cmp.mapping.select_prev_item(),

                -- Accept ([y]es) the completion.
                --  This will auto-import if your LSP supports it.
                --  This will expand snippets if the LSP sent a snippet.
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),

                -- Manually trigger a completion from nvim-cmp.
                --  Generally you don't need this, because nvim-cmp will display
                --  completions whenever it has completion options available.
                ["<C-Space>"] = cmp.mapping.complete({}),

                -- Think of <c-l> as moving to the right of your snippet expansion.
                --  So if you have a snippet that's like:
                --  function $name($args)
                --    $body
                --  end
                --
                -- <c-l> will move you to the right of each of the expansion locations.
                -- <c-h> is similar, except moving you backwards.
                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { "i", "s" }), -- Works in insert and select mode
                
                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }), -- Works in insert and select mode
            }),
            
            -- Configure completion sources
            sources = {
                { name = "nvim_lsp" }, -- LSP source has highest priority
                { name = "luasnip" },  -- Snippets source is next
                { name = "path" },     -- File path source comes last
                
                -- You can add more sources if needed:
                -- { name = "buffer" },  -- Text from current buffer
                -- { name = "calc" },    -- Math calculations
                -- { name = "emoji" },   -- Emoji source
            },
            
            -- You can add formatting configuration:
            -- formatting = {
            --    format = function(entry, vim_item)
            --        -- Add icons and customize appearance
            --        return vim_item
            --    end
            -- },
        })
        
        -- You can also set up filetype-specific configurations
        -- cmp.setup.filetype('lua', { ... })
    end,
}
