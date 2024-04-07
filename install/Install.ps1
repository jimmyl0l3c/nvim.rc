$ruff_cfg_dir = "~\AppData\Roaming\ruff"
$pylsp_venv_path = "~\AppData\Local\nvim-data\mason\packages\python-lsp-server\venv"

Function exitOnErr {
    If ($LASTEXITCODE -ne 0) {
        Write-Error "Install failed, exiting"
        Exit $LASTEXITCODE
    }
    Else
    {
        Write-Output "Ok"
    }
}

If(!(Test-Path -PathType Container $ruff_cfg_dir))
{
    Write-Output "Creating ruff cfg dir"
    New-Item -Path $ruff_cfg_dir -ItemType "directory"
    exitOnErr
}
Else
{
    Write-Output "Ruff cfg dir already exists"
}

Write-Output "Copying default ruff.toml"
Copy-Item ruff.toml $ruff_cfg_dir
exitOnErr

Write-Output "Installing additional packages to pylsp venv"
& "$pylsp_venv_path\Scripts\pip.exe" install -r pylsp-requirements.txt
exitOnErr

