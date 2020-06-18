using System;
using System.Text;
using System.Threading.Tasks;
using AdminApi.Helpers;
using AdminApi.Models_v2_1;
using AdminApi.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using Pomelo.EntityFrameworkCore.MySql.Storage;

namespace AdminApi
{
    public interface IAppSettings
    {
        AppSettings ApplicationSettings { get; set; }
    };

    public class Startup
    {
        private readonly string AllowedOriginsConf = "Policy1";

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Register App Settings for authentication
            var appSettingsSection = Configuration.GetSection("AppSettings");
            services.Configure<AppSettings>(appSettingsSection);

            // Configure JWT authentication
            var appSettings = appSettingsSection.Get<AppSettings>();
            var key = Encoding.ASCII.GetBytes(appSettings.Secret);

            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.SaveToken = true;

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidAudience = "https://localhost:3000",
                    ValidIssuer = "https://localhost:5000"
                };
            })
            .AddCookie(options =>
            {
                options.LoginPath = "/api/users/sign_in";
                options.Events.OnRedirectToLogin = (context) =>
                {
                    context.Response.StatusCode = 401;
                    return Task.CompletedTask;
                };
            });

            // Configure DI for application services
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IAuthorizationService, AuthorizationService>();
            services.AddScoped<IEmailService, EmailService>();

            // Register DB Context
            services.AddDbContext<hair_project_dbContext>(options =>
            options
            .UseMySql(Configuration.GetConnectionString("HairDesignDB"), mySqlOptions =>
            mySqlOptions
            .ServerVersion(new ServerVersion(new Version(8, 0, 19), ServerType.MySql))
            ));

            services.AddControllers().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );

            // CORS Policy
            services.AddCors(options =>
            {
                options.AddPolicy(name: AllowedOriginsConf,
                    builder =>
                    {
                        builder.AllowCredentials()
                                .WithOrigins("https://localhost:3000")
                                .WithMethods("GET", "POST", "PUT", "DELETE")
                                .WithHeaders("Origin", "Content-Type");
                    });

                /*options.AddPolicy(name: AllowedOriginsConf,
                    builder =>
                    {
                        builder.AllowCredentials()
                                .WithOrigins("http://localhost:3000")
                                .WithMethods("GET", "POST", "PUT", "DELETE")
                                .WithHeaders("Origin", "Content-Type");
                    });*/
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            // Global CORS
            app.UseCors(AllowedOriginsConf);

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
