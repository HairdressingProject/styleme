using System;
using System.Collections;
using AdminApi.Helpers;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using System.Net;

namespace AdminApi
{
    public class Program
    {
        public static IConfiguration Configuration { get; set; }
        public static readonly string ADMIN_URL = "https://styleme.best";
        public static readonly string API_URL = "https://localhost:5000";
        public static readonly string API_DOMAIN = "styleme.best";
        public static void Main(string[] args)
        {
            var builder = new ConfigurationBuilder()
                            .SetBasePath(Directory.GetCurrentDirectory())
                            .AddEnvironmentVariables()
                            .AddUserSecrets<AppSettings>()
                            .AddJsonFile("appsettings.json", optional: true)
                            .AddJsonFile("appsettings.production.json", optional: false);
            
            Configuration = builder.Build();
            var host = CreateHostBuilder(args).Build();
            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args)
        {
            var settings = Configuration.GetSection("AppSettings").Get<AppSettings>();

            return Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.ConfigureKestrel(serverOptions => {
                        serverOptions.Listen(IPAddress.Loopback, 5000);
                        serverOptions.Listen(IPAddress.Loopback, 5001, listenOptions => {
                            listenOptions.UseHttps(settings.CertificateFilename, settings.CertificatePWD);
                            listenOptions.Protocols = HttpProtocols.Http1AndHttp2;
                        });
                    });                  

                    webBuilder.UseStartup<Startup>();
                });
        }
    }
}
