// Executa pacote SSIS

using Microsoft.SqlServer.Dts.Runtime;

static void Main(string[] args)
        {
            string pkgLocal = @"C:\Andre\Projetos\ETLs_Execucao\ETLs_Execucao\pkg_dbBA_GeraCartSeg.dtsx";            
            Application app = new Application();
            Package pkg = app.LoadPackage(pkgLocal, null);
            DTSExecResult pkgResults = pkg.Execute();

            Console.WriteLine(pkgResults.ToString());
            Console.ReadKey();

        }