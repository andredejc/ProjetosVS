using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;

namespace Testes_de_Script
{
    class Program
    {	
		 // Method extrai arquivo utilizando Winrar:
        static void ExtraiArquivo(string caminhoArquivo, string caminhoExtrair)
        {
            var processo = new ProcessStartInfo();
            processo.FileName = @"C:\Program Files\WinRAR\WinRAR.exe";
            processo.Arguments = @"e -o+ " + caminhoArquivo;
            processo.WorkingDirectory = @"" + caminhoExtrair;
            Process.Start(processo);
        }
	
		// Method extrai arquivo utilizando 7z:
        public static void UnzipArquivo(string caminhoArquivo, string arquivoNome)
        {
            using (Process processo = new Process())
            {       
				/* Parâmetros: [-aoa] - Subescreve existente
							   [-aos] - Pula existente
							   [-aou] - Renomeia se existir. Exe: Se existir arq.txt, extrai arq1.txt.				
				*/
                processo.StartInfo.FileName = @"C:\Program Files\7-Zip\7z.exe";
                processo.StartInfo.Arguments = @"e " + arquivoNome + @" -aoa";
                processo.StartInfo.WorkingDirectory = caminhoArquivo;

                processo.Start();
                processo.WaitForExit();
                processo.Close();               
            }
        }     
		
        // Method zipa com ou sem senha utilizando 7z
        static void ZipArquivo(string nomeArquivoZip, string caminhoArquivoZipar,string diretorioOndeSalvarArquivo, string senha = null)
        {            
            string data = DateTime.Now.ToString("yyyy") + "_" + DateTime.Now.ToString("MM") + "_" + DateTime.Now.ToString("dd");
            var processo = new ProcessStartInfo();
            processo.FileName = @"C:\Program Files\7-Zip\7z.exe ";
            processo.WorkingDirectory = @"" + diretorioOndeSalvarArquivo;
            string argumentos;
            // Condicional reduzido:
            argumentos = (senha != null) ? String.Format(@"a ""{0}_{1}.zip"" ""{2}"" -p{3}", nomeArquivoZip, data, caminhoArquivoZipar, senha) : argumentos = String.Format(@"a ""{0}_{1}_.zip"" ""{2}""", nomeArquivoZip, data, caminhoArquivoZipar);            
            processo.Arguments = argumentos;
            Process.Start(processo);
        }

        static void Main(string[] args)
        {
            string nomeArquivo = @"Cancelamento Seguros Mais Protecao Bradesco";
            string arquivoZipar = @"D:\Testes\Cancelamento Seguros Mais Protecao Bradesco.xlsx";
            string ondeSalvar = @"D:\Testes\";
            string senha = "123456";

            ZipArquivo(nomeArquivo, arquivoZipar, ondeSalvar, senha);                     
        }
    }
}
