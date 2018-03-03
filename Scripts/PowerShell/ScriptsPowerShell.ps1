# Ajuda sobre comandos:
Get-Help Get-ChildItem -ShowWindow

## -----------------------------------------------------------------
# Pega as linhas do arquivo de entrada onde existe o padrão passado:
## -----------------------------------------------------------------

$arquivoIn = "C:\Users\A0066013\Documents\ANDRE\Origem\teste.txt"
$arquivoOut = "C:\Users\A0066013\Documents\ANDRE\Origem\testeOut.txt"
$padrao = "PENS"

Get-Content $arquivoIn | Where-Object { $_.Contains($padrao) } | Add-Content $arquivoOut

## -----------------------------------------------------------------
# Pega strings em um array e mostra na tela:
## -----------------------------------------------------------------

$var = @("Server 01","Server 02")

$var | ForEach-Object { 
    $servidor = $_ 
    Write-Host $servidor 
}

## -----------------------------------------------------------------
# Extrai(Expand-Archive) e Zipa(Compress-Archive) arquivos:
## -----------------------------------------------------------------
Expand-Archive -LiteralPath "C:\temp\IEnumerableFile.zip" -DestinationPath "c:\temp"
Compress-Archive -LiteralPath "C:\temp\IEnumerableFile.txt" -DestinationPath "c:\temp\arquivozipado.zip"