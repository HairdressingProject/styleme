using System;
using AdminApi.Helpers;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using System.Net;

namespace AdminApi
{
    public class Program
    {
        public static IConfiguration Configuration { get; set; }
        public static readonly bool RESTRICT_ACCESS = true;
        public static readonly bool USE_PRODUCTION_SETTINGS = File.Exists(
                Path.GetFullPath(
                        Path.Join(Directory.GetCurrentDirectory(), "appsettings.Production.json")
                    )
            );
        public static readonly string ADMIN_URL = 
            USE_PRODUCTION_SETTINGS ? 
                "https://styleme.best" : 
                "http://localhost:5500";
        public static readonly string API_URL = 
            USE_PRODUCTION_SETTINGS ? 
                "https://api.styleme.best" : 
                "https://localhost:5001";
        public static readonly string API_DOMAIN = 
            USE_PRODUCTION_SETTINGS ? 
                "styleme.best" : 
                "localhost";
        public static void Main(string[] args)
        {
            IConfigurationBuilder builder;
            Console.WriteLine($"Using production settings: {USE_PRODUCTION_SETTINGS}");

            builder = new ConfigurationBuilder()
                            .SetBasePath(Directory.GetCurrentDirectory())
                            .AddEnvironmentVariables()
                            .AddUserSecrets<AppSettings>()
                            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                            .AddJsonFile("appsettings.Production.json", optional: true);
                    
            Configuration = builder.Build();
            var host = CreateHostBuilder(args).Build();
            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args)
        {
            var settings = Configuration.GetSection("AppSettings").Get<AppSettings>();

            return Host.CreateDefaultBuilder(args)
                .ConfigureLogging((ctx, logging) => {
                    logging.ClearProviders();
                    logging.AddConsole();
                    logging.AddDebug();

                    logging.AddConfiguration(ctx.Configuration.GetSection("Logging"));
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.ConfigureKestrel(serverOptions => {
                        serverOptions.Listen(IPAddress.Loopback, 5050);
                        /* serverOptions.Listen(IPAddress.Loopback, 5051, listenOptions => {
                            if (settings.CertificateFilename != null && settings.CertificatePWD != null)
                            {
                                listenOptions.UseHttps(settings.CertificateFilename, settings.CertificatePWD);
                            }
                            else
                            {
                                listenOptions.UseHttps();
                            }                            
                            listenOptions.Protocols = HttpProtocols.Http1AndHttp2;
                        }); */
                    });                  

                    webBuilder.UseStartup<Startup>();
                });
        }
    }
}
