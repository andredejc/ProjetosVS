			/*Estas primeiras 3 linhas servem apenas para verificar qual a resolu��o que o computador est� a utilizar*/

            Rectangle resolucao = Screen.PrimaryScreen.Bounds;
            
            int altura = resolucao.Size.Height;
            int largura = resolucao.Size.Width;

            //Agora criamos um novo bitmap que ir� aboserver a resolu��o do ecra
            Bitmap printscreen = new Bitmap(largura, altura);

            //Definimos o bitmap como imagem
            Graphics graphics = Graphics.FromImage(printscreen as Image);

            //Nas duas linhas seguintes, indicamos qual � a posi��o de in�cio do bitmap
            int esquerda = 0;
            int topo = 0;

            /*Associ�mos a imagem bitmap ao objecto graphics, com a informa��o de onde come�a a imagem, e qual tamanho que ter�*/
            graphics.CopyFromScreen(esquerda, topo, 0, 0, printscreen.Size);

            //Por fim, basta apenas indicar o caminho (desktop), o nome da imagem, a extens�o e o formato
            string caminho = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            string nome = "PrintScreen Peopleware";
            printscreen.Save(caminho + "\\" + nome + ".jpg", ImageFormat.Jpeg);
			
			
/////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Print da tela sem a barra de tarefas do Windows
			Bitmap scr = new Bitmap(Screen.PrimaryScreen.WorkingArea.Width, Screen.PrimaryScreen.WorkingArea.Height);            

            Graphics graph = Graphics.FromImage(scr);
            
            graph.CopyFromScreen(Point.Empty,Point.Empty, Screen.PrimaryScreen.WorkingArea.Size);=
                        
            string caminho = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            string nome = "Teste Print";
            scr.Save(caminho + "\\" + nome + ".jpg", ImageFormat.Jpeg);
            			