
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true, Position=1)][String] $arquivo,
    [Parameter(Mandatory=$true, Position=2)][String] $destinoSqlServer,
    [Parameter(Mandatory=$true, Position=3)][String] $baseSqlServer,
    [Parameter(Mandatory=$true, Position=4)][String] $userSqlServer,
    [Parameter(Mandatory=$true, Position=5)][String] $passSqlServer,
    [Parameter(Mandatory=$true, Position=6)][String] $tabelaBase
)

$elapsed = [System.Diagnostics.Stopwatch]::StartNew() 

# Array de mapeamento das colunas do Excel:
$arrayCel = @(
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"
)
Try {

    $stringConexaoSqlServer = "Password=$passSqlServer;Persist Security Info=True;User ID=$userSqlServer;Data Source=$destinoSqlServer;Initial Catalog=$baseSqlServer;" 
    # Valida e trunca a tabela antes da carga:
    If($tabelaBase -notlike "*_AGEND_*") {
        Throw "Tabela especifica inválida! Verifique a tabela e o nome do arquivo!"
    }
    Else {        
        Write-Host "Truncando a tabela..."
        $conexaoSqlServer = New-Object System.Data.SQLClient.SQLConnection              
        $conexaoSqlServer.ConnectionString = $stringConexaoSqlServer 
        $conexaoSqlServer.Open()

        $Command = New-Object System.Data.SQLClient.SQLCommand     
        $Command.Connection = $conexaoSqlServer     
        $Command.CommandText = "TRUNCATE TABLE $tabelaBase;"
        $Command.ExecuteNonQuery() | Out-Null
    
        If ($conexaoSqlServer.State -eq "Open") {         
            $conexaoSqlServer.Close() 
        }
        Write-Host "Tabela truncada!"
    }         
    
    Write-Host "Carregando a tabela - $($tabelaBase)"       

    $app = New-Object -ComObject Excel.Application
    $app.Visible = $false
    $app.DisplayAlerts = $false
    $workbook = $app.Workbooks.Open($arquivo)
    $worksheet = $workbook.sheets.item(1)    

    $rows = ($worksheet.UsedRange.Rows).Count
    $range = $worksheet.UsedRange
    $rangeColunas = $range.Columns.Count
    $batchSize = 1
    
    $bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($stringConexaoSqlServer, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
    $bulkcopy.DestinationTableName = $tabelaBase
    $bulkcopy.bulkcopyTimeout = 0 
    $dataTable = New-Object System.Data.DataTable

    # Adiciona as colunas ao datable
    For($i = 1; $i -le $rangeColunas; $i++){
        $coluna = $worksheet.Cells.Item(1,$i).Value()
        [void]$dataTable.Columns.Add($coluna,[System.Type]::GetType("System.String"))           
    }    

    $array = @()
    # Adiciona ao array a linha inteira ao invés de célula por célula:
    For($i = 2; $i -le $rows; $i++){    

        $col = $arrayCel[$rangeColunas - 1]
        # Aqui é levado em consideração que o início da linha é em A:
        $linha = $worksheet.Range("A${i}:${col}${i}").Value()    
        $array += $linha
        $dataTable.Rows.Add($array) | Out-Null      

        If($batchSize -eq 20000){
            $bulkcopy.WriteToServer($dataTable)
            $dataTable.Clear()
            Write-Host "Carregados $($batchSize) ..."
            $batchSize = 0            
        }
       
        $array = @()
        $batchSize += 1
    
    }    

    $bulkcopy.WriteToServer($dataTable)
    $dataTable.Clear()
    Write-Host "Carregados $($batchSize)!"
    $elapsed.Stop()

    Write-Host "Dados transferidos em: $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 
    Write-Host ""
    
}
Catch {

    Throw “Exception Message: $($_.Exception.Message)”
    Throw “Exception Error Line: $($_.InvocationInfo.ScriptLineNumber)”    

}
Finally {
    
    if ($conexaoSqlServer.State -eq "Open") {         
        $conexaoSqlServer.Close() 
    }

    $bulkcopy.Close(); 
    $bulkcopy.Dispose() 
    $dataTable.Dispose()

    $workbook.Close()
    $app.Quit()
    $workbook = $null
    $worksheet = $null
    $app = $null
    $rows = $null
    $range = $null
    $rangeColunas = $null
    $linha = $null
    $array = $null

    [System.GC]::Collect()

}
