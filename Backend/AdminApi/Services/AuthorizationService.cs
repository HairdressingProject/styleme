using Microsoft.AspNetCore.Http;
using System;
using System.Linq;

namespace AdminApi.Services
{
    public interface IAuthorizationService
    {
        string GetAuthCookie(HttpRequest request);
        void SetAuthCookie(HttpRequest request, HttpResponse response, string token);
        bool ValidateJWTCookie(HttpRequest request);
    }

    public class AuthorizationService : IAuthorizationService
    {
        private readonly IUserService _userService;

        public AuthorizationService(IUserService userService)
        {
            _userService = userService;
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
                Domain = "localhost",
                Secure = false
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
            return _userService.ValidateUserToken(token);
        }
    }
}
