using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace Testes_de_Script
{
    class Program
    {
        static int _value;
        static int Id(string element)
        {            
            return string.IsNullOrEmpty(element) ? -1 : _value++;
        }

        static void Main(string[] args)
        {
            string arquivo = @"C:\temp\teste.csv";
            string linha = null;
            string[] colunas = null;
            char delimitador = ',';
            IEnumerable<DataRow> query;

            using (DataTable dataTable = new DataTable())
            {
                using (StreamReader reader = new StreamReader(arquivo, Encoding.GetEncoding(1252)))
                {
                    linha = reader.ReadLine();
                    colunas = linha.Split(delimitador);

                    foreach (string coluna in colunas)
                    {
                        dataTable.Columns.Add(coluna, typeof(String));
                    }

                    while (!reader.EndOfStream)
                    {
                        string[] linhaArquivo = reader.ReadLine().Split(delimitador);
                        dataTable.Rows.Add(linhaArquivo);
                    }
                }

                var linqColunas = from elemento in colunas
                                  select new { Value = elemento, Id = Id(elemento) };

                foreach(var a in linqColunas)
                {
                    string valor = a.Value;
                    int id = a.Id;

                    Console.WriteLine(a);
                }

                query = from row in dataTable.AsEnumerable()
                        select row;

            }           

            Console.WriteLine("Fim");
            Console.ReadKey();

        }
    }
}
