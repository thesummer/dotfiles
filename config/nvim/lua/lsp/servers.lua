-- File: lua/lsp/servers.lua
-- LSP server configurations
-- Contains settings for all language servers used in this configuration

-- Return a table of server configurations that will be used by lspconfig
return {
    -- C/C++ language server
    clangd = require("lsp.clangd"),
    
    -- Lua language server
    lua_ls = require("lsp.lua_ls"),
    
    -- Rust language server - handled separately by rustaceanvim
    -- We set enabled to false since rustaceanvim handles it instead
    rust_analyzer = require("lsp.rust"),
    
    -- Add more language servers here
    -- gopls = {},
    -- pyright = {},
    -- tsserver = {},
}
