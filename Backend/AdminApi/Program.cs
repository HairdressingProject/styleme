using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using System.Net;
using Microsoft.AspNetCore.Server.Kestrel.Https;

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
            var host = CreateHostBuilder(args).Build();
            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.ConfigureKestrel(serverOptions => {
                        serverOptions.Listen(IPAddress.Loopback, 5000);
                        serverOptions.Listen(IPAddress.Loopback, 5001, listenOptions => {
                            listenOptions.UseHttps("certificate.pfx", "Secret1");
                            listenOptions.Protocols = HttpProtocols.Http1AndHttp2;
                        });
                    });                    

                    webBuilder.UseStartup<Startup>();
                });
    }
}
