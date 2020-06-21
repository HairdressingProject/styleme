using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using AdminApi.Entities;
using AdminApi.Helpers;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System.Security.Cryptography;
using Microsoft.Extensions.Configuration;
using System.Linq;

namespace AdminApi.Services
{
    public interface IUserService
    {
        string HashPassword(string password, string salt);
        string GenerateSalt();
        Task<TokenisedUser> Authenticate(string usernameOrEmail, string password);
        bool ValidateUserToken(string token);
        bool ValidateUserPassword(string password, string hash, string salt);
        Task<IEnumerable<Users>> GetAll();
        string GetUserIdFromToken(string token);
    }

    public class UserService : IUserService
    {
        private readonly hair_project_dbContext _context;
        private readonly AppSettings _appSettings;
        private readonly IConfiguration _configuration;

        public UserService(IOptions<AppSettings> appSettings, hair_project_dbContext context, IConfiguration configuration)
        {
            _appSettings = appSettings.Value;
            _context = context;
            _configuration = configuration;
        }

        public async Task<TokenisedUser> Authenticate(string usernameOrEmail, string password)
        {
            var user = await _context.Users.SingleOrDefaultAsync(x =>
                                  x.UserName == usernameOrEmail || 
                                  x.UserEmail == usernameOrEmail
                                  );

            // return null if user not found
            if (user == null)
                return null;

            // check password
            if (!ValidateUserPassword(password, user.UserPasswordHash, user.UserPasswordSalt))
            {
                return null;
            }

            // authentication successful so generate jwt token
            var entityUser = new TokenisedUser(user.Id);
            var key = Encoding.UTF8.GetBytes(_appSettings.Secret);
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, entityUser.Id.ToString())
                }),
                Expires = DateTime.UtcNow.AddDays(7),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
                Issuer = "https://localhost:5000",
                Audience = "http://localhost:5500"                
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            entityUser.Token = tokenHandler.WriteToken(token);           

            return entityUser;
        }

        public string GenerateSalt()
        {
            byte[] bytes = new byte[512 / 8];
            
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(bytes);
                return Convert.ToBase64String(bytes);
            }
        }

        public async Task<IEnumerable<Users>> GetAll()
        {
            var users = await _context.Users.ToListAsync();
            return users.WithoutPasswords();
        }

        public string HashPassword(string password, string salt)
        {
            string pepper = _appSettings.Pepper;

            var bytes = KeyDerivation.Pbkdf2(
                password: password,
                salt: Encoding.UTF8.GetBytes(string.Concat(salt, pepper)),
                prf: KeyDerivationPrf.HMACSHA512,
                iterationCount: 10000,
                numBytesRequested: 512 / 8);

            return Convert.ToBase64String(bytes);
        }

        public bool ValidateUserPassword(string password, string hash, string salt)
        => HashPassword(password, salt) == hash;

        public bool ValidateUserToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(_appSettings.Secret);

            try
            {
                tokenHandler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = true,
                    ValidIssuer = "https://localhost:5000",
                    ValidateAudience = true,
                    ValidAudience = "http://localhost:5500"
                }, out SecurityToken validatedToken);
            }
            catch
            {
                return false;
            }

            return true;
        }

        public string GetUserIdFromToken(string token)
        {
            var handler = new JwtSecurityTokenHandler();
            var t = handler.ReadJwtToken(token);

            var vals = t.Payload.Values.FirstOrDefault();

            return vals.ToString();
        }
    }
}
