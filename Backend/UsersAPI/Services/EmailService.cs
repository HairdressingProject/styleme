using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using MimeKit;
using System;

namespace UsersAPI.Services
{
    public interface IEmailService
    {
        void SendEmail(string toEmail, string to, string subject, string body);
    }

    public class EmailService : IEmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public void SendEmail(string toEmail, string to, string subject, string body)
        {
            // SetUpGmailAPI();

            var adminUsername = _configuration["Admin:Username"];
            var adminEmail = _configuration["Admin:Email"];
            var adminPassword = _configuration["Admin:Password"];

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(adminUsername, adminEmail));
            message.To.Add(new MailboxAddress(to, toEmail));

            message.Subject = subject;
            message.Body = new TextPart(MimeKit.Text.TextFormat.Plain)
            {
                Text = body
            };

            try
            {
                using var client = new SmtpClient();
                client.Connect("smtp.gmail.com", 587, SecureSocketOptions.Auto);

                client.Authenticate(adminEmail, adminPassword);

                client.Send(message);
                client.Disconnect(true);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // The code below uses the Gmail API to authenticate the Admin's google account
        // It can then be used to send emails to registered users for various purposes, such as to enable them to recover their password or confirm registration
        // For testing / development, MailKit is enough

        /*private void SetUpGmailAPI()
        {
            string[] scopes = { GmailService.Scope.GmailReadonly };
            UserCredential userCredential;

            using (var stream = new FileStream("client_id.json", FileMode.Open, FileAccess.Read))
            {
                string credPath = "token.json";
                userCredential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                    GoogleClientSecrets.Load(stream).Secrets,
                    scopes,
                    "user",
                    CancellationToken.None,
                    new FileDataStore(credPath, true)
                    ).Result;

                Console.WriteLine($"Credential file saved to: {credPath}");
            }

            // Create Gmail API service
            var service = new GmailService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = userCredential,
                ApplicationName = "Hairdressing Project"
            });

            // Define parameters of request
            UsersResource.LabelsResource.ListRequest request = service.Users.Labels.List("me");

            // List labels
            IList<Label> labels = request.Execute().Labels;
            Console.WriteLine("Labels:");
            if (labels != null && labels.Count > 0)
            {
                foreach(var labelItem in labels)
                {
                    Console.WriteLine($"{labelItem.Name}");
                }
            }
            else
            {
                Console.WriteLine("No labels found");
            }
        }

        private Message SendGmailMessage(GmailService service, string userId, MimeMessage emailContent)
        {
            Message message = CreateMessageWithEmail(emailContent);
            message = service.Users.Messages.Send(message, userId).Execute();

            Console.WriteLine($"Message ID: {message.Id}");
            Console.WriteLine(message.ToString());

            return message;
        }

        private Message CreateMessageWithEmail(MimeMessage emailContent)
        {
            MemoryStream stream = new MemoryStream();
            emailContent.WriteTo(stream);

            byte[] messageBytes = stream.ToArray();
            string encodedEmail = Convert.ToBase64String(messageBytes);
            Message gmailMessage = new Message
            {
                Raw = encodedEmail
            };

            return gmailMessage;
        }*/
    }
}
