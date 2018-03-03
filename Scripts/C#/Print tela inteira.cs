			/*Estas primeiras 3 linhas servem apenas para verificar qual a resolução que o computador está a utilizar*/

            Rectangle resolucao = Screen.PrimaryScreen.Bounds;
            
            int altura = resolucao.Size.Height;
            int largura = resolucao.Size.Width;

            //Agora criamos um novo bitmap que irá aboserver a resolução do ecra
            Bitmap printscreen = new Bitmap(largura, altura);

            //Definimos o bitmap como imagem
            Graphics graphics = Graphics.FromImage(printscreen as Image);

            //Nas duas linhas seguintes, indicamos qual é a posição de início do bitmap
            int esquerda = 0;
            int topo = 0;

            /*Associámos a imagem bitmap ao objecto graphics, com a informação de onde começa a imagem, e qual tamanho que terá*/
            graphics.CopyFromScreen(esquerda, topo, 0, 0, printscreen.Size);

            //Por fim, basta apenas indicar o caminho (desktop), o nome da imagem, a extensão e o formato
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
            			