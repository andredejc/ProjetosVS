using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Data.OleDb;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Collections;
using System.Text.RegularExpressions;
using Excel = Microsoft.Office.Interop.Excel;


namespace Testes_de_Script
{
    class Program
    {
        private static void KillProcessoExcelEspecifico(string excelFileName)
        {
            string nomeArquivo = Path.GetFileNameWithoutExtension(excelFileName);

            var processes = from p in Process.GetProcessesByName("EXCEL")
                            select p;

            foreach (var process in processes)
            {
                if (process.MainWindowTitle == "Microsoft Excel - " + nomeArquivo || process.MainWindowTitle == "" || process.MainWindowTitle == null)
                {
                    process.Kill();
                }
            }
        }

        static void Main(string[] args)
        {
            Excel.Application app = null;
            Excel.Workbooks books = null;
            Excel.Workbook book = null;
            Excel.Sheets sheets = null;
            Excel.Worksheet sheet = null;

            string arquivo = @"\\D5668m001e035\operacoes\Andre\201610_RELATORIO_ANAL�TICO_VENDAS__CREDSYSTEM_251020160123.xlsx";
            string arquivoCarga = Path.Combine(@"\\D5668m001e035\OPERACOES\Andre\Carga\", Path.GetFileName(arquivo));
            string excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + arquivoCarga + "; Extended Properties='Excel 12.0; HDR=NO'";
            string sqlConnectionString = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=dbTeste_Carga;Data Source=D5668M001E035;Connect Timeout=0";

            // Copia o arquivo para o diret�rio de carga para preservar o original:
            File.Copy(arquivo, arquivoCarga, true);

            try
            {
                app = new Excel.Application();
                books = app.Workbooks;
                book = app.Workbooks.Open(arquivoCarga, 0, false, 5, "", "", false, Excel.XlPlatform.xlWindows, "", true, false, 0, true, false, false);

                List<string> lista = new List<string>();

                // Pega os nomes das planilhas:
                foreach (Excel.Worksheet plan in book.Worksheets)
                {
                    lista.Add((string)plan.Name);
                }

                // Para cada planilha que n�o seja de TOTAIS:
                foreach (string nome in lista)
                {
                    if (!nome.Contains("TOTAIS"))
                    {                        
                        sheet = book.Worksheets.get_Item(nome);
                        // Deleta as 7 primeiras linhas que n�o fazem parte do processo:
                        Excel.Range range = sheet.get_Range("A1", "A7".ToString());
                        range.EntireRow.Delete(Excel.XlDirection.xlUp);
                        book.Save();                        

                        using (OleDbConnection oleDbConnection = new OleDbConnection(excelConnectionString))
                        {
                            oleDbConnection.Open();

                            using (DataTable dataTable = new DataTable())
                            {                               
                                using (OleDbCommand oleDbCommand = new OleDbCommand("SELECT * FROM [" + nome + "$]", oleDbConnection))
                                {
                                    using (OleDbDataAdapter oleDbDataAdapter = new OleDbDataAdapter(oleDbCommand))
                                    {
                                        oleDbDataAdapter.Fill(dataTable);
                                    }
                                }

                                using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(sqlConnectionString))
                                {
                                    sqlBulkCopy.DestinationTableName = "tbBS_tmp_CredSystem";
                                    sqlBulkCopy.ColumnMappings.Add(0, "Semana");
                                    sqlBulkCopy.ColumnMappings.Add(1, "Data Inc Documento");
                                    sqlBulkCopy.ColumnMappings.Add(2, "Nome da Loja");
                                    sqlBulkCopy.ColumnMappings.Add(3, "N�mero Produto");
                                    sqlBulkCopy.ColumnMappings.Add(4, "Nome Campanha");
                                    sqlBulkCopy.ColumnMappings.Add(5, "N�mero de Parcelas");
                                    sqlBulkCopy.ColumnMappings.Add(6, "Data Emiss�o");
                                    sqlBulkCopy.ColumnMappings.Add(7, "Dia do Processamento");
                                    sqlBulkCopy.ColumnMappings.Add(8, "N�mero Ap�lice");
                                    sqlBulkCopy.ColumnMappings.Add(9, "N�mero Certificado");
                                    sqlBulkCopy.ColumnMappings.Add(10, "Pr�mio Documento");
                                    sqlBulkCopy.ColumnMappings.Add(11, "N�mero Cliente");
                                    sqlBulkCopy.ColumnMappings.Add(12, "Chave Segurado").ToString(); // Se o campo for num�rico e estiver perdendo formata��o, utilizar o ToString()
                                    sqlBulkCopy.ColumnMappings.Add(13, "Nome Segurado");
                                    sqlBulkCopy.ColumnMappings.Add(14, "N�mero Campanha");
                                    sqlBulkCopy.ColumnMappings.Add(15, "In�cio de Vig�ncia");
                                    sqlBulkCopy.ColumnMappings.Add(16, "Data Libera��o");
                                    sqlBulkCopy.ColumnMappings.Add(17, "Fim Vig�ncia");
                                    sqlBulkCopy.ColumnMappings.Add(18, "N�mero Forma Parcelamento");
                                    sqlBulkCopy.ColumnMappings.Add(19, "N�mero Ciclo Adm Cobran�a");
                                    sqlBulkCopy.WriteToServer(dataTable);
                                }
                            }
                        }
                    }
                }
                
                book.Close(true, Type.Missing, Type.Missing);
                app.Quit();
                // Deleta o arquivo modificado ao final da carga:
                File.Delete(arquivoCarga);

            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                KillProcessoExcelEspecifico(arquivoCarga); 
                //Console.ReadKey();
            }
        }
    }
}
