// Envio de email

try
            {
                // Create the Outlook application by using inline initialization.
                Outlook.Application oApp = new Outlook.Application();

                //Create the new message by using the simplest approach.
                Outlook.MailItem oMsg = (Outlook.MailItem)oApp.CreateItem(Outlook.OlItemType.olMailItem);              

                //Set the basic properties.
                oMsg.To = "andredejc@gmail.com";
                oMsg.CC = "acordeiro.analista@gmail.com";
                oMsg.Subject = "***** Erro de envio *****";
                oMsg.Body = "Houve um erro de envio no arquivo.";

                //Add an attachment.
                // TODO: change file path where appropriate
                String sSource = @"C:\Users\M135038\Documents\Dicionario.txt";
                String sDisplayName = "MyFirstAttachment";
                int iPosition = (int)oMsg.Body.Length + 1;
                int iAttachType = (int)Outlook.OlAttachmentType.olByValue;
                Outlook.Attachment oAttach = oMsg.Attachments.Add(sSource, iAttachType, iPosition, sDisplayName);

                // If you want to, display the message.
                // oMsg.Display(true);  //modal

                //Send the message.
                oMsg.Save();
                oMsg.Send();

                //Explicitly release objects.                
                oAttach = null;
                oMsg = null;
                oApp = null;
            }

                // Simple error handler.
            catch (Exception e)
            {
                Console.WriteLine("{0} Exception caught: ", e);
            }