# Install Chocolatey Packager
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Silent Install Software Tools
# Install System Tools
# Install Microsoft Edge
choco install microsoft-edge -confirm:$false
# Install .NET Core SDK
choco install dotnetcore-sdk -confirm:$false
# Install PowerShell Core 7
choco install powershell-core -confirm:$false
# Install SQL Server Management Studio
choco install sql-server-management-studio -confirm:$false


# Install Azure Tools
# Install Azure CLI
choco install azure-cli -confirm:$false
# Install Azure PowerShell
choco install azurepowershell -confirm:$false
# Install Google Chrome
choco install googlechrome -confirm:$false
