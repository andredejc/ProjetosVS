using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.IO;

namespace Linq
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionString = @"Password='P@ssw0rd'; User ID='sa';Persist Security Info=True;Initial Catalog=TESTES;Data Source=localhost;Connect Timeout=0";
            string query01 = @"SELECT CPF_GESTOR_MASTER,NM_GESTOR_MASTER,CEL_GESTOR_MASTER FROM [tmp_GESTOR_042017]";
            string query02 = @"SELECT CPF_GESTOR_MASTER,EMAIL_GESTOR_CONTAS FROM tmp_GESTOR_042017_NOVO";
            string caminhoArquivo = @"C:\Temp\IEnumerableFile.txt";
            StringBuilder stringBuilder = new StringBuilder();
            
            DataTable gestorOld = new DataTable();
            DataTable gestorNew = new DataTable();

            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                using (SqlCommand sqlCommand01 = new SqlCommand(query01, sqlConnection))
                {
                    using(SqlDataAdapter sqlDataAdapter01 = new SqlDataAdapter(sqlCommand01))
                    {
                        sqlDataAdapter01.Fill(gestorOld);
                    }                    
                }

                using(SqlCommand sqlCommand02 = new SqlCommand(query02, sqlConnection))
                {
                    using (SqlDataAdapter sqlDataAdapter02 = new SqlDataAdapter(sqlCommand02))
                    {
                        sqlDataAdapter02.Fill(gestorNew);
                    }
                }
            }

            var sql = from tabGestorOld in gestorOld.AsEnumerable()
                      join tabGestorNew in gestorNew.AsEnumerable()
                          on tabGestorOld.Field<string>("CPF_GESTOR_MASTER") 
                          equals tabGestorNew.Field<string>("CPF_GESTOR_MASTER")
                      where tabGestorOld.Field<string>("NM_GESTOR_MASTER").Contains("AUREA MAGNA BATISTA ROCHA DA")                      
                      select new
                          {
                              cpf = tabGestorOld.Field<string>("CPF_GESTOR_MASTER"),
                              nome = tabGestorOld.Field<string>("NM_GESTOR_MASTER"),
                              telefone = tabGestorOld.Field<string>("CEL_GESTOR_MASTER"),
                              email = tabGestorNew.Field<string>("EMAIL_GESTOR_CONTAS")
                          };            

            foreach (var dado in sql)
            {                
                stringBuilder.AppendLine(dado.cpf + ", " + dado.nome + ", " + dado.telefone + ", " + dado.email);
            }
            
            File.WriteAllText(caminhoArquivo, stringBuilder.ToString());

            Console.WriteLine("Fim!");
            Console.ReadKey();
        }
    }
}
