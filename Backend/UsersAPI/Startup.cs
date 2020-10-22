using System;
using System.Text;
using System.Text.Json;
using System.Linq;
using System.Threading.Tasks;
using UsersAPI.Helpers;
using UsersAPI.Models;
using UsersAPI.Services;
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
using UsersAPI.Services.Context;
using Microsoft.EntityFrameworkCore.Internal;
using Newtonsoft.Json.Serialization;

namespace UsersAPI
{
    public interface IAppSettings
    {
        AppSettings ApplicationSettings { get; set; }
    };

    public class Startup
    {
        private readonly string AllowedOriginsConf = "Policy1";
        private readonly string[] OpenRoutes = new string[] {
            "/users/sign_in", "/users/sign_up", "/users/authenticate", "/users/forgot_password"
        };

        private readonly string[] RestrictedRoutes = new string[]
        {
            "/users", "/colours", "/face_shapes", "/face_shape_links", "/hair_lengths", "/hair_length_links", "/hair_styles", "/hair_style_links"
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

            string connectionString = Configuration["ConnectionStrings.StyleMeDevDB"];

            if (connectionString == null)
            {
                connectionString = Configuration.GetConnectionString("StyleMeDevDB");
            }

            // Configure DI for application services
            services.AddScoped<IAuthenticationService, AuthenticationService>();
            services.AddScoped<IAuthorizationService, AuthorizationService>();
            services.AddScoped<IEmailService, EmailService>();
            services.AddScoped<IUsersContext, UsersContext>();


            services.AddDbContext<hairdressing_project_dbContext>(options =>
                options
                .UseMySql(connectionString, mySqlOptions =>
                mySqlOptions
                .ServerVersion(new ServerVersion(new Version(10, 5, 4), ServerType.MariaDb))
                ));

            services.AddControllers().AddJsonOptions(
                options =>
                {
                    options.JsonSerializerOptions.PropertyNamingPolicy = SnakeCaseNamingPolicy.Instance;
                });

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
            /* services.AddHttpsRedirection(options => {
                options.RedirectStatusCode = StatusCodes.Status307TemporaryRedirect;
                options.HttpsPort = 5051;
            }); */

            // Forwarded Headers
            services.Configure<ForwardedHeadersOptions>(options =>
            {
                options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
            });
        }

        private static void RestrictToAdmins(IApplicationBuilder builder)
        {
            builder.Use(async (ctx, next) =>
            {
                Console.WriteLine("Requested colours route");
                await next.Invoke();
            });
        }

        private static async Task ReturnErrorMessage(HttpContext ctx, string message = "You do not have permission to access this data", int statusCode = StatusCodes.Status401Unauthorized)
        {
            ctx.Response.StatusCode = statusCode;
            ctx.Response.ContentType = "application/json";
            var response = new JsonResponse
            {
                Message = message,
                Status = statusCode
            };

            var jsonResponse = JsonSerializer.Serialize(response);
            await ctx.Response.WriteAsync(jsonResponse);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(
            IApplicationBuilder app,
            IWebHostEnvironment env,
            IAuthenticationService authenticationService,
            hairdressing_project_dbContext dbContext
            )
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/error");
                // app.UseHsts(); 
            }

            // Forwarded headers
            app.UseForwardedHeaders();

            // Global CORS
            app.UseCors(AllowedOriginsConf);

            // app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseMiddleware<LoggingService>();

            if (Program.RESTRICT_ACCESS)
            {
                app.UseWhen(
                ctx => !OpenRoutes.Any(r => ctx.Request.Path.Value.Contains(r)),
                builder =>
                {
                    builder.Use(async (ctx, next) =>
                    {
                        using (var servicesScope = app.ApplicationServices.CreateScope())
                        {
                            var services = servicesScope.ServiceProvider;
                            var _authService = services.GetService<IAuthorizationService>();
                            string authToken = _authService.GetAuthToken(ctx.Request);

                            if (authToken != null && authenticationService.ValidateUserToken(authToken))
                            {
                                string userId = authenticationService.GetUserIdFromToken(authToken);
                                if (ulong.TryParse(userId, out ulong id))
                                {
                                    var _dbCtx = services.GetService<hairdressing_project_dbContext>();

                                    var user = await _dbCtx.Users.FindAsync(id);

                                    if (user != null)
                                    {
                                        if (RestrictedRoutes.Any(r => ctx.Request.Path.Value.Contains(r)))
                                        {
                                            if (ctx.Request.Path.Value.StartsWith("/users") || ctx.Request.Path.Value.StartsWith("/accounts"))
                                            {
                                                var reqId = ctx.Request.Path.Value.Split("/").Last();

                                                if (!string.IsNullOrWhiteSpace(reqId) && reqId != "users")
                                                {
                                                    if (ulong.TryParse(reqId, out ulong parsedPathId))
                                                    {
                                                        if (id != parsedPathId && user.UserRole != "admin")
                                                        {
                                                            await ReturnErrorMessage(ctx);
                                                            return;
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    if (user.UserRole != "admin")
                                                    {
                                                        await ReturnErrorMessage(ctx);
                                                        return;
                                                    }
                                                }
                                            }
                                        }
                                        await next();
                                        return;
                                    }
                                }
                            }

                            await ReturnErrorMessage(ctx);
                            return;
                        }

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
