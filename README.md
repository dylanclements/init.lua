# My neovim config
---
Allows for easily porting over my neovim config to new machines. Currently only tested on MacOS but may only need small adaptions for other machines.

# Installation (macOS only)
NOTE: change this, its old
---
1. `brew install neovim`
2. `cd ~/.config` (or `$XDG_CONFIG_HOME` broadly speaking)
3. Follow instructions to install packer `https://github.com/wbthomason/packer.nvim`
4. Enter neovim, navigate to packer.lua or `nvim ~/.config/nvim/lua/dylanclements/packer.lua`
5. Source the file `:so`
6. Run packer sync `:PackerSync`
