// Pega todos os arquivos que tiverem esse padr�o:: '01-1 - Ap�lices N�vel Detalhado por Data de Movimento2016-11-04.zip'
// Ignora esses:: '01-1 - Ap�lices N�vel Detalhado por Data de Movimento2016-07-18 06.02.11.218.zip' e 'GERA��O ARQUIVOS - 01-1 - Ap�lices N�vel Detalhado por Data de Movimento (Dental Individual)2016-11-02.zip'
            string diretorio = @"\\D5668m001e035\operacoes\SAUDE\DENTAL\";

            string[] arquivos = Directory.GetFiles(diretorio, "*.zip");

            foreach(string arquivo in arquivos)
            {
                Regex regex = new Regex(@"(?<!GERA.*)\d{4}-\d{2}-\d{2}.zip");
				// Regex que ignora caracteres n�o alfa num�ricos - ^[A-Za-z�-�0-9 ]*$
                Match match = regex.Match(arquivo);

                if (match.Success)
                {
                    Console.WriteLine(arquivo);
                }
            } 