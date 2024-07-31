# kinaconda

A plugin to (de)activate conda environments inside neovim. I use miniconda so I created it. It now requires coc.nvim as the lsp manager.

## Requirements

- anaconda/miniconda
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [coc.nvim](https://github.com/neoclide/coc.nvim)

## Installation

Using lazy.nvim:

```lua
{
    "KinnariyaMamaTanha/kinaconda",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "neoclide/coc.nvim"
    },
    ft = "python",
    opts = {
        -- conda_path = "~/miniconda3"
        -- default "~/miniconda3" or "~/anaconda3"
    }
}
```

## Commands

- `:CondaActivate [env_name]`: when receiving an environment name, try to activate it; otherwise list all available environments using telescope.
- `:CondaDeactivate`: try to deactivate current environment.
