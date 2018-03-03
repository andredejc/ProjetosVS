        //public static string ConvertDataTableToHTML(DataTable dt)
        //{
        //    string html = "<table>";
        //    //add header row
        //    html += "<tr>";
        //    for (int i = 0; i < dt.Columns.Count; i++)
        //        html += "<td>" + dt.Columns[i].ColumnName + "</td>";
        //    html += "</tr>";
        //    //add rows
        //    for (int i = 0; i < dt.Rows.Count; i++)
        //    {
        //        html += "<tr>";
        //        for (int j = 0; j < dt.Columns.Count; j++)
        //            html += "<td>" + dt.Rows[i][j].ToString() + "</td>";
        //        html += "</tr>";
        //    }
        //    html += "</table>";
        //    return html;
        //}
		
///////////////////////////////////////////////////////////////////////////////////

using Microsoft.SqlServer;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Collections;
using System.IO;

namespace TesteSQL
{
    class Program
    {
        static void Main(string[] args)
        {
            // ****************************************************************
            // Faz um SELECT na tabela arquivos e compara com o diretório:
            // ****************************************************************

            // Array que recebe os arquivos do diretório
            string[] arquivos = Directory.GetFiles(@"E:\Andre\Testes\");
            // Lista que recebe as linhas do SqlDataReader
            List<string> lista = new List<string>();
                        
            string strcon = @"Password=Passw0rd;Persist Security Info=True;User ID=sa;Initial Catalog=dbGS_GSC;Data Source=D5668M001E035;Connect Timeout=0";            

            using (SqlConnection con = new SqlConnection())
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    con.ConnectionString = strcon;
                    con.Open();
                    cmd.Connection = con;
                    cmd.CommandText = "SELECT nm_Arquivo FROM tbBR_tab_Arquivo";

                    using (SqlDataReader dataRe = cmd.ExecuteReader())
                    {
                        while (dataRe.Read())
                        {
                            // Lista recebe os valores
                            lista.Add((string)dataRe[0]);
                        }

                        foreach(string arquivo in arquivos)
                        {
                            // Verifica se o arquivo da lista não existe nos arquivos
                            if(!lista.Contains(Path.GetFileName(arquivo)))
                            {
                                Console.WriteLine(Path.GetFileName(arquivo));
                            }
                        }
                    } // using SqlDataReader
                } // using SqlCommand
            } // using SqlConnection
            Console.ReadKey();
        }
    }
}
