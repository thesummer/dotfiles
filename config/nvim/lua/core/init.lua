-- lua/core/init.lua
-- Core module loader that initializes all Neovim basics

-- [[ Load Order Explanation ]]
-- 1. Options: First, we load basic Vim options and settings
-- 2. Keymaps: Next, we set up keymaps that don't depend on plugins
-- 3. Autocmds: Finally, we configure auto commands for various events

-- Load Neovim options and settings
require("core.options")

-- Load core keymaps (plugin keymaps are loaded with their plugins)
require("core.keymaps")

-- Load autocommands
require("core.autocmds")

-- Note: We don't return anything here, each module sets its respective settings directly
