		private static void KillProcessoExcelEspecifico(string excelFileName)
        {
            string nomeArquivo = Path.GetFileNameWithoutExtension(excelFileName);

            var processes = from p in Process.GetProcessesByName("EXCEL")
                            select p;

            foreach (var process in processes)
            {
                if (process.MainWindowTitle == "Microsoft Excel - " + nomeArquivo || process.MainWindowTitle == "" || process.MainWindowTitle == null)
                {
                    process.Kill();
                }
            }
        }

        private static void ConverteXlsxToCsv(string arquivo, int numPlanilha)
        {
            Excel.Application app = null;
            Excel.Workbooks books = null;
            Excel.Workbook book = null;            
            Excel.Worksheet sheet = null;

            string arquivoCsv = Path.GetDirectoryName(arquivo) + "\\" + Path.GetFileNameWithoutExtension(arquivo) + ".csv";
            string excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + arquivo + "; Extended Properties='Excel 12.0; HDR=NO'";
            app = new Excel.Application();
            books = app.Workbooks;
            book = app.Workbooks.Open(arquivo, 0, false, 5, "", "", false, Excel.XlPlatform.xlWindows, "", true, false, 0, true, false, false);
            sheet = book.Worksheets[numPlanilha] as Excel.Worksheet;            

            Excel.Range range;
            // Pega a última cell com valor:
            Excel.Range ultimaCell = sheet.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell, Type.Missing);

            range = sheet.get_Range("A1", ultimaCell);

            // Remove os filtros se houver:
            if(sheet.AutoFilter != null)
                sheet.AutoFilterMode = false;

            // Limpa os formatos:
            range.ClearFormats();
            book.Save();

            // Converte o range para texto:            
            range.NumberFormat = "@";
            book.Save();         

            // Salva a planilha como CSV:
            book.SaveAs(arquivoCsv, Microsoft.Office.Interop.Excel.XlFileFormat.xlCSV, Type.Missing, Type.Missing, false, false,
                        Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);            
            
            book.Close(true, Type.Missing, Type.Missing);
            app.Quit();
            KillProcessoExcelEspecifico(arquivo);                        

        }

        public void Main()
        {            
            string arquivo = Dts.Variables["Arquivo"].Value.ToString();

            string arquivoCarga = Dts.Variables["DiretorioCarga"].Value.ToString() + "\\" + Path.GetFileName(arquivo);

            File.Copy(arquivo, arquivoCarga, true);

            ConverteXlsxToCsv(arquivoCarga, 1);

            Dts.TaskResult = (int)ScriptResults.Success;
        }
