			try
            {
                string Arquivo = Dts.Variables["User::Arquivo"].Value.ToString();
                object NullValue = System.Reflection.Missing.Value;
                Microsoft.Office.Interop.Excel.Application excelApp = new Microsoft.Office.Interop.Excel.ApplicationClass();
                excelApp.DisplayAlerts = false;
                Microsoft.Office.Interop.Excel.Workbook Workbook = excelApp.Workbooks.Open(
                       Arquivo, NullValue, NullValue, NullValue, NullValue,
                       NullValue, NullValue, NullValue, NullValue, NullValue,
                       NullValue, NullValue, NullValue, NullValue, NullValue);
                Workbook.RefreshAll();
                System.Threading.Thread.Sleep(10000);
                Workbook.Save();
                Workbook.Close(false, Arquivo, null);
                excelApp.Quit();
                Workbook = null;
                System.Runtime.InteropServices.Marshal.ReleaseComObject(excelApp);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
            finally
            {
                foreach (Process p in System.Diagnostics.Process.GetProcessesByName("Excel"))
                {
                    p.Kill();
                    p.WaitForExit(); // possibly with a timeout
                }
                Dts.TaskResult = (int)ScriptResults.Success;
            }