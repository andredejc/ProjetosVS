-- ---------------------------------------------------------------------
-- Monta corpo de email com tabela
-- ---------------------------------------------------------------------

-- //Lembrando que o script que vai disparar o email tem de estar com o parâmetro body em HTML
--
--          #####################################################################
--          ###########    script de disparo em C#		#########################
--          #####################################################################
--
--          // Modelo de disparo de email c#
--          
--          Outlook.Application oApp = new Outlook.Application();
--          // Create a new mail item.
--          Outlook.MailItem oMsg = (Outlook.MailItem)oApp.CreateItem(Outlook.OlItemType.olMailItem);
--          // Set HTMLBody. 
--          //add the body of the email
--          string email = "andre.cordeiro@5800bseguros.com.br";
--          oMsg.HTMLBody = Dts.Variables["User::msg"].Value.ToString();
--          //Add an attachment.
--          String sDisplayName = "Anexo";
--          int iPosition = (int)oMsg.Body.Length + 1;
--          int iAttachType = (int)Outlook.OlAttachmentType.olByValue;
--          //now attached the file
--          Outlook.Attachment oAttach = oMsg.Attachments.Add(@"E:\Andre\teste_18022016.txt", iAttachType, iPosition, sDisplayName);
--          
--          //Subject line
--          oMsg.Subject = "Arquivo anexo";
--          // Add a recipient.
--          Outlook.Recipients oRecips = (Outlook.Recipients)oMsg.Recipients;
--          // Change the recipient in the next line if necessary.
--          Outlook.Recipient oRecip = (Outlook.Recipient)oRecips.Add(email);
--          oRecip.Resolve();
--          // Send.
--          oMsg.Send();
--          // Clean up.
--          oRecip = null;
--          oRecips = null;
--          oMsg = null;
--          oApp = null;

-- 			  #####################################################################
--						SEGUNDA OPÇÃO			
--            #####################################################################

--			  Outlook.Application oApp = new Outlook.Application();
--            Outlook.MailItem oMsg = (Outlook.MailItem)oApp.CreateItem(Outlook.OlItemType.olMailItem);
--            string emailto = "andre.cordeiro@5800bseguros.com.br";
--            string emailcc = "alexandre.romacho@bradescoseguros.com.br";
--            oMsg.HTMLBody = Dts.Variables["User::msg"].Value.ToString();

--            oMsg.Subject = "Protocolo processo Anti Attrition";
--            // Add a recipient.
--            Outlook.Recipients oRecips = (Outlook.Recipients)oMsg.Recipients;
--            // Change the recipient in the next line if necessary.
--            Outlook.Recipient recipTo = (Outlook.Recipient)oRecips.Add(emailto);
--            recipTo.Type = (int)Outlook.OlMailRecipientType.olTo;
--            Outlook.Recipient recipCc = (Outlook.Recipient)oRecips.Add(emailcc);
--            recipCc.Type = (int)Outlook.OlMailRecipientType.olCC;

--            oMsg.Recipients.ResolveAll();

--            oMsg.Send();

--            recipTo = null;
--            oRecips = null;
--            recipCc = null;
--            oMsg = null;
--            oApp = null;

SET LANGUAGE 'Brazilian'
SET NOCOUNT ON

DECLARE 
	@TableBody01 VARCHAR(8000),	
	@TableBody02 VARCHAR(8000),
	@TableBody03 VARCHAR(8000),
    @BodyHead VARCHAR(8000),
    @Table1 VARCHAR(8000),
    @Table2 VARCHAR(8000), 
    @Table3 VARCHAR(8000), 
    @TableTail VARCHAR(8000),    
    @BodyTail VARCHAR(8000),
    @data DATE = CONVERT(CHAR(10),GETDATE(),112),
    @dataprocesso VARCHAR(30) = DATENAME(DAY,GETDATE()) + ' de ' +DATENAME(MONTH,GETDATE()) + ' de ' +DATENAME(YEAR,GETDATE()) + ' às ' +DATENAME(HOUR,GETDATE()) + ':' +DATENAME(MINUTE,GETDATE()),
    @msg VARCHAR(8000)		                  
    
SET @BodyHead = '<!DOCTYPE html>'
					+ '<html>'
					+	'<head>'
					+	'<title>Processo Anti Attrition</title>'
					+	'<style>'
					+	'table {border-collapse: collapse; border: 1px solid black;width: 40%;}'
					+	'th, td {text-align: left;padding: 3px;font-family: Arial;font-size:10pt;}'
					+	'</style>'
					+	'</head>'
					+	'<body>'
					+	'<b><font face="Arial" size="2"> Arquivos processados em  '  + @dataprocesso + '</font></b>'
					+	'<br><br/>';
														
SET @Table1 = '<table><tr><th><b>Protocolo processo Anti Attrition</b></th><th><b></b></th>';
SET @Table2 = '<table><tr><th><b>Arquivos Carregados</b></th>';
SET @Table3 = '<table><tr><th><b>Arquivos Rejeitados</b></th>';
SET @TableTail = '</table></p><br><br/>';  					
SET @BodyTail = '</body></html>';				

SET @TableBody01 = (								
				SELECT 
					td = [Protocolo processo Anti Attrition],
					td = [ ]
				FROM(
						SELECT 'Qtde de arquivos carregados: ' AS [Protocolo processo Anti Attrition],CAST(COUNT(nm_Arquivo) AS CHAR(8)) AS [ ]
						FROM tbBR_tab_Arquivo
						WHERE cs_Tipo IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO')
						AND CONVERT(CHAR(10),dh_Ins,112) = @data

						UNION ALL

						SELECT 'Qtde de arquivos rejeitados: ',CAST(COUNT(nm_Arquivo) AS CHAR(8))
						FROM tbGS_tab_AttritionRejeitados
						WHERE CONVERT(CHAR(10),dt_Processo,112) =@data

						UNION ALL
							                    
						SELECT 'Qtde de registros inseridos: ',CAST(COUNT(id_Arquivo) AS CHAR(8))
						FROM tbGS_hst_Anttrition
						WHERE id_Arquivo IN (SELECT id_Arquivo
										  FROM tbBR_tab_Arquivo
										  WHERE cs_Tipo IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO')
										  AND CONVERT(CHAR(10),dh_Ins,112) = @data)						
					) AS A
					FOR XML RAW('tr'),ELEMENTS
    
			)
			
SET @TableBody02 = (
						SELECT td = nm_Arquivo
						FROM tbBR_tab_Arquivo
						WHERE cs_Tipo IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO')
						AND CONVERT(CHAR(10),dh_Ins,112) = CONVERT(CHAR(10),@data,112)
						FOR XML RAW('tr'),ELEMENTS

			)	
			
SET @TableBody03 = (
						SELECT DISTINCT 
							td = nm_Arquivo
						FROM tbGS_tab_AttritionRejeitados
						WHERE CONVERT(CHAR(10),dt_Processo,112) = CONVERT(CHAR(10),@data,112)
						FOR XML RAW('tr'),ELEMENTS
			)					


SET @msg = @BodyHead + @Table1 + ISNULL(@TableBody01,'') + @TableTail 
					 + @Table2 + ISNULL(@TableBody02,'') + @TableTail 
					 + @Table3 + ISNULL(@TableBody03,'') + @TableTail + @BodyTail;
					  
SELECT @msg AS 'corpoEmail';
		  
-- ########################################################################################################################
-- 			Tabela formatada 
-- ########################################################################################################################
DECLARE 
	@Body VARCHAR(8000),	
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)				    
    
SET @TableHead = '<!DOCTYPE html>
					<html>
						<head>
						<title>Mapa Cartão de Crédito Bradesco Seguros e Previdência</title>
						<style>
						table {
							border-collapse: collapse;
							border: 1px solid black;
							width: 40%;
						}
						th, td {
							text-align: left;
							padding: 3px;
							font-family: Arial;
							font-size:10pt;
						}
						</style>
						</head>
						<body>
						<font face="Arial" size="2"> Report gerado em :'  + CONVERT(VARCHAR(50), GETDATE(), 106) + '</font> <br/>
						<br/>
						<br> 
						<table>
						<tr><td bgcolor=#A4A4A4><b>Supex</b></td>
							<td bgcolor=#A4A4A4><b>Sucursal</b></td>							
							<td bgcolor=#A4A4A4><b>Total</b></td>' ;
SET @TableTail = '</table></p></body></html>';    				
SET @Body = (
				SELECT TOP 50
					--[td bgcolor=#E0E0E0] = CASE WHEN GROUPING(ds_Sucur) = 1 THEN nm_Supex  ELSE '' END,'',
					[td] = CASE WHEN GROUPING(ds_Sucur) = 1 THEN nm_Supex  ELSE '' END,'',
					[td] = ISNULL(ds_Sucur,''),'',
					[td] = COUNT(ds_Tipo),''
				FROM [vw_RelProducaoGCCS]   
				WHERE nm_Supex IS NOT NULL   
				GROUP BY ROLLUP(nm_Supex,ds_Sucur)
				ORDER BY nm_Supex DESC, ISNULL(ds_Sucur,'z') DESC
                FOR XML RAW('tr'),ELEMENTS
			)

SET @Body = @TableHead + ISNULL(@Body,'') + @TableTail
--Set @Body = REPLACE(@Body, '_x0020_', SPACE(1)) 
--Set @Body = REPLACE(@Body, '_x003D_', '=') 
--Set @Body = REPLACE(@Body, '_x0022_', SPACE(1)) 
--Set @Body = REPLACE(@Body, '_x0023_', '#') 
--Set @Body = REPLACE(@Body, '</td bgcolor=#E0E0E0', '</td>') 
--Set @Body = REPLACE(@Body, '<td bgcolor=#E0E0E0></td>', '<td></td>') 
--Set @Body = REPLACE(@Body, '<td></td>', '<td>bgcolor=#E0E0E0</td>') 

PRINT @Body
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
DECLARE 
	@Body VARCHAR(8000),	
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)				    
    
SET @TableHead = '<!DOCTYPE html>
					<html>
						<head>
						<title>Mapa Cartão de Crédito Bradesco Seguros e Previdência</title>
						<style>
						table {
							border-collapse: collapse;							
							width: 50%;
						}
						th, td {
							text-align: left;
							padding: 3px;
							font-family: Arial;
							font-size:10pt;
						}
						tr:nth-child(even){background-color: #E0E0E0}
						th {
							background-color: #4CAF50;
							color: white;
						}
						</style>
						</head>
						<body>
						<b><font face="Arial" size="2"> Report gerado em :'  + CONVERT(VARCHAR(50), GETDATE(), 106) + '</b></font> <br/>
						<br/>
						<br> 
						<table>
						<tr><th><b>Arquivo</b></th>
							<th><b>Tipo</b></th>							
							<th><b>Data</b></th>' ;
SET @TableTail = '</table></p></body></html>';    				
SET @Body = (
				SELECT
					td = nm_Arquivo,'',
					td = cs_Tipo,'',
					td = CAST(dh_Ins AS DATE),''
				FROM tbBA_tab_Arquivo  
				WHERE nm_Arquivo NOT LIKE '%GCCS80%' 				
                FOR XML RAW('tr'),ELEMENTS
			)

SET @Body = @TableHead + ISNULL(@Body,'') + @TableTail
PRINT @Body
-- ########################################################################################################################
-- 			Altera a cor de fundo apenas das linhas agrupadas:
-- ########################################################################################################################
SET NOCOUNT ON
DECLARE 
	@Body VARCHAR(8000) = '',	
    @TableHead VARCHAR(8000),
    @TableTail VARCHAR(8000),
    @msg VARCHAR(8000)				    
    
SET @TableHead ='<!DOCTYPE html>'
				+'<html>'
				+'	<head>'
				+'	<title>Mapa Cartão de Crédito Bradesco Seguros e Previdência</title>'
				+'	<style>'
				+'	table {'
				+'		border-collapse: collapse;'
				+'		width: 50%;'
				+'	}'
				+'	th, td {'
				+'		text-align: left;'
				+'		padding: 3px;'
				+'		font-family: Arial;'
				+'		font-size:10pt;'
				+'	}'					
				+'	th {'
				+'		background-color: #4CAF50;'
				+'		color: white;'
				+'	}'
				+'	</style>'
				+'	</head>'
				+'	<body>'
				+'	<b><font face="Arial" size="2"> Gerado em:  '  + CONVERT(VARCHAR(50), GETDATE(), 106) + '</font></b>'
				+'	<br>' 
				+'	<table>'
				+'	<tr><th><b>Supex</b></th>'
				+'		<th><b>Sucursal</b></th>'
				+'		<th><b>Total Cartoes</b></th>'
				+'		<th><b>Elo + Inter</b></th>'
				+'		<th><b>Gold</b></th>'
				+'		<th><b>Platinum</b></th>'
				+'		<th><b>Total de pontos</b></th>';
SET @TableTail = '</table></body></html>';  

IF (OBJECT_ID(N'tempdb..#Teste')IS NOT NULL) DROP TABLE #Teste

SELECT 
	  '<tr>'+
    + '<td>'+CAST(CASE WHEN GROUPING(ds_Sucur) = 1 THEN nm_Supex  ELSE '' END AS VARCHAR)
	+ '<td>'+CAST(ISNULL(ds_Sucur,'') AS VARCHAR)
	+ '<td>'+CAST(COUNT(ds_Tipo) AS VARCHAR)
	+ '<td>'+CAST(SUM(CASE WHEN ds_Tipo = 'INTERNACIONAL' OR ds_Bandeira = 'ELO' THEN 1 ELSE 0 END) AS VARCHAR)
    + '<td>'+CAST(SUM(CASE WHEN ds_Tipo = 'GOLD'								 THEN 2 ELSE 0 END) AS VARCHAR)
    + '<td>'+CAST(SUM(CASE WHEN ds_Tipo = 'PLATINUM'							 THEN 3 ELSE 0 END) AS VARCHAR)
    + '<td>'+CAST(SUM(CASE WHEN ds_Tipo = 'INTERNACIONAL' OR ds_Bandeira = 'ELO' THEN 1 ELSE 0 END +  
					  CASE WHEN ds_Tipo = 'GOLD'								 THEN 2 ELSE 0 END +  
					  CASE WHEN ds_Tipo = 'PLATINUM'							 THEN 3 ELSE 0 END) AS VARCHAR)
	+'</tr>' AS COLUNAS	
INTO #Teste		
FROM [vw_RelProducaoGCCS]   
WHERE nm_Supex IS NOT NULL   
GROUP BY ROLLUP(nm_Supex,ds_Sucur)
ORDER BY nm_Supex DESC, ISNULL(ds_Sucur,'z') DESC

SELECT 
	@Body = @Body + 
	ISNULL(CAST(CASE WHEN COLUNAS NOT LIKE '<tr><td><td>%' THEN REPLACE(COLUNAS,'<td>','<td bgcolor="#E0E0E0">') ELSE COLUNAS END AS VARCHAR(8000)),'')		 
FROM #Teste	
WHERE COLUNAS IS NOT NULL		

SET @Body = @TableHead + ISNULL(@Body,'') + @TableTail
SET @msg =  @Body

IF (OBJECT_ID(N'tempdb..#Teste')IS NOT NULL) DROP TABLE #Teste
--PRINT @msg

SELECT @msg AS 'corpoEmail';
--###################################################
-- processo anti attrition

DECLARE 
	@Body VARCHAR(8000),	
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000),
    @data DATE = CONVERT(CHAR(10),GETDATE(),112)				    
    
SET @TableHead = '<!DOCTYPE html>
					<html>
						<head>
						<title>Processo Anti Attrition</title>
						<style>
						table {
							border-collapse: collapse;							
							width: 50%;
						}
						th, td {
							text-align: left;
							padding: 3px;
							font-family: Arial;
							font-size:10pt;
						}
						tr:nth-child(even){background-color: #E0E0E0}
						th {
							background-color: #4CAF50;
							color: white;
						}
						</style>
						</head>
						<body>
						<b><font face="Arial" size="2"> Reporte gerado em:  '  + CONVERT(VARCHAR(50), GETDATE(), 106) + '</font></b>
						<br><br/>
						<table>
						<tr><th><b>Protocolo processo Anti Attrition</b></th>
							<th><b></b></th>';
SET @TableTail = '</table></p></body></html>';    				
SET @Body = (								
				SELECT 
					td = [Protocolo processo Anti Attrition],
					td = [ ]
				FROM(
						SELECT 'Qtde de arquivos carregados: ' AS [Protocolo processo Anti Attrition],CAST(COUNT(nm_Arquivo) AS CHAR(8)) AS [ ]
						FROM tbBR_tab_Arquivo
						WHERE cs_Tipo IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO')
						AND CONVERT(CHAR(10),dh_Ins,112) = @data

						UNION ALL

						SELECT 'Qtde de arquivos rejeitados: ',CAST(COUNT(nm_Arquivo) AS CHAR(8))
						FROM tbGS_tab_AttritionRejeitados
						WHERE CONVERT(CHAR(10),dt_Processo,112) =@data

						UNION ALL

						SELECT 'Qtde de registros inseridos: ',CAST(COUNT(id_Arquivo) AS CHAR(8))
						FROM tbGS_hst_Anttrition
						WHERE id_Arquivo IN (SELECT id_Arquivo
										  FROM tbBR_tab_Arquivo
										  WHERE cs_Tipo IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO')
										  AND CONVERT(CHAR(10),dh_Ins,112) = @data)
						
					    UNION ALL
					    
					    SELECT DISTINCT(nm_Arquivo) AS [Arquivos Carregados], ''[ ]
						FROM tbGS_tab_AttritionRejeitados
						WHERE CONVERT(CHAR(10),dt_Processo,112) = CONVERT(CHAR(10),@data,112)
					) AS A
					FOR XML RAW('tr'),ELEMENTS
    
			)

SET @Body = @TableHead + ISNULL(@Body,'') + @TableTail
PRINT @Body



