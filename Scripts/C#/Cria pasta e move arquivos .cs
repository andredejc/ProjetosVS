string source = @"C:\Users\M135038\Desktop\Processo_Anti Attrition\Anti Attrition - Testes\";
            string destino = @"E:\Processoss_SSIS\Anti Attrition\Nao_Carregados\";
            string destData = destino + DateTime.Now.ToString("dd-MM-yyyy");


            Excel.Application excel = new Excel.Application();
            string sName = source + Dts.Variables["User::Arquivo"].Value.ToString();
            Excel.Workbook excelWorkbook = excel.Workbooks.Open(sName, 0, false, 5, "", "", false, Excel.XlPlatform.xlWindows, "",
                                                               true, false, 0, true, false, false);
            Excel._Worksheet excelWorkbookWorksheet = (Excel.Worksheet)excelWorkbook.Worksheets.get_Item(1);

            var cell1 = (string)(excelWorkbookWorksheet.Cells[4,1] as Excel.Range).Value2;
            var cell2 = (string)(excelWorkbookWorksheet.Cells[5,1] as Excel.Range).Value2;


           
            if (cell1 == "TOTAL" && cell2 == "TOTAL EM PORCENTAGEM")
            {

                if (!Directory.Exists(destino + DateTime.Now.ToString("dd-MM-yyyy")))
                {
                    Directory.CreateDirectory(destino + DateTime.Now.ToString("dd-MM-yyyy"));
                }

                string fName = Dts.Variables["User::Arquivo"].Value.ToString();                
                string caminho2 = Path.Combine(destData, fName);


                excelWorkbook.Close(null, null, null);
                excel.Quit();

                File.Move(sName, caminho2);
                
            }
                                          
                        
            Dts.TaskResult = (int)ScriptResults.Success;

            foreach (Process p in System.Diagnostics.Process.GetProcessesByName("Excel"))
            {
                p.Kill();
                p.WaitForExit(); // possibly with a timeout
            }