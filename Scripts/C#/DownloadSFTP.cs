using System.IO;
using WinSCP;
			//Faz o download dos arquivos via SFTP utilizando o WinSCP:
			//Referências - https://winscp.net/eng/docs/library
			SessionOptions sessionOptions = new SessionOptions
            {
                Protocol = Protocol.Sftp,
                HostName = "200.185.136.170",
                UserName = "ftpaffinity_prod",
                Password = "@affinityp!@#",
                SshHostKeyFingerprint = "ssh-rsa 1024 2b:ab:7b:34:a9:2b:d8:53:2e:01:db:15:4c:56:a0:be"
            };

            using(Session session = new Session())
            {
                session.ExecutablePath = @"C:\Program Files (x86)\WinSCP\winscp.exe";

                session.Open(sessionOptions);

                TransferOptions transferOptions = new TransferOptions();
                transferOptions.TransferMode = TransferMode.Binary;

                TransferOperationResult transferResult;
                transferResult = session.GetFiles("/Extrato/Extrato_Transacaoes_2016_05_*", "E:\\Andre\\Testes\\EXTRACAO\\", false, transferOptions);

                transferResult.Check();
                foreach (TransferEventArgs transfer in transferResult.Transfers)
                {
                    Console.WriteLine("Download of {0} succeeded", transfer.FileName);
                }

            }

// ###################################################################################################################################
// ###################################################################################################################################

using Renci.SshNet;
using Renci.SshNet.Common;
using Renci.SshNet.Sftp;			
            
            //Faz o download do arquivo via SFTP usando a .dll 'Renci.SshNet.dll':

            string dataAtual = DateTime.Now.ToString("ddMMyyyy");
            String Host = "200.185.136.170";            
            int Port = 22;
            String RemoteFileName = @"/Remessa/ENRIQUECIMENTO_ENVIO_"+ dataAtual + ".txt";
            String LocalDestinationFilename = @"E:\Andre\ENRIQUECIMENTO_ENVIO_"+ dataAtual + ".txt";
            String Username = "ftpaffinity_prod";
            String Password = "@affinityp!@#";

            using (var sftp = new SftpClient(Host, Port, Username, Password))
            {
                sftp.Connect();

                using (var file = File.OpenWrite(LocalDestinationFilename))
                {
                    sftp.DownloadFile(RemoteFileName, file);
                }

                sftp.Disconnect();
            }

			