using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace Testes_de_Script
{
    class Program
    {
        static void Main(string[] args)
        {

            var processo = new ProcessStartInfo();
            processo.FileName = @"C:\Program Files\WinRAR\WinRAR.exe";
            processo.Arguments = @"e -o+ D:\Testes\RICMM_2705_QTD_AMEX.zip";            
            processo.WorkingDirectory = @"D:\Testes\";            
            Process.Start(processo);

            Console.WriteLine("O arquivo foi extraido!");
            Console.ReadKey();
        }
    }
}
