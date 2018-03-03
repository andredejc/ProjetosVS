			// Modelo de disparo de email c#
			
			Outlook.Application oApp = new Outlook.Application();
            // Create a new mail item.
            Outlook.MailItem oMsg = (Outlook.MailItem)oApp.CreateItem(Outlook.OlItemType.olMailItem);
            // Set HTMLBody. 
            //add the body of the email
            string email = "andre.cordeiro@5800bseguros.com.br";
            oMsg.HTMLBody = Dts.Variables["User::msg"].Value.ToString();
            //Add an attachment.
            String sDisplayName = "Anexo";
            int iPosition = (int)oMsg.Body.Length + 1;
            int iAttachType = (int)Outlook.OlAttachmentType.olByValue;
            //now attached the file
            Outlook.Attachment oAttach = oMsg.Attachments.Add(@"E:\Andre\teste_18022016.txt", iAttachType, iPosition, sDisplayName);
            
            //Subject line
            oMsg.Subject = "Arquivo anexo";
            // Add a recipient.
            Outlook.Recipients oRecips = (Outlook.Recipients)oMsg.Recipients;
            // Change the recipient in the next line if necessary.
            Outlook.Recipient oRecip = (Outlook.Recipient)oRecips.Add(email);
            oRecip.Resolve();
            // Send.
            oMsg.Send();
            // Clean up.
            oRecip = null;
            oRecips = null;
            oMsg = null;
            oApp = null;