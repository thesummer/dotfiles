# Neovim Configuration

This is a modular Neovim configuration structured for maintainability and extensibility. The configuration is organized into logical modules that separate different aspects of functionality.

## Directory Structure

```
lua/
├── lsp/                    # Language Server Protocol related configurations
│   ├── init.lua            # Main LSP setup and module loader
│   ├── handlers.lua        # LSP event handlers and keymaps
│   ├── mason.lua           # LSP server installation and setup
│   ├── lua_ls.lua          # Lua language server configuration
│   ├── clangd.lua          # C/C++ language server configuration
│   └── rust.lua            # Rust language server configuration
│
├── plugins/                # Plugin configurations
│   ├── filetree.lua        # File explorer (Neo-tree)
│   ├── treesitter.lua      # Syntax highlighting and code parsing
│   ├── git.lua             # Git integration plugins
│   ├── completion.lua      # Autocompletion and snippets
│   ├── formatting.lua      # Code formatting
│   └── rust.lua            # Rust-specific plugins
│
└── README.md               # This documentation file
```

## Module Descriptions

### LSP (Language Server Protocol) Modules

- **lsp/init.lua**: Entry point for LSP configuration. Sets up Mason and loads other LSP modules.
- **lsp/handlers.lua**: Configures common LSP event handlers, including keymaps for code navigation, documentation, and refactoring.
- **lsp/mason.lua**: Manages the installation and setup of language servers via Mason, Mason-lspconfig, and Mason-tool-installer.
- **lsp/lua_ls.lua**: Configuration specific to the Lua language server with workspace and completion settings.
- **lsp/clangd.lua**: Configuration for the C/C++ language server with verbose logging.
- **lsp/rust.lua**: Basic configuration for Rust language server (disabled by default when using rustaceanvim).

### Plugin Modules

- **plugins/filetree.lua**: Neo-tree file explorer configuration with custom keymaps and settings.
- **plugins/treesitter.lua**: Syntax highlighting and code parsing with support for multiple languages.
- **plugins/git.lua**: Git integration with gitsigns.nvim for gutter signs, vim-fugitive for Git commands, and gv.vim for commit browsing.
- **plugins/completion.lua**: Autocompletion and snippets using nvim-cmp, LuaSnip, and various completion sources.
- **plugins/formatting.lua**: Code formatting with conform.nvim, including toggle commands and language-specific formatters.
- **plugins/rust.lua**: Rust-specific plugins including rustaceanvim for enhanced Rust development and crates.nvim for Cargo.toml integration.

## How to Use This Configuration

### Adding New Plugins

To add a new plugin:

1. Create a new file in the `lua/plugins/` directory (e.g., `lua/plugins/myplugin.lua`)
2. Return a table with the plugin specification for lazy.nvim:

```lua
-- File: lua/plugins/myplugin.lua
return {
    "username/plugin-name",
    dependencies = {
        -- Any dependencies
    },
    config = function()
        -- Plugin configuration
    end,
}
```

### Adding New Language Support

To add support for a new language:

1. Add the language to the `ensure_installed` list in `lua/lsp/mason.lua`
2. Create a language-specific configuration file in `lua/lsp/` if needed (e.g., `lua/lsp/python.lua`)
3. Add the language to the formatters in `lua/plugins/formatting.lua` if needed
4. Add the language to the Treesitter configuration in `lua/plugins/treesitter.lua`

Example for adding Python support:

```lua
-- In lua/lsp/python.lua
return {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                -- Additional settings...
            }
        }
    }
}

-- Then add to servers table in your main setup
local servers = {
    -- Existing servers...
    pyright = {},
}
```

### Customizing Key Bindings

Most keybindings are defined in their respective modules:

- LSP keybindings: `lua/lsp/handlers.lua`
- Git keybindings: `lua/plugins/git.lua`
- File explorer keybindings: `lua/plugins/filetree.lua`
- Formatting keybindings: `lua/plugins/formatting.lua`

## Key Features

- **Modular Organization**: Each aspect of the configuration is separated into its own file for easier maintenance
- **Lazy Loading**: Plugins are loaded only when needed for faster startup time
- **LSP Integration**: Comprehensive language server support with configuration for multiple languages
- **Code Formatting**: Automatic code formatting with the ability to toggle on/off
- **Git Integration**: Full Git workflow support with status indicators and commands
- **Tree-sitter**: Enhanced syntax highlighting and code navigation
- **Completion**: Intelligent code completion with snippet support

## Customizing the Configuration

The configuration is designed to be easily customizable:

- Modify individual plugin settings in their respective files
- Add or remove plugins by adding or removing files in the `lua/plugins/` directory
- Customize LSP server configurations in the `lua/lsp/` directory
- Adjust formatters in `lua/plugins/formatting.lua`

## Credits

This configuration is based on a monolithic `init.lua` file, reorganized into a modular structure for better maintenance and extensibility. The original configuration drew inspiration from:

- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [LazyVim](https://github.com/LazyVim/LazyVim)

## Troubleshooting

If you encounter issues:

1. Check that all required dependencies are installed (run `:checkhealth`)
2. Ensure that language servers are installed (run `:Mason`)
3. Verify that formatters are available (run `:ConformInfo`)
4. Check the logs (`:messages`) for any error messages
