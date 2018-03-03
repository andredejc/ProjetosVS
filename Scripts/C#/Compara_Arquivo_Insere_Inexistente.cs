// Metodo que insere os dados do arquivo na tabela;
        static void InsertArquivo(string nomeArquivo)
        {
            string strcon = @"Password=Passw0rd;Persist Security Info=True;User ID=sa;Initial Catalog=TesteCarga;Data Source=D5668M001E035;Connect Timeout=0";
            using (SqlConnection con = new SqlConnection())
            {
                con.ConnectionString = strcon;
                con.Open();
                using (SqlCommand command = new SqlCommand("INSERT INTO tbBR_tab_ArquivoZip(nm_Arquivo,dh_Carga) VALUES(@NomeArquivo,GETDATE())", con))
                {
                    command.Parameters.Add(new SqlParameter("NomeArquivo", nomeArquivo));                    
                    command.ExecuteNonQuery();
                }
            }
        }

        static void Main(string[] args)
        {
            // ----------------------------------------------------------------
            //   Faz um SELECT na tabela arquivos e compara com o diretório:
            // ----------------------------------------------------------------

            // Array que recebe os arquivos do diretório
            string[] arquivos = Directory.GetFiles(@"E:\Andre\Testes\");

            // Lista que recebe as linhas do SqlDataReader
            List<string> lista = new List<string>();

            string strcon = @"Password=Passw0rd;Persist Security Info=True;User ID=sa;Initial Catalog=TesteCarga;Data Source=D5668M001E035;Connect Timeout=0";

            using (SqlConnection con = new SqlConnection())
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    con.ConnectionString = strcon;
                    con.Open();
                    cmd.Connection = con;
                    cmd.CommandText = "SELECT nm_Arquivo " +
                                      "FROM tbBR_tab_ArquivoZip " +
                                      "WHERE YEAR(dh_Carga) = YEAR(GETDATE())";

                    using (SqlDataReader dataRe = cmd.ExecuteReader())
                    {
                        while (dataRe.Read())
                        {
                            // Lista recebe os valores
                            lista.Add((string)dataRe[0]);
                        }

                        foreach (string arquivo in arquivos)
                        {
                            // Verifica se o arquivo da lista não existe nos arquivos
                            if (!lista.Contains(Path.GetFileName(arquivo)))
                            {
                                Console.WriteLine(Path.GetFileName(arquivo));
                                InsertArquivo(Path.GetFileName(arquivo));
                            }
                        }
                    } // using SqlDataReader
                } // using SqlCommand
            } // using SqlConnection
            Console.ReadKey();
        }