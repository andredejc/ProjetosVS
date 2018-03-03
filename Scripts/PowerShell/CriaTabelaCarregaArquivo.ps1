#############################################################################
# Script que insere os dados de um arquivo em uma tabela
#############################################################################
#
# - O script cria a tabela com o nome passado na variável $nomeTable .
#
# - As colunas são criadas como VARCHAR(250).
#
# - Os tipos arquivos aceitos no são .txt, .csv, .dat, .xls, .xlsx, .xlsb.
#
# - Arquivos do tipo Excel estão limitados a 52 colunas, se a planilha tiver 
#   mais que isso, alterar o array de mapeamento.
#
#############################################################################

Clear-Host

# Alterar o caminho do arquivo:
$arquivo = "C:\temp\arqui\PIP_MOVEL_teste.xlsx"
$extensao = [System.IO.Path]::GetExtension($arquivo)

# Ignorar as variáveis $delimitador e $header se o arquivo for .xls, .xlsx, .xlsb e etc:
$delimitador = ';'
$header = "1" # Se o arquivo tiver header 1 se não 0:

# Alterar as variáveis de conexão com o SQL Server com os parâmetros do servidor onde a tabela será criada:
$destinoSqlServer = "localhost"
$baseSqlServer = "TESTES"
$userSqlServer = "sa"
$passSqlServer = "P@ssw0rd"
# Alterar o $nomeTable com o nome da tabela a ser criada:
$nomeTable = "PIP_TESTE"

# Ignorar a variável $indicePlanilha se o arquivo for do tipo texto.
# Corresponde qual sheet da planilha pergar sendo 1 a primeira, 2 a segunda e assim sucessivamente:
$indicePlanilha = 1


$stringCreateTable = "IF OBJECT_ID('$($nomeTable)') IS NOT NULL DROP TABLE $($nomeTable) CREATE TABLE "
$stringConexaoSqlServer = "Password=$passSqlServer;Persist Security Info=True;User ID=$userSqlServer;Data Source=$destinoSqlServer;Initial Catalog=$baseSqlServer;" 

$stringCreateTable += $nomeTable + "("

$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($stringConexaoSqlServer, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
$bulkcopy.DestinationTableName = $nomeTable
$bulkcopy.bulkcopyTimeout = 0 
$dataTable = New-Object System.Data.DataTable
$batchSize = 0
$totalCarregado = 0

Try {
    
    $elapsed = [System.Diagnostics.Stopwatch]::StartNew() 

    If($extensao -like ".xls*"){    
        # Array de mapeamento das colunas do Excel limitado a 52 colunas. Se          
        # a planilha tiver mais colunas adicionar no array seguindo o padrão:
        $arrayCel = @(
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
            "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
            "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", 
            "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ"
        )

        $app = New-Object -ComObject Excel.Application
        $app.Visible = $false
        $workbook = $app.Workbooks.Open($arquivo)
        $worksheet = $workbook.sheets.item($indicePlanilha)    

        $rows = ($worksheet.UsedRange.Rows).Count
        $range = $worksheet.UsedRange
        $rangeColunas = $range.Columns.Count
        $batchSize = 1

        # Adiciona as colunas ao datable
        For($i = 1; $i -le $rangeColunas; $i++){
            $coluna = $worksheet.Cells.Item(1,$i).Value()
            [void]$dataTable.Columns.Add($coluna,[System.Type]::GetType("System.String"))
            $stringCreateTable += "[" + $coluna + "]" + " VARCHAR(250),"   
        }

        $stringCreateTable = $stringCreateTable.Substring(0,$stringCreateTable.Length - 1) + ")"

        Write-Host "Criando a tabela $($nomeTable) ..."

        $conexaoSqlServer = New-Object System.Data.SQLClient.SQLConnection              
        $conexaoSqlServer.ConnectionString = $stringConexaoSqlServer 
        $conexaoSqlServer.Open()

        $Command = New-Object System.Data.SQLClient.SQLCommand     
        $Command.Connection = $conexaoSqlServer     
        $Command.CommandText = $stringCreateTable
        $Command.ExecuteNonQuery() | Out-Null
    
        If ($conexaoSqlServer.State -eq "Open") {         
            $conexaoSqlServer.Close() 
        }

        Write-Host "Tabela $($nomeTable) criada!"
        Write-Host "Inserindo os dados ..."

        $array = @()
        # Adiciona ao array a linha inteira ao invés de célula por célula:
        For($i = 2; $i -le $rows; $i++){    
            
            $col = $arrayCel[$rangeColunas - 1]
            # Aqui é levado em consideração que o início da linha é em A:
            $linha = $worksheet.Range("A${i}:${col}${i}").Value()    
            $array += $linha            
            $dataTable.Rows.Add($array) | Out-Null   
            $batchSize += 1          

            If($batchSize -eq 20000){
                $bulkcopy.WriteToServer($dataTable)
                $dataTable.Clear()
                $totalCarregado += $batchSize
                Write-Host "Carregado até o momento $($totalCarregado) ..."
                $batchSize = 0            
            }
       
            $array = @()          

        }

        $totalCarregado = $rows - 1

        $bulkcopy.WriteToServer($dataTable)
        $dataTable.Clear()

        Write-Host "Total de registros carregados $($totalCarregado) !"

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

    }
    ElseIf(($extensao -eq ".csv") -or ($extensao -eq ".txt") -or ($extensao -eq ".dat")){
        $count = 1
        $colunas = (Get-Content $arquivo -First 1).Split($delimitador)
        ForEach($coluna in $colunas){
            $dataTable.Columns.Add($coluna,[System.Type]::GetType("System.String")) | Out-Null

            If(($header -eq "") -or ($header -eq "1")){
                $stringCreateTable += "[" + $coluna + "]" + " VARCHAR(250),"                               
            }
            Else {
                # Se o arquivo não tiver header, cria a tabela com colunas genéricas:                
                $stringCreateTable += "[Coluna" + $count + "]" + " VARCHAR(250),"
                $count++
            }
        }       

        $stringCreateTable = $stringCreateTable.Substring(0,$stringCreateTable.Length - 1) + ")"        

        Write-Host "Criando a tabela $($nomeTable)..."

        $conexaoSqlServer = New-Object System.Data.SQLClient.SQLConnection              
        $conexaoSqlServer.ConnectionString = $stringConexaoSqlServer 
        $conexaoSqlServer.Open()

        $Command = New-Object System.Data.SQLClient.SQLCommand     
        $Command.Connection = $conexaoSqlServer     
        $Command.CommandText = $stringCreateTable
        $Command.ExecuteNonQuery() | Out-Null
    
        If ($conexaoSqlServer.State -eq "Open") {         
            $conexaoSqlServer.Close() 
        }

        Write-Host "Tabela $($nomeTable) criada!"
        Write-Host "Inserindo os dados..."

        $streamReader = New-Object System.IO.StreamReader($arquivo)

        If(($header -eq "") -or ($header -eq "1")){
            $null = $streamReader.ReadLine()
        }
    
        While(!($streamReader.EndOfStream)){        
            $linha = $streamReader.ReadLine().Split($delimitador) 
            $dataTable.Rows.Add($linha) | Out-Null
            $batchSize += 1

            If($batchSize -eq 5000){
                $bulkcopy.WriteToServer($dataTable)
                $dataTable.Clear()
                $totalCarregado += $batchSize
                Write-Host "Carregado até o momento $($totalCarregado) ..."
                $batchSize = 0
            }
        }

        $totalCarregado += $batchSize

        $bulkcopy.WriteToServer($dataTable)
        $dataTable.Clear()
        $batchSize = 0
       
        $streamReader = $null  

        Write-Host "Total de registros carregados $($totalCarregado) !"

    }
    Else{
        Throw "Extensão do arquivo inválida! Verifique o arquivo!"
    }

    Write-Host ""
    $elapsed.Stop()
    Write-Host "Dados transferidos em: $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 

}
Catch {
    
    Throw “Exception Error Line: $($_.InvocationInfo.ScriptLineNumber)”
    Throw “Exception Message: $($_.Exception.Message)”

}
Finally {

    If ($conexaoSqlServer.State -eq "Open") {         
        $conexaoSqlServer.Close() 
    }

    $bulkcopy.Close(); 
    $bulkcopy.Dispose() 
    $dataTable.Dispose()

    $bulkcopy = $null
    $dataTable = $null

    [System.GC]::Collect()
}
