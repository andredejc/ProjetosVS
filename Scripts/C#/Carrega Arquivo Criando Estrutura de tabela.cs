/*
   Microsoft SQL Server Integration Services Script Task
   Write scripts using Microsoft Visual C# 2008.
   The ScriptMain is the entry point class of the script.
*/

using System;
using System.Data;
using Microsoft.SqlServer.Dts.Runtime;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using Excel = Microsoft.Office.Interop.Excel;
using System.Diagnostics;
using System.Linq;
using System.Data.OleDb;
using System.Collections.Generic;

namespace ST_978aaed4c9d54b9cb7adedf2e1d1f3a7.csproj
{
    [System.AddIn.AddIn("ScriptMain", Version = "1.0", Publisher = "", Description = "")]
    public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
    {

        #region VSTA generated code
        enum ScriptResults
        {
            Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
            Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
        };
        #endregion

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
        
        public static void CriaTabelaInsereDados(string arquivo)
        {
            // -------------------  Cria tabela ----------------------------------------------------------------------------------            
            string connectionString = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=dbCC_CanaisComplementares;Data Source=D5668M001E035;Connect Timeout=0";            
            string extensao = Path.GetExtension(arquivo);
            string tabela = "[tbCC_tmp_" + Path.GetFileNameWithoutExtension(arquivo) + "]";
            // string nomeTabela = "tbCC_tmp_" + Path.GetFileNameWithoutExtension(arquivo);
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("IF OBJECT_ID('" + tabela + "','U') IS NOT NULL DROP TABLE " + tabela + " CREATE TABLE " + tabela + "(" + "\n");
            string[] colunas = null;
            List<string> lista = new List<string>();

            try
            {
                // -----------------------------------------------------------------------------------------------------            
                // SE O ARQUIVO FOR .txt, .csv OU .dat
                // -----------------------------------------------------------------------------------------------------            
                if (extensao == ".txt" || extensao == ".csv" || extensao == ".dat")
                {                    
                    string linha = null;
                    Regex regexPV = new Regex(@"\;");
                    Regex regexTab = new Regex(@"\t");
                    char delimitador;

                    using (StreamReader streamReader = new StreamReader(arquivo, System.Text.Encoding.GetEncoding(1252)))
                    {
                        linha = streamReader.ReadLine();

                        MatchCollection matchPV = regexPV.Matches(linha);
                        int countPV = matchPV.Count;

                        MatchCollection matchTab = regexTab.Matches(linha);
                        int countTab = matchTab.Count;

                        if (countPV > countTab)
                        {
                            colunas = linha.Split(';');
                            delimitador = ';';
                        }
                        else if (countPV < countTab)
                        {
                            colunas = linha.Split('\t');
                            delimitador = '\t';
                        }
                        else
                            throw new System.Exception("Não foi possível identificar o delimitador.");
                    }                                        

                    foreach (string coluna in colunas)
                    {
                        stringBuilder.Append("[" + coluna + "]" + " VARCHAR(250)," + "\n");
                    }

                    string createTable = stringBuilder.ToString();
                    createTable = createTable.Substring(0, createTable.Length - 2) + ")";

                    using (SqlConnection sqlConnection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand sqlCommand = new SqlCommand(createTable))
                        {
                            sqlCommand.Connection = sqlConnection;
                            sqlCommand.Connection.Open();
                            sqlCommand.ExecuteNonQuery();
                        }
                    }
                    // ------------------- Fim Cria tabela -------------------------------------------------------------------------------
                    
                    // ------------------- Insere os dados -------------------------------------------------------------------------------

                    using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(connectionString, SqlBulkCopyOptions.TableLock) { DestinationTableName = tabela, BulkCopyTimeout = 0, BatchSize = 5000 })
                    {
                        using (StreamReader streamReader = new StreamReader(arquivo, Encoding.GetEncoding(1252)))
                        {
                            using (DataTable dataTable = new DataTable())
                            {
                                foreach (string coluna in colunas)
                                {
                                    dataTable.Columns.Add(coluna, typeof(System.String));
                                }

                                int batchSize = 0;

                                streamReader.ReadLine();

                                while (!streamReader.EndOfStream)
                                {                                
                                    string[] linhaArquivo = streamReader.ReadLine().Split(delimitador);
                                    dataTable.Rows.Add(linhaArquivo);
                                    batchSize += 1;

                                    if (batchSize == 5000)
                                    {
                                        sqlBulkCopy.WriteToServer(dataTable);
                                        dataTable.Rows.Clear();
                                        batchSize = 0;
                                    }                                
                                }
                                sqlBulkCopy.WriteToServer(dataTable);
                                dataTable.Rows.Clear();
                            }
                        }
                    }
                    // ------------------- Fim Insere os dados ---------------------------------------------------------------------------

                }
                // -----------------------------------------------------------------------------------------------------            
                // SE O ARQUIVO FOR .xls OU .xlsx
                // -----------------------------------------------------------------------------------------------------            
                else if (extensao == ".xls" || extensao == ".xlsx")
                {                    
                    string excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + arquivo + "; Extended Properties='Excel 12.0; HDR=NO'";

                    Excel.Application app = null;
                    Excel.Workbooks books = null;
                    Excel.Workbook book = null;                    
                    Excel.Worksheet sheet = null;

                    app = new Excel.Application();
                    books = app.Workbooks;
                    book = app.Workbooks.Open(arquivo, 0, false, 5, "", "", false, Excel.XlPlatform.xlWindows, "", true, false, 0, true, false, false);
                    sheet = book.Worksheets[1] as Excel.Worksheet;
                    string planilha = sheet.Name;                    

                    string celula;

                    Excel.Range range = sheet.UsedRange;

                    int rangeColunas = range.Columns.Count;

                    for (int i = 1; i <= rangeColunas; i++)
                    {
                        Regex regex = new Regex(@"(?!^\d+$)^.+$"); // Regex que valida se o nome da coluna não é apenas números.
                        Match match = regex.Match((range.Cells[1, i] as Excel.Range).Value2.ToString());

                        if (match.Success)
                        {
                            celula = (string)(range.Cells[1, i] as Excel.Range).Value2;
                            stringBuilder.Append("[" + celula + "]" + " VARCHAR(250)," + "\n"); 
                            lista.Add(celula);
                        }
                    }

                    string createTable = stringBuilder.ToString();
                    createTable = createTable.Substring(0, createTable.Length - 2) + ")";

                    using (SqlConnection sqlConnection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand sqlCommand = new SqlCommand(createTable))
                        {
                            sqlCommand.Connection = sqlConnection;
                            sqlCommand.Connection.Open();
                            sqlCommand.ExecuteNonQuery();
                        }
                    }

                    // Insere os dados    
                    int count = 0;
                    using(OleDbConnection oleDbConnection = new OleDbConnection(excelConnectionString))
                    {
                        oleDbConnection.Open();
                        using(OleDbCommand oleDbCommand = new OleDbCommand(@"SELECT * FROM [" + planilha + "$]",oleDbConnection))
                        {
                            OleDbDataReader oleDbDataReader;
                            oleDbDataReader = oleDbCommand.ExecuteReader();
                            using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(connectionString) { DestinationTableName = tabela, BulkCopyTimeout = 0 })
                            {
                                foreach(string cel in lista)
                                {
                                    sqlBulkCopy.ColumnMappings.Add(count, cel);
                                    count += 1;
                                }
                                sqlBulkCopy.WriteToServer(oleDbDataReader);
                            }
                        }
                    }

                    book.Close(true, Type.Missing, Type.Missing);
                    app.Quit();
                    KillProcessoExcelEspecifico(arquivo); 
                }

                // -------------------------------------------------------------------------------------------------------------------

            }
            catch (Exception e)
            {
                throw e;
            }
        }        

        public void Main()
        {            
            string arquivo = Dts.Variables["Arquivo"].Value.ToString();

            CriaTabelaInsereDados(arquivo);
                        
            Dts.TaskResult = (int)ScriptResults.Success;
        }
    }
}