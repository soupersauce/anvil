# anvil
A highly adaptable Neovim distribution.

## Preview:
![anvil preview](images/anvil.png?raw=true "anvil preview")

### Completions

<<<<<<< HEAD
![anvil completions preview](images/anvil-completions.png?raw=true "anvil completions preview")
=======
Includes full LSP support and suggestions for snippets

![anvil completions preview](/images/anvil-completions.png?raw=true "anvil completions preview")
>>>>>>> master

Anvil uses LuaSnip as the snippet engine, and has support for vscode and LSP snippets out of the box. Adding more snippets is as simple as editing a ![json file](./snippets/javascript.json "link to javascript.json file containing example snippets") file while more advance/smart snippets can be written in Lua using LuaSnip.

### StatusLine

Awesome StatusLine implemented in lua, without any plugin dependencies. ![check it out!](/lua/configuration/statusline.lua "link to anvil statusline code")

![StatusLine preview](/images/statusline.png?raw=true "StatusLine preview")

- Current mode indicator
- Current file path including unwritten state and read only indicator
- Buffer list ( use `<Leader> + b` to show and switch between previous and next buffer using `[b` and `]b`)
- Stats related to diagnostics (number of Errors `E`, Warnings `W`, Information `I` and Hints `H`)
- Language Server status
- File encoding, format ant type information
- File position indicators (current file progress + cursor coordinates)

An accent color is applied to the statusbar depending on current mode. The color is applied to Mode, Current Buffer, file format, and cursor position indicator sections of the statusline.

![StatusLine normal mode preview](/images/normal.png?raw=true "StatusLine normal mode preview")
![StatusLine insert mode preview](/images/insert.png?raw=true "StatusLine insert mode preview")
![StatusLine replace mode preview](/images/replace.png?raw=true "StatusLine replace mode preview")
![StatusLine visual mode preview](/images/visual.png?raw=true "StatusLine visual mode preview")
![StatusLine command mode preview](/images/command.png?raw=true "StatusLine command mode preview")
![StatusLine normal mode terminal preview](/images/normal-terminal.png?raw=true "StatusLine normal mode terminal preview")
![StatusLine insert mode terminal preview](/images/insert-terminal.png?raw=true "StatusLine insert mode terminal preview p")

<<<<<<< HEAD
![check it out!](lua/configuration/statusline.lua "link to anvil statusline code")
=======
>>>>>>> master

## Directory Structure:

Anvil has a very simple directory structure to make it easy to understand, navigate and extend.

```
.
├── compiler
│  └── python.vim
├── images
│  ├── anvil-completions.png
│  └── anvil.png
├── init.lua
├── LICENSE
├── lua
│  ├── configuration
│  │  ├── autocommands.lua
│  │  ├── init.lua
│  │  ├── keymaps.lua
│  │  ├── options.lua
│  │  └── statusline.lua
│  └── plugins
│     ├── cmp.lua
│     ├── dapui.lua
│     ├── diffview.lua
│     ├── gitsigns.lua
│     ├── init.lua
│     ├── lspconfig.lua
│     ├── luasnip.lua
│     ├── neogit.lua
│     ├── reply.lua
│     ├── telescope.lua
│     └── treesitter.lua
├── plugin
│  └── packer_compiled.lua
├── README.md
├── settings
├── snippets
│  ├── javascript.json
│  ├── javascriptreact.json
│  └── package.json
└── undodir
```
## Goals

To create a highly extensible neovim configuration that can easily be adapted as an IDE for any programming language via LSP while staying light and as close to vanilla neovim as possible. This distribution aims to be a non intrusive, solid base which the user can easily customize to fit their workflow needs.

## Contributing
Found a bug or something is broken?
Have a suggestion or feature you want added?
Please open an issue.

Want to contribute? Awesome! please make a pull request.
