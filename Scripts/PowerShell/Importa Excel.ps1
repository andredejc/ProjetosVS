Clear-Host

$elapsed = [System.Diagnostics.Stopwatch]::StartNew() 

# Array de mapeamento das colunas do Excel:
$arrayCel = @(
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U",
    "V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM",
    "AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"
    )

$arquivo = "C:\temp\Maio 17\Portin_Agend_Movel_Maio17_Concl.xlsb"
$sheet = "0320_TMEIRA_20170606102414"

$app = New-Object -ComObject Excel.Application
$app.Visible = $false

$workbook = $app.Workbooks.Open($arquivo)
$worksheet = $workbook.sheets.item($sheet)

$rows = ($worksheet.UsedRange.Rows).Count
$range = $worksheet.UsedRange
$rangeColunas = $range.Columns.Count

$batchSize = 1

$destinoSqlServer = "localhost" 
$baseSqlServer = "TESTES" 
$userSqlServer = "sa"
$passSqlServer = "P@ssw0rd"

$stringConexaoSqlServer = "Password=$passSqlServer;Persist Security Info=True;User ID=$userSqlServer;Data Source=$destinoSqlServer;Initial Catalog=$baseSqlServer;" 

$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($stringConexaoSqlServer, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
$bulkcopy.DestinationTableName = "TesteExcel" 
$bulkcopy.bulkcopyTimeout = 0 
$tabela = New-Object System.Data.DataTable

# Adiciona as colunas ao datable
For($i = 1; $i -le $rangeColunas; $i++){
    $coluna = $worksheet.Cells.Item(1,$i).Value()
    [void]$tabela.Columns.Add($coluna,[System.Type]::GetType("System.String"))    
}

$array = @()

For($i = 2; $i -le $rows; $i++){    

    $col = $arrayCel[$rangeColunas - 1]
    $linha = $worksheet.Range("A${i}:${col}${i}").Value()    
    $array += $linha
    $tabela.Rows.Add($array) | Out-Null 

    If($batchSize -eq 10000){
        $bulkcopy.WriteToServer($tabela)
        $tabela.Clear()
        $batchSize = 0
        Write-Host "Carregado 10000"
    }
       
    $array = @()
    $batchSize += 1
    
}

$bulkcopy.WriteToServer($tabela)
$tabela.Clear()
$elapsed.Stop()

Write-Host "Dados transferidos em: $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 

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





##############################################################
###		PROCESSO ANTIGO:
##############################################################
Clear-Host

$elapsed = [System.Diagnostics.Stopwatch]::StartNew() 

$arquivo = "C:\temp\Maio 17\Portin_Agend_Movel_Maio17_Concl.xlsb"
$sheet = "0320_TMEIRA_20170606102414"

$app = New-Object -ComObject Excel.Application
$app.Visible = $false

$workbook = $app.Workbooks.Open($arquivo)
$worksheet = $workbook.sheets.item($sheet)

$rows = ($worksheet.UsedRange.Rows).Count
$range = $worksheet.UsedRange
$rangeColunas = $range.Columns.Count

$batchSize = 1

$destinoSqlServer = "localhost" 
$baseSqlServer = "TESTES" 
$userSqlServer = "sa"
$passSqlServer = "P@ssw0rd"

$stringConexaoSqlServer = "Password=$passSqlServer;Persist Security Info=True;User ID=$userSqlServer;Data Source=$destinoSqlServer;Initial Catalog=$baseSqlServer;" 

$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($stringConexaoSqlServer, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
$bulkcopy.DestinationTableName = "TesteExcel" 
$bulkcopy.bulkcopyTimeout = 0 
$tabela = New-Object System.Data.DataTable

# Adiciona as colunas ao datable
for($i = 1; $i -le $rangeColunas; $i++){
    $coluna = $worksheet.Cells.Item(1,$i).Value()
    [void]$tabela.Columns.Add($coluna,[System.Type]::GetType("System.String"))    
}

$array = @()

for($i = 2; $i -le $rows; $i++){
    for($j = 1; $j -lt $rangeColunas + 1; $j++){        
        $array += $worksheet.Cells.Item($i,$j).Value()
    }       
    $tabela.Rows.Add($array) | Out-Null 
    
    if($batchSize -eq 5000){
        $bulkcopy.WriteToServer($tabela)
        $tabela.Clear()
        $batchSize = 0
        Write-Host "Carregado 5000"
    }
       
    $array = @()
    $batchSize += 1
}

$bulkcopy.WriteToServer($tabela)
#$table.Rows.Clear()
$tabela.Clear()

$elapsed.Stop()

Write-Host "Dados transferidos em: $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 


$workbook.Close()
$app.Quit()

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($range) | Out-Null

[System.GC]::Collect()
#[System.GC]::WaitForPendingFinalizers()


