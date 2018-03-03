		public static DataTable GetData(string select)
        {
            string connString = @"Data Source=localhost;Initial Catalog=TesteCarga;Integrated Security=SSPI;";            
            using (SqlConnection sqlConn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(select))
                {
                    using (SqlDataAdapter dta = new SqlDataAdapter())
                    {
                        cmd.Connection = sqlConn;
                        dta.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            dta.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
        }

        // Método que exporta a tabela para html:
        protected string ExportaHtml(DataTable dt)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<!DOCTYPE html>"
                        + "<html>"
                        + "<head>"
                        + "<style>"
                        + "table {"
                        + "border-collapse: collapse;"
                        + "width: 50%;"
                        + "}"
                        + "th, td {"
                        + "text-align: left;"
                        + "font-family: arial;"
                        + "font-size: 90;"
                        + "padding: 2px;"
                        + "}"
                        + "tr:nth-child(even){background-color: #f2f2f2}"
                        + "th {"
                        + "background-color: #4CAF50;"
                        + "color: white;"
                        + "}"
                        + "</style>"
                        + "</head>"
                        + "<body>");

            html.Append("<table>");
            html.Append("<tr>");            

            foreach (DataColumn column in dt.Columns)
            {
                html.Append("<th>");
                html.Append(column.ColumnName);
                html.Append("</th>");
            }
            html.Append("</tr>");

            foreach (DataRow row in dt.Rows)
            {
                html.Append("<tr>");
                foreach (DataColumn column in dt.Columns)
                {
                    html.Append("<td>");
                    html.Append(row[column.ColumnName]);
                    html.Append("</td>");
                }
                html.Append("</tr>");
            }

            // Fim da tabela
            html.Append("</table></body></html>");

            string htmlBody = html.ToString();
            return htmlBody;            
        }


        public void Main()
        {
            // Recebe a tabela do método GetData:
            DataTable data = GetData("SELECT TOP 10 SUCUR,CORRETOR,DOCUMENTO FROM testeGSC");

            // Recebe o html formatado do método ExportaHtml:
            string html = ExportaHtml(data);

            // Exporta para o arquivo:
            File.WriteAllText(@"E:\Andre\Teste.html", html);

            Dts.TaskResult = (int)ScriptResults.Success;            
        }