$Credentials = Get-Credential
Connect-AzAccount -Credential $Credentials -Tenant 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -SubscriptionId 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
#
#Name                        Id                                   TenantId                             State  
#----                        --                                   --------                             -----  
#Microsoft subscrition name  yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Enabled
#


Connect-AzureRmAccount -SubscriptionId 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'


New-AzureRmResourceGroup -Name DataFilesSQLServer -Location "North Europe" -Tag @{Name="DataFilesSQLServer"; Purpose="UploadingMSSQLDataFiles"; Author="Tomaz Kastrun"}


New-AzureRmStorageAccount -ResourceGroupName 'DataFilesSQLServer' -AccountName storaccdatafilesmssql  -Location 'northeurope'  -SkuName Standard_LRS  -Kind BlobStorage  -AccessTier Cool -Tag @{Name="StorageaccountBlob"; Purpose="StoringDatabaseFiles"; Author="Tomaz Kastrun"}

#check the storage
Get-AzureRmStorageAccount

# Generating Account Container
$accountObject = Get-AzureRmStorageAccount -ResourceGroupName "DataFilesSQLServer" -AccountName "storaccdatafilesmssql"
New-AzureRmStorageContainer -StorageAccount $accountObject -ContainerName mymssqlfiles -PublicAccess Blob


# Getting context and retrieving SAS Token
$storageAccountName = 'storaccdatafilesmssql'
$accountKeys = Get-AzureRmStorageAccountKey -ResourceGroupName 'DataFilesSQLServer' -Name $storageAccountName
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $accountKeys[0].Value 

$now=get-date
New-AzureStorageContainerSASToken -Name mymssqlfiles -Context $storageContext -Permission rwdl -StartTime $now.AddHours(-1) -ExpiryTime $now.AddMonths(1)