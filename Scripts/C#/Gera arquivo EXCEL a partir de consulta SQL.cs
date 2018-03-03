// Projeto que gera arquivo EXCEL:

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Excel = Microsoft.Office.Interop.Excel;
using System.Data.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Diagnostics;
using System.IO;

namespace GeraArquivo
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
            // ******  Validar o tempo, pois está demorando para gerar o arquivo ******

            // Início:
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();

            string arquivo = @"D:\Andre\Teste.xlsx";
            Excel.Application app = null;
            Excel.Workbook book = null;
            Excel.Worksheet sheet = null;

            string conn = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=dbCC_CanaisComplementares;Data Source=MZ-VV-BD-015;Connect Timeout=0";

            string tabela = @"tbCC_tab_Campanha201612_Item2.1";
            
            string sqlQuery = @"DECLARE @SQL VARCHAR(8000) = '', @COLUNA VARCHAR(100) = '' " +
                                "SET @SQL = 'SELECT ' + CHAR(13) " +
                                "DECLARE CUR CURSOR FOR " +
                                "SELECT B.name " +
                                "FROM sys.tables AS A " +
                                "	INNER JOIN sys.columns AS B " +
                                "	ON A.object_id = B.object_id " +
                                "WHERE A.name = '" + tabela + "' " +
                                "AND B.name NOT LIKE '%id_Base%' " +
                                "ORDER BY B.column_id " +
                                "OPEN CUR " +
                                "FETCH NEXT FROM CUR INTO @COLUNA " +
                                "WHILE @@FETCH_STATUS = 0 " +
                                "BEGIN " +
                                "	SET @SQL += @COLUNA + ',' + CHAR(13) " +
                                "	FETCH NEXT FROM CUR INTO @COLUNA " +
                                "END " +
                                "CLOSE CUR  " +
                                "DEALLOCATE CUR " +
                                "SET @SQL = REVERSE(SUBSTRING(REVERSE(@SQL),3,8000)) + CHAR(13) " +
                                "SET @SQL += ' FROM [" + tabela +  "]' " +
                                "EXECUTE ( @SQL ) ";

            string sqlQueryTotColunas = @"SELECT COUNT(*)
                                         FROM sys.tables AS A INNER JOIN sys.columns AS B ON A.object_id = B.object_id
                                         WHERE A.name = '" + tabela + "' AND B.name NOT LIKE '%id_Base%'";

            string sqlQueryTotLinhas = @"SELECT COUNT(*) FROM [" + tabela + "]";

            string sqlQueryColunas = @" SELECT B.name 
                                        FROM sys.tables AS A INNER JOIN sys.columns AS B ON A.object_id = B.object_id
                                        WHERE A.name = '" + tabela + "' AND B.name NOT LIKE '%id_Base%' ORDER BY B.column_id";

            // Get quantidade de colunas:
            object totalColunas;
            using (SqlConnection sqlConnection = new SqlConnection(conn))
            {
                sqlConnection.Open();
                using(SqlCommand sqlCommand = new SqlCommand())
                {
                    sqlCommand.CommandText = sqlQueryTotColunas;
                    sqlCommand.CommandType = CommandType.Text;
                    sqlCommand.Connection = sqlConnection;
                    totalColunas = sqlCommand.ExecuteScalar();
                }
            }

            int intTotalColunas = Convert.ToInt32(totalColunas);

            // Get quantidade de linhas:
            object totalLinhas;
            using (SqlConnection sqlConnection = new SqlConnection(conn))
            {
                sqlConnection.Open();
                using (SqlCommand sqlCommand = new SqlCommand())
                {
                    sqlCommand.CommandText = sqlQueryTotLinhas;
                    sqlCommand.CommandType = CommandType.Text;
                    sqlCommand.Connection = sqlConnection;
                    totalLinhas = sqlCommand.ExecuteScalar();
                }
            }

            int intTotalLinhas = Convert.ToInt32(totalLinhas) + 1;            

            // Adiciona o header:
            SqlDataAdapter sqlDataAdapterColunas = new SqlDataAdapter(sqlQueryColunas, conn);
            DataSet dataSetColunas = new DataSet();
            sqlDataAdapterColunas.Fill(dataSetColunas);

            app = new Excel.Application();
            book = app.Workbooks.Add(Type.Missing);
            sheet = book.Worksheets[1] as Excel.Worksheet;

            // Pega o range e transforma em texto:
            Excel.Range range;
            Excel.Range rangeCelulas;
            Excel.Range rangeColunas;

            rangeCelulas = sheet.Cells;
            rangeColunas = rangeCelulas[intTotalLinhas, intTotalColunas] as Excel.Range;
            
            range = sheet.get_Range("A1", rangeColunas);
            range.NumberFormat = "@";

            int countColunas = 1;
            int countLinhas = 2;
            
            foreach (DataRow row in dataSetColunas.Tables[0].Rows)
            {
                foreach (DataColumn column in dataSetColunas.Tables[0].Columns)
                {
                    sheet.Cells[1, countColunas] = row[column];
                    countColunas += 1;
                }
            }

            countColunas = 1;

            // Adiciona as linhas:
            SqlDataAdapter sqlDataAdapterLinhas = new SqlDataAdapter(sqlQuery, conn);
            DataSet dataSetLinhas = new DataSet();
            sqlDataAdapterLinhas.Fill(dataSetLinhas);

            foreach (DataRow row in dataSetLinhas.Tables[0].Rows)
            {
                foreach (DataColumn column in dataSetLinhas.Tables[0].Columns)
                {
                    sheet.Cells[countLinhas, countColunas] = row[column];
                    countColunas += 1;
                }
                countColunas = 1;
                countLinhas += 1;
            }

            book.SaveAs(arquivo, Excel.XlFileFormat.xlOpenXMLWorkbook, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Excel.XlSaveAsAccessMode.xlNoChange, Excel.XlSaveConflictResolution.xlUserResolution, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
            book.Close(true, Type.Missing, Type.Missing);
            app.Quit();

            KillProcessoExcelEspecifico(arquivo);

            // Fim:
            stopWatch.Stop();
            TimeSpan timeSpan = stopWatch.Elapsed;
           
            Console.WriteLine("Arquivo gerado em " + timeSpan.Minutes + ":" + timeSpan.Seconds);
                      
            Console.ReadKey();  

        }
    }
}
