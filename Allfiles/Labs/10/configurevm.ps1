$installer = "C:\SSMS-Setup-ENU.exe"

Invoke-WebRequest -URI "https://aka.ms/ssmsfullsetup" -OutFile $installer -UseBasicParsing

Start-Process -FilePath $installer -ArgumentList "/Install /Quiet" -Wait
