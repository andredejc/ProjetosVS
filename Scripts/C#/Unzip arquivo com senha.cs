			/* Aqui � utilizada biblioteca do pr�prio C#, que n�o extrai arquivos com senha por default */
            //string[] arquivos = Directory.GetFiles(@"C:\Users\M135038\Desktop\PL\", "*.zip");
            //string origem = @"C:\Users\M135038\Desktop\PL";
            //string destino = @"C:\Users\M135038\Desktop\PL\Descompactar";


            //foreach (string arquivo in arquivos)
            //{

            //    // Descompacta o arquivo o par�metro 'System.Text.Encoding.GetEncoding(850)' mant�m a acentua��o do nome do arquivo
            //    ZipFile.ExtractToDirectory(Path.Combine(origem, arquivo), destino, System.Text.Encoding.GetEncoding(850));
            //}

			
            /* Aqui � utilizada uma biblioteca externa 'using Ionic.Zip' que aceita par�metro de password*/
            string zipf = @"E:\Andre\Testes\Vendas Expresso.zip";
            string dir = @"E:\Andre\Testes\";
            using (ZipFile zip = ZipFile.Read(zipf))
            {
                zip.Password = "123456";
                zip.ExtractAll(dir);
            }
            Console.ReadKey();