# --------------------------------------------------------------
# Script de transferência de dados do Teradata para o Sql Server:
# --------------------------------------------------------------
#  
#  - Passar a query do Teradata para a variável $queryTeradata.
#  - Alterar a variável $tabelaSqlServer com a tabela correta.
#  - Se necessário, alterar também as variáveis de conexão.
#
#
#  ****** ATENÇÃO ********************************************
#    O processo está configurado para truncar a tabela passada
#    na variável $tabelaSqlServer pois o objetivo é que exista
#    uma tabela intermediária onde os dados são transferidos e
#    a partir dela realizar a atualização da tabela final. Se 
#    o nome da tabela passada na variável não tiver 'temp' no
#    nome um erro será retornado. Isso foi feito para garantir
#    que não seja truncada uma tabela errada no processo. 
#  ***********************************************************
#
# --------------------------------------------------------------

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$queryTeradata,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$tabelaSqlServer
)

if ($tabelaSqlServer -notlike "*temp*") {   
    Write-Error -Message 'A tabela não é temp! Verifique a tabela passada na variável $tabelaSqlServer' -ErrorAction Stop
}

[void][Reflection.Assembly]::LoadWithPartialName("System.Data") 
[void][Reflection.Assembly]::LoadWithPartialName("System.Data.SqlClient") 

$arquivoScript = "TeradataToSqlServer.ps1"

# Variáveis Teradata:
$origemTeradata = "10.238.0.63"
$userTeradata = "A0049414"
$passTeradata = "Luiz@123"

# Variáveis Sql Server:
$destinoSqlServer = "10.128.223.40" 
$baseSqlServer = "DB" 
$userSqlServer = "andre.cordeiro"
$passSqlServer = "vivo@123"

$stringConexaoSqlServer = "Password=$passSqlServer;Persist Security Info=True;User ID=$userSqlServer;Data Source=$destinoSqlServer;Initial Catalog=$baseSqlServer;" 

# --------------------------------------------------------------------------------------
# Trunca a tabela temp passada na variável tabelaSqlServer para inserção dos novos dados
# --------------------------------------------------------------------------------------
Write-Host "Truncando a tabela temp..." 

$trucateTable = "TRUNCATE TABLE $tabelaSqlServer;"

try {
    
    # Trunca a tabela passada na variável $tabelaSqlServer:
    $conexaoSqlServer = New-Object System.Data.SQLClient.SQLConnection              
    $conexaoSqlServer.ConnectionString = $stringConexaoSqlServer 
    $conexaoSqlServer.Open()

    $Command = New-Object System.Data.SQLClient.SQLCommand     
    $Command.Connection = $conexaoSqlServer     
    $Command.CommandText = $trucateTable
    $Command.ExecuteNonQuery()

    # --------------------------------------------------------------------------------------
    # Inicia a transferência dos dados para a tabela temp:
    # --------------------------------------------------------------------------------------

    if ($conexaoSqlServer.State -eq "Open") {         
        $conexaoSqlServer.Close() 
    } 

    Write-Host "Transferência de dados iniciada..." 

    $elapsed = [System.Diagnostics.Stopwatch]::StartNew() 

    $bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($stringConexaoSqlServer, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
    $bulkcopy.DestinationTableName = $tabelaSqlServer 
    $bulkcopy.bulkcopyTimeout = 0 

    $datatable = New-Object System.Data.DataTable 

    # Cria a conexão com o Teradata: 
    $factory = [System.Data.Common.DbProviderFactories]::GetFactory("Teradata.Client.Provider")
 
    $connectionTeradata = $factory.CreateConnection() 
 
    $connectionTeradata.ConnectionString = "Data Source = $origemTeradata ;User ID = $userTeradata; Password = $passTeradata" 
    $connectionTeradata.Open()
 
    $command = $connectionTeradata.CreateCommand()
    $command.CommandText = $queryTeradata    
 
    $adapter = $factory.CreateDataAdapter()
    $adapter.SelectCommand = $command
    $adapter.SelectCommand.CommandTimeout = 300
 
    $dataset = new-object System.Data.DataSet

    # Preenche o datatable:
    [void] $adapter.Fill($datatable)

    # Insere no SQL Server:
    $bulkcopy.WriteToServer($datatable)
    $datatable.Clear()     

    Write-Host "Transferência de dados finalizada!"
    Write-Host "Dados transferidos em: $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 

}
catch {    
     
    $data = Get-Date -Format _yyyyMMdd
    $hora = Get-Date -Format HH:mm:ss    
    $diretoriolog = "C:\temp\LogProcessoTeradataSqlServer\"
    $arquivolog = "$($diretoriolog)logError$($data).txt"  

    Add-Content $arquivolog ""
    
    write-host “Exception Message: $($_.Exception.Message)” -ForegroundColor Red    

    $result = Select-String -Path $arquivolog -Pattern "Log de ERRO"

    if($result -eq $null) {
        Add-Content $arquivolog "#####################################################################################"
        Add-Content $arquivolog " Log de ERRO no processo transferência de dados entre o Teradata e o SQL Server"
        Add-Content $arquivolog "#####################################################################################"
        Add-Content $arquivolog ""
    }
    
    Add-Content $arquivolog "--------------------------------------------------------" 
    Add-Content $arquivolog "Hora do erro - $hora"
    Add-Content $arquivolog "Script erro - $arquivoScript"
    Add-Content $arquivolog “Exception Message: $($_.Exception.Message)”
    Add-Content $arquivolog "--------------------------------------------------------"   

    Break

}
finally {

    $data = Get-Date -Format _yyyyMMdd
    $hora = Get-Date -Format HH:mm:ss    
    $diretoriolog = "C:\temp\LogProcessoTeradataSqlServer\"
    $arquivolog = "$($diretoriolog)logProcesso$($data).txt"   
    
    Add-Content $arquivolog "" 
    
    $result = Select-String -Path $arquivolog -Pattern "Log do processo"

    if($result -eq $null) {          
        Add-Content $arquivolog "#####################################################################################"
        Add-Content $arquivolog " Log do processo de transferência de dados entre o Teradata e o SQL Server"
        Add-Content $arquivolog "#####################################################################################"
        Add-Content $arquivolog ""
    }

    Add-Content $arquivolog "--------------------------------------------------------" 
    Add-Content $arquivolog "Hora de execução - $hora"
    Add-Content $arquivolog "Tabela carregada - $tabelaSqlServer"
    Add-Content $arquivolog “Tempo de carga - $($elapsed.Elapsed.Hours.ToString()):$($elapsed.Elapsed.Minutes.ToString()):$($elapsed.Elapsed.Seconds.ToString())”
    Add-Content $arquivolog "--------------------------------------------------------" 

    if ($conexaoSqlServer.State -eq "Open") {
        $conexaoSqlServer.Close() 
    } 

    $connectionTeradata.Close()
    $bulkcopy.Close(); 
    $bulkcopy.Dispose() 
    $datatable.Dispose()     
    
    [System.GC]::Collect()

}

