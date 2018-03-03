DataTable dt = new DataTable();
            
            dt.Columns.Add("id", typeof(string));
            dt.Columns.Add("nome", typeof(string));
            dt.Columns.Add("data", typeof(string));

            string file = @"D:\Testes\Testes.txt";

            // System.Text.Encoding.GetEncoding(1252) para ler corretamente campos com acentução
            using (StreamReader arquivo = new StreamReader(file, System.Text.Encoding.GetEncoding(1252)))
            {
                string linhaArquivo;
                string[] campos;
                DataRow registro;
                arquivo.ReadLine();
                while (!arquivo.EndOfStream)
                {
                    linhaArquivo = arquivo.ReadLine();
                    campos = linhaArquivo.Split(new string[] { ";" }, StringSplitOptions.None);
                    registro = dt.NewRow();
                    registro["id"] = campos[0].Trim();
                    registro["nome"] = campos[1].Trim();
                    registro["data"] = campos[2].Trim();
                    dt.Rows.Add(registro);
                }
            }

            string conexao = @"Password=Passw0rd;Persist Security Info=True;User ID=sa;Initial Catalog=Carga;Data Source=D5668M001E035;Connect Timeout=0";
            using (SqlBulkCopy bc = new SqlBulkCopy(conexao))
            {
                bc.DestinationTableName = "dbo.dados";

                bc.ColumnMappings.Add("id", "id");
                bc.ColumnMappings.Add("nome", "nome");
                bc.ColumnMappings.Add("data", "data");

                bc.WriteToServer(dt);
            }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



string strcon = @"Password=Passw0rd;Persist Security Info=True;User ID=sa;Initial Catalog=Carga;Data Source=D5668M001E035;Connect Timeout=0";
            string file = @"D:\Testes\Testes.txt";

            DataTable dt = new DataTable();
            DataColumn dc;
            DataRow dr;

            dc = new DataColumn();
            dc.DataType = System.Type.GetType("System.String");
            dc.ColumnName = "id";
            dc.Unique = false;
            dt.Columns.Add(dc);
            dc = new DataColumn();
            dc.DataType = System.Type.GetType("System.String");
            dc.ColumnName = "nome";
            dc.Unique = false;
            dt.Columns.Add(dc);
            dc = new DataColumn();
            dc.DataType = System.Type.GetType("System.String");
            dc.ColumnName = "data";
            dc.Unique = false;
            dt.Columns.Add(dc);

            StreamReader sr = new StreamReader(file);
            string input;
            while ((input = sr.ReadLine()) != null)
            {
                string[] s = input.Split(new char[] { ';' });
                dr = dt.NewRow();
                dr["id"] = s[0];
                dr["nome"] = s[1];
                dr["data"] = s[2];
                dt.Rows.Add(dr);
            }
            sr.Close();
           
            using(SqlBulkCopy bulkCopy = new SqlBulkCopy(strcon, SqlBulkCopyOptions.TableLock))
            {
                bulkCopy.DestinationTableName = "dados";
                bulkCopy.ColumnMappings.Add("id", "id");
                bulkCopy.ColumnMappings.Add("nome", "nome");
                bulkCopy.ColumnMappings.Add("data", "data");
                bulkCopy.WriteToServer(dt);         
            }     