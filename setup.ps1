$ErrorActionPreference = "Stop"

Write-Host "starting setup for windows"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "installing scoop" -ForegroundColor Green

    # install scoop, taken from the official website `https://scoop.sh`
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "scoop is already installed" -ForegroundColor Green
}

# setup the extra repository
scoop bucket add extras

Write-Host "scoop installed and repositories setup successfully" -ForegroundColor Green

Write-Host "installing scoop software" -ForegroundColor Green

# install software
scoop install main/make
scoop install extras/gcc-arm-none-eabi
scoop install main/openocd

Write-Host "scoop software installed succesfully" -ForegroundColor Green

Write-Host "installing compiledb" -ForegroundColor Green

# compiledb is not on scoop, so we install it using pythons pip manager
$PYTHON = Get-Command python -ErrorAction SilentlyContinue

if ($PYTHON) {
    Write-Host "found the systems python executable: $($PYTHON.Source), using that" -ForegroundColor Green
} else {
    Write-Host "python not found, installing it using scoop" -ForegroundColor Yellow
    scoop install main/python
    
    # refresh the path for this process so the python is available
    $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")
}

Write-Host "installing compiledb using pip" -ForegroundColor Green

python -m pip install compiledb

Write-Host "compiledb installed successfully" -ForegroundColor Green

Write-Host "checking if available in path" -ForegroundColor Yellow

# refresh the path again
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")

$COMPILEDB = Get-Command compiledb -ErrorAction SilentlyContinue
if ($COMPILEDB) {
    Write-Host "compiledb found at $($COMPILEDB.Source)" -ForegroundColor Green
} else {
    # try to find the user installation directory and add that directory to path
    Write-Host "compiledb not found, expanding search onto user packages" -ForegroundColor Yellow

    $PYTHON_PATH = python -m site --user-base
    $SCRIPTS_PATH = Join-Path $PYTHON_PATH "Scripts"
    if (-not (Test-Path $SCRIPTS_PATH)) {
        Write-Host "path $SCRIPTS_PATH does not exist" -ForegroundColor Red
        exit 1
    }

    $CURRENT_PATH = [Environment]::GetEnvironmentVariable("Path", "User")

    $NEW_PATH = "$CURRENT_PATH;$SCRIPTS_PATH"
    [Environment]::SetEnvironmentVariable("Path", $NEW_PATH, "User")
    
    $env:PATH = "$env:PATH;$SCRIPTS_PATH"
}

# try now, it should find it
$COMPILEDB = Get-Command compiledb -ErrorAction SilentlyContinue
if($COMPILEDB) {
    Write-Host "compiledb installed succesfully and available in path" -ForegroundColor Green
} else {
    Write-Host "something went wrong while installing compiledb" -ForegroundColor Red
    exit 1
}

Write-Host "setup complete" -ForegroundColor Green
