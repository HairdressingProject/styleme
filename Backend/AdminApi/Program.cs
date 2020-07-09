using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace AdminApi
{
    public class Program
    {
        public static readonly string API_URL = "http://api.stylebest.me/";
        public static readonly string API_DOMAIN = "stylebest.me";
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>()
                                .UseUrls(API_URL);
                });
    }
}
