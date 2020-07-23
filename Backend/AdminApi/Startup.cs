using System;
using System.Text;
using System.Text.Json;
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
using AdminApi.Services.Context;

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
            "/users/sign_in", "/users/authenticate", "/users/forgot_password"
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
            services.AddScoped<IAuthenticationService, AuthenticationService>();
            services.AddScoped<IAuthorizationService, AuthorizationService>();
            services.AddScoped<IEmailService, EmailService>();
            services.AddScoped<IUsersContext, UsersContext>();

            // Register DB Context
            if (Program.USE_PRODUCTION_SETTINGS)
            {
                services.AddDbContext<hair_project_dbContext>(options =>
                options
                .UseMySql(Configuration.GetConnectionString("HairdressingProjectDB"), mySqlOptions =>
                mySqlOptions
                .ServerVersion(new ServerVersion(new Version(10, 5, 4), ServerType.MariaDb))
                ));
            }
            else
            {
                services.AddDbContext<hair_project_dbContext>(options =>
                options
                .UseMySql(Configuration.GetConnectionString("DefaultConnection"), mySqlOptions =>
                mySqlOptions
                .ServerVersion(new ServerVersion(new Version(10, 5, 4), ServerType.MariaDb))
                ));
            }

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
            IAuthenticationService authenticationService,
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

            if (Program.RESTRICT_ACCESS)
            {
                app.UseWhen(
                ctx => !WhitelistedRoutes.Any(r => ctx.Request.Path.Value.Contains(r)),
                builder => {
                    builder.Use(async (ctx, next) => {
                        string authToken = ctx.Request.Cookies["auth"];
                        if (authToken != null && authenticationService.ValidateUserToken(authToken)) {
                            string userId = authenticationService.GetUserIdFromToken(authToken);
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
                        ctx.Response.ContentType = "application/json";
                        var response = new JsonResponse
                        {
                            Message = "You do not have permission to access this data",
                            Status = 401
                        };

                        var jsonResponse = JsonSerializer.Serialize(response);
                        await ctx.Response.WriteAsync(jsonResponse);
                    });
                }
            );
            }            

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
