using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.OleDb;
using Microsoft.SqlServer.Dts.Runtime;
using System.Windows.Forms;
using System.IO;
using System.Text;

namespace ST_a01d3260954c456e8b94fc9b7a0da717.csproj
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
       
        public void Main()
        {                       
            string conexao = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=dbBR_BARE;Data Source=D5668M001E035;Connect Timeout=0";            
            string arquivo = Path.Combine(Dts.Variables["User::Diretorio"].Value.ToString(),Dts.Variables["User::Arquivo"].Value.ToString());

            using (SqlBulkCopy bulkcopy = new SqlBulkCopy(conexao,System.Data.SqlClient.SqlBulkCopyOptions.TableLock)
                {
                    DestinationTableName = "tbBR_tab_tmpLarguraFixaAUTO",
                    BulkCopyTimeout = 0,
                    BatchSize = 5000
                })
            {
                using (System.IO.StreamReader reader = new System.IO.StreamReader(arquivo, System.Text.Encoding.GetEncoding(1252)))
                {
                    using (DataTable datatable = new DataTable())
                    {
                        var columns = datatable.Columns;
                        columns.Add("ds_Dados", typeof(string));
                        int batchsize = 0;

                        while (!reader.EndOfStream)
                        {
                            string[] line = reader.ReadLine().Split('\n');
                            datatable.Rows.Add(line);
                            batchsize += 1;
                            if (batchsize == 5000)
                            {
                                bulkcopy.WriteToServer(datatable);
                                datatable.Rows.Clear();
                                batchsize = 0;                                
                            }                            
                        }
                        bulkcopy.WriteToServer(datatable);
                        datatable.Rows.Clear();
                    }
                }
            }                   

            Dts.TaskResult = (int)ScriptResults.Success;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.IO;
using System.Data;
using System.Data.SqlTypes;

namespace Carga_Arquivos_de_texto
{
    class Program
    {
        static void Main(string[] args)
        {
            string strConexao = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=Carga02;Data Source=D5668M001E035;Connect Timeout=0";
            string arquivo = @"\\D5668m001e035\operacoes\Andre\ses_pgbl_fundos.csv";

            using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(strConexao, SqlBulkCopyOptions.TableLock) { DestinationTableName = "ArquivoSusep02", BulkCopyTimeout = 0, BatchSize = 5000 })
            {
                using(StreamReader streamReader = new StreamReader(arquivo,Encoding.GetEncoding(1252)))
                {
                    using(DataTable dataTable = new DataTable())
                    {
                        dataTable.Columns.Add("Coenti", typeof(System.String));
                        dataTable.Columns.Add("Damesano", typeof(System.String));
                        dataTable.Columns.Add("Fundos", typeof(System.String));

                        int batchsize = 0;

                        streamReader.ReadLine();

                        while(!streamReader.EndOfStream)
                        {
                            string[] linha = streamReader.ReadLine().Split(';');
                            dataTable.Rows.Add(linha);
                            batchsize += 1;
                            if(batchsize == 5000)
                            {                                
                                sqlBulkCopy.WriteToServer(dataTable);
                                dataTable.Rows.Clear();
                                batchsize = 0;
                            }
                        }
                        sqlBulkCopy.WriteToServer(dataTable);
                        dataTable.Rows.Clear();
                    }
                }
            }
            Console.WriteLine("Arquivo importado...");
            Console.ReadKey();
        }
    }
}

