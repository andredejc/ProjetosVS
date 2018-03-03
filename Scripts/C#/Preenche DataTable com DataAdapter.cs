			string strConexao = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=dbTeste_Carga;Data Source=D5668M001E035;Connect Timeout=0";
            string select = "SELECT TOP 2 B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15 FROM csvFinal	ORDER BY Concurso";

            List<object> lista = new List<object>();

            using(SqlConnection sqlConnection = new SqlConnection(strConexao))
            {
                using(SqlCommand sqlCommand = new SqlCommand(select))
                {
                    using(SqlDataAdapter sqlDataAdapter = new SqlDataAdapter())
                    {
                        sqlCommand.Connection = sqlConnection;
                        sqlDataAdapter.SelectCommand = sqlCommand;
                        using(DataTable dataTable = new DataTable())
                        {
                            sqlDataAdapter.Fill(dataTable);
                                                      
                            foreach(DataRow row in dataTable.Rows)
                            {
                                Console.WriteLine();
                                foreach(DataColumn col in dataTable.Columns)
                                {
                                    Console.Write(row[col.ColumnName]);
                                    lista.Add(row);
                                }
                            }
                        }
                    }
                }
            }

            Console.ReadKey();