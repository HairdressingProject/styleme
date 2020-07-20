using System;
using System.Collections;
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
        public static readonly string ADMIN_URL = 
            File.Exists(
                Path.GetFullPath(
                        Path.Join(Directory.GetCurrentDirectory(), "appsettings.production.json")
                    )
            ) ? 
                "https://styleme.best" : 
                "http://localhost:3000";
        public static readonly string API_URL = 
            File.Exists(
                Path.GetFullPath(
                        Path.Join(Directory.GetCurrentDirectory(), "appsettings.production.json")
                    )
            ) ? 
                "https://api.styleme.best" : 
                "https://localhost:5001";
        public static readonly string API_DOMAIN = 
            File.Exists(
                Path.GetFullPath(
                        Path.Join(Directory.GetCurrentDirectory(), "appsettings.production.json")
                    )
            ) ? 
                "styleme.best" : 
                "localhost";
        public static void Main(string[] args)
        {
            var builder = new ConfigurationBuilder()
                            .SetBasePath(Directory.GetCurrentDirectory())
                            .AddEnvironmentVariables()
                            .AddUserSecrets<AppSettings>()
                            .AddJsonFile("appsettings.json", optional: false)
                            .AddJsonFile("appsettings.production.json", optional: true);
            
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
                        serverOptions.Listen(IPAddress.Loopback, 5000);
                        serverOptions.Listen(IPAddress.Loopback, 5001, listenOptions => {
                            if (settings.CertificateFilename != null && settings.CertificatePWD != null)
                            {
                                listenOptions.UseHttps(settings.CertificateFilename, settings.CertificatePWD);
                            }
                            else
                            {
                                listenOptions.UseHttps();
                            }                            
                            listenOptions.Protocols = HttpProtocols.Http1AndHttp2;
                        });
                    });                  

                    webBuilder.UseStartup<Startup>();
                });
        }
    }
}
