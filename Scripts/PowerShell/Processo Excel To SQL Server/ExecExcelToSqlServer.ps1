Clear-Host

# Alterar as variáveis de conexão do SQL Server:
$destinoSqlServer = "localhost";
$baseSqlServer = "TESTES";
$userSqlServer = "sa";
$passSqlServer = "P@ssw0rd";

# Alterar o caminho onde está o arquivo .zip:
$dirDownload = "C:\temp\"
$arquivoScript = "ExcelToSqlServer.ps1"
$dirProcesso = "C:\temp\ArquivosProcessar\"
# Alterar o nome do arquivo .zip:
$arquivoZipNome = "Abril 17.zip"
# Alterar a data para o ano e mês do arquivo:
$dataArquivo = "201704"
$arquivoZip = $dirDownload + $arquivoZipNome
# Alterar o caminho donde estão os scripts:
$dirScript = "C:\Users\A0066013\Documents\ANDRE\Codigos\PowerShell\Processo Excel To SQL Server\"
$procedure = "dbo.sp_InserePortabilidade '$($dataArquivo)'"

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

Write-Host "-------------------------------------------------------"
Write-Host "Inicio do Processo:"
Write-Host "-------------------------------------------------------"

Try {

    # Cria se não existir o diretório do processo:
    If (!(Test-Path $dirProcesso -PathType Container) ) {
            New-Item -ItemType Directory -Force -Path $dirProcesso | Out-Null
    }
    
    # Copia o arquivo .zip para o diretório do processo:
    Copy-Item $arquivoZip $dirProcesso

    # Extrai os arquivos do .zip:
    ForEach($arquivo in Get-ChildItem $dirProcesso -Filter "*.zip"){    

        $arquivoZip = $dirProcesso + $arquivo

        Expand-Archive -LiteralPath $arquivoZip -DestinationPath $dirProcesso -Force
    }

    # Carrega na tabela correspondente um arquivo de cada vez:
    ForEach($arquivo in Get-ChildItem $dirProcesso -Filter "*.xls*"){    

        $arquivoXls = $dirProcesso + $arquivo
        # Pega o nome da tabela no nome do arquivo:
        $tabela = ($arquivo.ToString().ToUpper().Split("_",5) | Select -Index 0,1,2) -join "_"            

        $parametros = @{
            arquivo = $arquivoXls;            
            destinoSqlServer = $destinoSqlServer;
            baseSqlServer = $baseSqlServer;
            userSqlServer = $userSqlServer;
            passSqlServer = $passSqlServer;
            tabelaBase = $tabela
        }

        # Alterar o caminho dos scripts para o diretório correto:
        cd $dirScript

        # Executa o Script de transferência:
        .\ExcelToSqlServer.ps1 @parametros                

    }    

    Write-Host "Executando procedure que insere na tabela final..."
    Invoke-Sqlcmd -ServerInstance $destinoSqlServer -Database $baseSqlServer -Query $procedure -Username $userSqlServer -Password $passSqlServer -QueryTimeout 0
    Write-Host "Procedure finalizada!"

    $elapsed.Stop()

    Write-Host "Todas as tabelas carregadas em: $($elapsed.Elapsed.Minutes.ToString())m e $($elapsed.Elapsed.Seconds.ToString())s" 

}
Catch {

    Throw “Exception Message: $($_.Exception.Message)”
    Throw “Exception Error Line: $($_.InvocationInfo.ScriptLineNumber)”
    Break
}
Finally {

    If ((Test-Path $dirProcesso -PathType Container)){
            Remove-Item -Force -Recurse -Path $dirProcesso
    }

}

