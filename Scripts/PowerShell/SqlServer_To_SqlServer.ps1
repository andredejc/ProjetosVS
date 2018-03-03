
# Se a quantidade de registros for muito grande, encontrar um padrão de array para dividir os batchs:
$array = @('201703','201704','201705','201706')

$tabelaDestino = "[PARQUE_LNHA_PLANO_TEMP03]"

$serverDestino = "10.128.222.10" 
$baseDestino = "LIVRE" 
$userDestino = "Luiz.azevedo"
$passDestino = "luiz@34801"

$serverOrigem = "10.128.223.40" 
$baseOrigem = "DB" 
$userOrigem = "andre.cordeiro"
$passOrigem = "vivo@123"




Try{

    ForEach($data in $array) {

        $elapsed = [System.Diagnostics.StopWatch]::StartNew()

        Write-Host "Carregando data - $($data)"

        $stringConexaoDestino = "Password=$passDestino;Persist Security Info=True;User ID=$userDestino;Data Source=$serverDestino;Initial Catalog=$baseDestino;" 
        $stringConexaoOrigem = "Password=$passOrigem;Persist Security Info=True;User ID=$userOrigem;Data Source=$serverOrigem;Initial Catalog=$baseOrigem;" 

        $sqlConnectionOrigem = New-Object System.Data.SqlClient.SqlConnection
        $sqlConnectionOrigem.ConnectionString = $stringConexaoOrigem
        $sqlCommand = $sqlConnectionOrigem.CreateCommand()
        $sqlCommand.CommandText = " 
									SELECT
                                        CAST(DT_FOTO_LNHA AS INT) AS DT_FOTO_LNHA,
	                                    CAST(ID_LNHA AS INT) AS ID_LNHA,			
	                                    DS_PRDT,
	                                    CARTEIRA,
	                                    CAST(ID_PLNO AS INT) AS ID_PLNO
                                    FROM PARQUE_LNHA_PLANO_TEMP	                                	
                                    WHERE DT_FOTO_LNHA = '$($data)' -- Passar a var do array como filtro da query:
								" 

        $dataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlCommand
        $dataTable = New-Object System.Data.DataTable
        [Void]$dataAdapter.Fill($dataTable)

        $bulkCopy = New-Object System.Data.SqlClient.SqlBulkCopy($stringConexaoDestino, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
        $bulkCopy.DestinationTableName = $tabelaDestino
        $bulkCopy.BulkCopyTimeout = 0

        $bulkCopy.WriteToServer($dataTable)

        $dataTable.Clear()
        $dataTable.Dispose()
        $dataAdapter.Dispose()
        $sqlConnectionOrigem.Close()
        $sqlConnectionOrigem.Dispose()
        $sqlCommand.Dispose()
        $bulkCopy.Close()
        $bulkCopy.Dispose() 

        $elapsed.Stop()

        Write-Host "Dados transferidos em: $($elapsed.Elapsed.Hours.ToString())h $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 
        Write-Host "---------------------------------------"

    }
}
Catch{
    Throw “Exception Message: $($_.Exception.Message)”
    Throw “Exception Error Line: $($_.InvocationInfo.ScriptLineNumber)”    
    Break
}
Finally{
    $dataTable.Clear()
    $dataTable.Dispose()
    $dataAdapter.Dispose()
    $sqlConnectionOrigem.Close()
    $sqlConnectionOrigem.Dispose()
    $sqlCommand.Dispose()
    $bulkCopy.Close()
    $bulkCopy.Dispose()  

    [System.GC]::Collect()
}