####################################################################
# Script de exportação de arquivo delimitado
####################################################################
#
#  - Arquivo do tipo largura fixa não é gerado o header
#  - Se o arquivo for largura fixa deixar o $delimitador em branco
#
#

PROCESS {   

    Clear-Host    

    Try {

        # *** Faça as alterações, se necessárias, aqui *********************
        $delimitador = ""
        $diretorio = "C:\temp\"
        $arquivo = "arquivoTeste"
        $tipoArquivo = ".txt"        
        $query = "SELECT * FROM [dbo].[TEMP_FLAT_PJ_MVMT]"
        $destinoSqlServer = "localhost" 
        $baseSqlServer = "TESTES" 
        $userSqlServer = "sa"
        $passSqlServer = "P@ssw0rd"
        # *** Fim das alterações *******************************************

        # Inicia a contagem do tempo do processo:
        $stopWatch =[Diagnostics.StopWatch]::StartNew()                                

        $data = Get-Date -Format _yyyyMMdd

        # String de conexão com a base de dados do SQL Server:
        $stringConexaoSqlServer = "Password=$passSqlServer;Persist Security Info=True;User ID=$userSqlServer;Data Source=$destinoSqlServer;Initial Catalog=$baseSqlServer;"             

        # Monta o path do arquivo:             
        $arquivo = "$($diretorio)$($arquivo)$($data)$($tipoArquivo)"        

        # Se o arquivo for largura fixa, retorna os dados através do script SQL na variável $queryLarguraFixa:
        if(($delimitador) -eq ""){    

            # Script de extração de arquivo tipo largura fixa que utiliza a variável $query para definar o output dos dados:
            $queryLarguraFixa = "USE BANCO
            BEGIN
                DECLARE @sql NVARCHAR(MAX)
	            IF OBJECT_ID('tempdb..##tempdados','U') IS NOT NULL DROP TABLE ##tempdados
	            IF OBJECT_ID('tempdb..##largurafixa','U') IS NOT NULL DROP TABLE ##largurafixa	
	            SET @sql = STUFF(@sql,PATINDEX('%FROM%',@sql),0,' INTO ##tempdados ')		
	            EXECUTE ( @sql )
	            SET @sql = 'SELECT '
	            SELECT @sql +=
		            'ISNULL(CAST(' + A.name + ' AS VARCHAR('+ CASE WHEN B.name NOT LIKE '%CHAR%' THEN CAST(A.precision AS VARCHAR(4)) + ')),''NULL'') + ' ELSE  CAST(A.max_length AS VARCHAR(4))+')),''NULL'') + ' END +
		            'REPLICATE('' '', ' + CASE WHEN B.name NOT LIKE '%CHAR%' THEN CAST(A.precision AS VARCHAR(4)) ELSE CAST(A.max_length AS VARCHAR(4)) +' ' END + 
		            '-LEN(ISNULL(CAST(' + A.name + ' AS VARCHAR('+ CASE WHEN B.name NOT LIKE '%CHAR%' THEN CAST(A.precision AS VARCHAR(4)) + ')),''NULL''))) AS ' + A.name + ', ' ELSE CAST(A.max_length AS VARCHAR(4))+')),''NULL''))) AS ' + A.name + ', ' END + CHAR(13)
	            FROM tempdb.sys.columns AS A
		            INNER JOIN tempdb.sys.types AS B
			            ON A.system_type_id = B.system_type_id
	            WHERE object_id = OBJECT_ID(N'tempdb..##tempdados');
	            SET @sql = REVERSE(SUBSTRING(REVERSE(@sql),4,40000)) + ' INTO ##largurafixa FROM ##tempdados'	
	            EXECUTE ( @sql )	
	            IF OBJECT_ID('tempdb..##tempdados','U') IS NOT NULL DROP TABLE ##tempdados
                SELECT * FROM ##LARGURAFIXA
            END" 

            # Adiciona a base correta no Script SQL:
            $queryLarguraFixa = $queryLarguraFixa.Replace("USE BANCO", "USE $($baseSqlServer)")

            # Insere a query passada na variável $query no Script SQL:
            $queryLarguraFixa = $queryLarguraFixa.Replace("DECLARE @sql NVARCHAR(MAX) =","DECLARE @sql NVARCHAR(MAX) = '$($query)'")                                    
                    
            Write-Output "Gerando arquivo largura fixa..."     
            Invoke-Sqlcmd -ServerInstance $destinoSqlServer -Database $baseSqlServer -Query $queryLarguraFixa | Export-Csv -Path $arquivo -Encoding UTF8 -NoTypeInformation
            ( Get-Content $arquivo ) | Select -Skip 1 | % { $_ -replace '"', '' -replace ',', '' } | Out-File -FilePath $arquivo       
              
        }   
        # Se o arquivo for delimitado:
        else {
            
            if(($delimitador) -eq ",") {
                Write-Output "Gerando arquivo delimitado por ',' ..."  
                Invoke-Sqlcmd -ServerInstance $destinoSqlServer -Database $baseSqlServer -Query $query | Export-Csv -Path $arquivo -Encoding UTF8 -NoTypeInformation
                ( Get-Content $arquivo ) | % { $_ -replace '"', '' } | Out-File -FilePath $arquivo             
            }
            else {
                Write-Output "Gerando arquivo delimitado por '$($delimitador)' ..."  
                Invoke-Sqlcmd -ServerInstance $destinoSqlServer -Database $baseSqlServer -Query $query | Export-Csv -Delimiter $delimitador -Path $arquivo -Encoding UTF8 -NoTypeInformation
                ( Get-Content $arquivo ) | % { $_ -replace '"', '' } | Out-File -FilePath $arquivo     
            }        
        }               

        $stopWatch.Stop()

        Write-Output "Fim do processo!"
        Write-Output "Arquivo gerado em: $($stopWatch.Elapsed.Hours):$($stopWatch.Elapsed.Minutes):$($stopWatch.Elapsed.Seconds)"        

    }
    Catch {
        
        Write-Output “Exception Message: $($_.Exception.Message)” -ForegroundColor Red
        Break
        
    }
    Finally {        

        [System.GC]::Collect()
        
    }

}
