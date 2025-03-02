-- lua/plugins/lsp.lua
-- LSP plugin loader that imports the LSP configuration from the lsp/ directory

-- We simply return the LSP configuration from the lsp/init.lua module
-- This bridges your lsp/ modules with the plugin system
return require("lsp")
