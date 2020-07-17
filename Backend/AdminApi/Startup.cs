using System;
using System.Text;
using System.Linq;
using System.Threading.Tasks;
using AdminApi.Helpers;
using AdminApi.Models_v2_1;
using AdminApi.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpOverrides;
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
        private readonly string[] WhitelistedRoutes = new string[] {
            "/users/sign_in", "/users/authenticate"
        };

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
                    ValidAudience = Program.ADMIN_URL,
                    ValidIssuer = Program.API_URL
                };
            })
            .AddCookie(options =>
            {
                options.LoginPath = "/users/sign_in";
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
                                .WithOrigins(Program.ADMIN_URL)
                                .WithMethods("GET", "POST", "PUT", "DELETE")
                                .WithHeaders("Origin", "Content-Type");
                    });
            });

            // HTTPS redirection
            services.AddHttpsRedirection(options => {
                options.RedirectStatusCode = StatusCodes.Status307TemporaryRedirect;
                options.HttpsPort = 5001;
            });

            // Forwarded Headers
            services.Configure<ForwardedHeadersOptions>(options => {
               options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
            });
        }

        private static void RestrictToAdmins(IApplicationBuilder builder)
        {
            builder.Use(async (ctx, next) => {
                Console.WriteLine("Requested colours route");
                await next.Invoke();
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(
            IApplicationBuilder app, 
            IWebHostEnvironment env, 
            IUserService userService,
            hair_project_dbContext dbContext
            )
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else {
               app.UseExceptionHandler("/error");
               app.UseHsts(); 
            }

            // Forwarded headers
            app.UseForwardedHeaders();
            
             // Global CORS
            app.UseCors(AllowedOriginsConf);

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();
            
            app.UseMiddleware<LoggingService>();

            app.UseWhen(
                ctx => !WhitelistedRoutes.Any(r => ctx.Request.Path.Value.Contains(r)),
                builder => {
                    builder.Use(async (ctx, next) => {
                        string authToken = ctx.Request.Cookies["auth"];
                        if (authToken != null && userService.ValidateUserToken(authToken)) {
                            string userId = userService.GetUserIdFromToken(authToken);
                            if (ulong.TryParse(userId, out ulong id)) {
                                using (var serviceScope = app.ApplicationServices.CreateScope()) {
                                    var services = serviceScope.ServiceProvider;
                                    var _dbCtx = services.GetService<hair_project_dbContext>();

                                    var user = await _dbCtx.Users.FindAsync(id);    

                                    if (user != null && user.UserRole == "admin") {
                                        await next();
                                        return;
                                    }
                                }
                            }
                        }
                        ctx.Response.StatusCode = StatusCodes.Status401Unauthorized;
                        await ctx.Response.WriteAsync("You do not have permission to access this data");
                    });
                }
            );

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
