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
        public static readonly string ADMIN_URL = "https://localhost:3000";
        public static readonly string API_URL = "https://localhost:5000";
        public static readonly string API_DOMAIN = "localhost:5000";

        public static void Main(string[] args)
        {
            var builder = new ConfigurationBuilder()
                            .SetBasePath(Directory.GetCurrentDirectory())
                            .AddEnvironmentVariables()
                            .AddUserSecrets<AppSettings>()
                            .AddJsonFile("appsettings.json");
            
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
                            listenOptions.UseHttps();
                            listenOptions.Protocols = HttpProtocols.Http1AndHttp2;
                        });
                    });                  

                    webBuilder.UseStartup<Startup>();
                });
        }
    }
}
