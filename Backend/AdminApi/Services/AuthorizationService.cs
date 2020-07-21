using AdminApi.Models_v2_1;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services
{
    public interface IAuthorizationService
    {
        string GetAuthCookie(HttpRequest request);
        void SetAuthCookie(HttpRequest request, HttpResponse response, string token);
        bool ValidateJWTCookie(HttpRequest request);
        Task<bool> IsAdminOrDeveloper(HttpRequest request);
    }

    public class AuthorizationService : IAuthorizationService
    {
        private readonly IAuthenticationService _authenticationService;
        private readonly hair_project_dbContext _context;

        public AuthorizationService(IAuthenticationService authenticationService, hair_project_dbContext context)
        {
            _authenticationService = authenticationService;
            _context = context;
        }

        public string GetAuthCookie(HttpRequest request)
        {
            return request.Cookies["auth"];
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

        public bool ValidateJWTCookie(HttpRequest request)
        {
            var token = GetAuthCookie(request);
            return _authenticationService.ValidateUserToken(token);
        }

        public async Task<bool> IsAdminOrDeveloper(HttpRequest request)
        {
            if (ValidateJWTCookie(request))
            {
                var authCookie = GetAuthCookie(request);
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
