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
    # PROCESSO 01
    # ------------------------------------------------------------------------------------------
    
    # Parâmetros obrigatórios:
    $parametros = @{

        queryTeradata = "SELECT top 5000000 DT_FOTO_LNHA,DOCUMENTO,DS_PRDT,CARTEIRA,DS_CDDE,ID_UF_LNHA,ID_PLNO,ID_ESTD_LNHA,cast(NR_TLFN as char(2)) AS DDD,
                        SUM(1) AS QTDE
                        FROM P_INTRPJ.FLAT_PJ_PRQE
                        GROUP BY 1,2,3,4,5,6,7,8,9
                        WHERE DT_FOTO_LNHA >= 2017-02-31";

        tabelaSqlServer = "STG_MOVEL_PARQUE_RECART_TEMP"

    }

    cd "C:\Users\A0066013\Documents\ANDRE\Codigos_Notepad_PlusPlus\PowerShell\Processo Teradata To Sql Server\"

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
    
    Add-Content $arquivolog "--------------------------------------------------------" 
    Add-Content $arquivolog "Hora do erro - $hora"
    Add-Content $arquivolog "Script erro - $arquivoScript"
    Add-Content $arquivolog “Exception Message: $($_.Exception.Message)”
    Add-Content $arquivolog "--------------------------------------------------------"   
    
    write-host “Exception Message: $($_.Exception.Message)” -ForegroundColor Red   

}
