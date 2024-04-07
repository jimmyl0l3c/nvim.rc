# nvim.rc

Nvim.rc based on ThePrimeagen's nvim.rc.


## Manual setup

### Python LS

To fully setup python LS, install the [pylsp-requirements.txt](./install/pylsp-requirements.txt)
in the pylsp venv (by default `nvim-data/mason/packages/python-lsp-server/venv`)

#### Ruff default config

Put default ruff.toml to the following location:

- Windows: `~/AppData/Roaming/ruff/ruff.toml`
- Linux: `~/.config/ruff/ruff.toml`

## Automatic setup

On windows cd to [./install](./install) directory and
execute [Install.ps1](./install/Install.ps1).

**TODO:** add script to install on linux

