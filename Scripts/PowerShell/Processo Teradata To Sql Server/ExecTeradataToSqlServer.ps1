# ------------------
# Script de execução 
# ------------------

Clear-Host

$arquivoScript = "ExecTeradataToSqlServer.ps1"

# Valida se o diretório dos arquivos de log existe, se não, cria:
$diretoriolog = "C:\temp\LogProcessoTeradataSqlServer\"

if (!(Test-Path $diretoriolog -PathType Container) ) {
    New-Item -ItemType Directory -Force -Path $diretoriolog
}

try {    

    # ------------------------------------------------------------------------------------------
    # PROCESSO 01 - MOVIMENTACOES MOVEL (NEW - PEGANDO O id_mtvo_mvmt_lnha) (STG_MOVEL_ALTA_BAIXA)
    # ------------------------------------------------------------------------------------------    
    # Parâmetros:
    $parametros = @{

        # Parâmetro obrigatório:
        queryTeradata = "                        
                           SELECT *	                            
                            FROM Tabela
                        ";
        
        # Parâmetro obrigatório:
        tabelaSqlServer = "dbo.TabelaDestino";

        # Parâmetro não obrigatório. Caso a linha seja comentada, o processo apenas realiza o import dos dados para a tabela temp:
        # procedureMerge = "DECLARE @rowCount INT; EXECUTE dbo.sp_Merge_STG_MOVEL_ALTA_BAIXA_teste @rowCount OUTPUT SELECT @rowCount AS linhasAfetadas";

    }

    Write-Host "Processo 01"    

    # Alterar o caminho dos scripts para o diretório correto:
    cd "C:\Users\A0066013\Documents\ANDRE\Codigos\PowerShell\Processo Teradata To Sql Server\"

    # Executa o Script de transferência:
    .\TeradataToSqlServer.ps1 @parametros
    # ------------------------------------------------------------------------------------------
    
}
catch {

    $data = Get-Date -Format _yyyyMMdd
    $hora = Get-Date -Format HH:mm:ss        
    $arquivolog = "$($diretoriolog)logError$($data).txt"    
    
    Add-Content $arquivolog ""      

    $result = Select-String -Path $arquivolog -Pattern "Log de ERRO"

    if($result -eq $null) {
        Add-Content $arquivolog "#####################################################################################"
        Add-Content $arquivolog " Log de ERRO no processo transferência de dados entre o Teradata e o SQL Server"
        Add-Content $arquivolog "#####################################################################################"
        Add-Content $arquivolog ""
    }
    
    Add-Content $arquivolog "-----------------------------------------------------------------------------------------" 
    Add-Content $arquivolog "Hora do erro - $hora"
    Add-Content $arquivolog "Script erro - $arquivoScript"
    Add-Content $arquivolog “Exception Message: $($_.Exception.Message)”
    Add-Content $arquivolog "-----------------------------------------------------------------------------------------" 
    
    write-host “Exception Message: $($_.Exception.Message)” -ForegroundColor Red   

}
