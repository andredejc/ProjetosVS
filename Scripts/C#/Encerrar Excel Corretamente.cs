using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Sql;
using System.Data.OleDb;
using Excel = Microsoft.Office.Interop.Excel;
using System.Runtime.InteropServices;
using System.Threading;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;

		// Método que mata o processo orfão do Excel:
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


        public void Main()
        {
            Excel.Application app = null;
            Excel.Workbooks books = null;
            Excel.Workbook book = null;
            Excel.Sheets sheets = null;
            Excel.Worksheet sheet = null;

            int count = 3;
            string arquivo = @"\\D5668m001e035\operacoes\Andre\201610_RELATORIO_ANALÍTICO_VENDAS__CREDSYSTEM PL_191020160320.xlsx";
            string excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + arquivo + "; Extended Properties='Excel 12.0; HDR=NO'";
            string sqlConnectionString = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=dbTeste_Carga;Data Source=D5668M001E035;Connect Timeout=0";

            app = new Excel.ApplicationClass();
            books = app.Workbooks;
            book = app.Workbooks.Open(arquivo, 0, true, 5, "", "", false, Excel.XlPlatform.xlWindows, "",true, false, 0, true, false, false);
            while (count < 6)
            {
                sheet = book.Worksheets[count] as Excel.Worksheet;
                string plan = sheet.Name;


                using (OleDbConnection oleDbConnection = new OleDbConnection(excelConnectionString))
                {
                    oleDbConnection.Open();

                    using (OleDbCommand oleDbCommand = new OleDbCommand(@"SELECT * FROM [" + plan + "$]", oleDbConnection))
                    {
                        OleDbDataReader oleDbDataReader;
                        oleDbDataReader = oleDbCommand.ExecuteReader();

                        using (SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConnectionString))
                        {
                            bulkCopy.DestinationTableName = "AnaliticoTeste";
                            bulkCopy.WriteToServer(oleDbDataReader);
                        }
                    }                    
                }
                count += 2;                                                                       
            }

            KillProcessoExcelEspecifico(arquivo);            

            Dts.TaskResult = (int)ScriptResults.Success;              
        }