using UsersAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace UsersAPI.Services
{
    public interface IAuthorizationService
    {
        string GetAuthToken(HttpRequest request);
        void SetAuthCookie(HttpRequest request, HttpResponse response, string token);
        bool ValidateJWTToken(HttpRequest request);
        Task<bool> IsAdminOrDeveloper(HttpRequest request);
    }

    public class AuthorizationService : IAuthorizationService
    {
        private readonly IAuthenticationService _authenticationService;
        private readonly hairdressing_project_dbContext _context;

        public AuthorizationService(IAuthenticationService authenticationService, hairdressing_project_dbContext context)
        {
            _authenticationService = authenticationService;
            _context = context;
        }

        public string GetAuthToken(HttpRequest request)
        {
            return request.Cookies["auth"] ?? request.Headers["Authorization"];
        }

        public void SetAuthCookie(HttpRequest request, HttpResponse response, string token)
        {
            var cookieOptions = new CookieOptions
            {
                HttpOnly = true,
                Expires = DateTimeOffset.UtcNow.AddDays(7),
                Path = "/",
                SameSite = SameSiteMode.Strict,
                Domain = Program.API_DOMAIN,
                Secure = true
            };

            var origin = request.Headers["Origin"];

            if (string.IsNullOrEmpty(origin))
            {
                throw new UnauthorizedAccessException("Invalid request origin");
            }

            response.Cookies.Append("auth", token, cookieOptions);

            response.Headers.Append("Access-Control-Allow-Credentials", "true");
            response.Headers.Append("Access-Control-Allow-Origin", origin);
        }

        public bool ValidateJWTToken(HttpRequest request)
        {
            var token = GetAuthToken(request);
            return _authenticationService.ValidateUserToken(token);
        }

        public async Task<bool> IsAdminOrDeveloper(HttpRequest request)
        {
            if (ValidateJWTToken(request))
            {
                var authCookie = GetAuthToken(request);
                string id = _authenticationService.GetUserIdFromToken(authCookie);

                if (ulong.TryParse(id, out ulong idParsed))
                {
                    Users u = await _context.Users
                                        .FirstOrDefaultAsync(user => user.Id == idParsed);

                    if (u != null)
                    {
                        // check whether user making the request is admin or developer
                        if (u.UserRole == "admin" || u.UserRole == "developer")
                        {
                            // authorised!
                            return true;
                        }
                    }
                }
            }
            return false;
        }
    }
}
