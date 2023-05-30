This contains the bicep file to deploy the resources configured in the lab

To deploy this template: 

```
$date = Get-Date -Format "MM-dd-yyyy"
$rand = Get-Random -Maximum 1000
$deploymentName = "AzInsiderDeployment-"+"$date"+"-"+"$rand"
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName AZ500LAB131415 -TemplateFile .\main.bicep -TemplateParameterFile .\azuredeploy.parameters.json -c
```
