using AdminApi.Entities;
using AdminApi.Helpers;
using AdminApi.Helpers.Exceptions;
using AdminApi.Models_v2_1;
using AdminApi.Models_v2_1.Validation;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services.Context
{
    public class UsersContext : IUsersContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<Users> Users { get; set; }

        public UsersContext(List<Users> users)
        {
            Users = users;
        }

        public UsersContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        public async Task<Users> Add(SignUpUser user)
        {
            Users userAdded = null;

            if (_context != null)
            {
                var existingUser = await _context
                                            .Users
                                            .AnyAsync(
                                                u => u.UserName == user.UserName ||
                                                u.UserEmail == user.UserEmail
                                            );

                if (!existingUser)
                {
                    string salt = _authenticationService.GenerateSalt();
                    string hash = _authenticationService.HashPassword(user.UserPassword, salt);

                    userAdded = new Users
                    {
                        UserName = user.UserName,
                        UserEmail = user.UserEmail,
                        FirstName = user.FirstName,
                        LastName = user.LastName ?? "",
                        UserRole = user.UserRole,
                        UserPasswordHash = hash,
                        UserPasswordSalt = salt
                    };

                    _context.Users.Add(userAdded);

                    await _context.SaveChangesAsync();

                    userAdded = await _context.Users.FirstOrDefaultAsync(
                        u => u.UserName == userAdded.UserName || 
                        u.UserEmail == userAdded.UserEmail
                        );
                }
            }
            else
            {
                var existingUser = Users.Any(
                                        u => u.UserName == user.UserName ||
                                             u.UserEmail == user.UserEmail
                                        );

                if (!existingUser)
                {
                    var authenticationService = new AuthenticationService(
                                                    new AppSettings { Pepper = "Pepper1", Secret = "Secret1" }, 
                                                    this
                                                    );

                    string salt = authenticationService.GenerateSalt();
                    string hash = authenticationService.HashPassword(user.UserPassword, salt);

                    userAdded = new Users
                    {
                        UserName = user.UserName,
                        UserEmail = user.UserEmail,
                        FirstName = user.FirstName,
                        LastName = user.LastName ?? "",
                        UserRole = user.UserRole,
                        UserPasswordHash = hash,
                        UserPasswordSalt = salt
                    };

                    Users.Add(userAdded);
                }
            }

            return userAdded;
        }

        public Task Authenticate()
        {
            throw new NotImplementedException();
        }

        public async Task<List<Users>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
            {
                List<Users> limitedUsers;

                if (_context != null)
                {
                    limitedUsers = await _context
                                            .Users
                                            .Where(
                                                u =>
                                                    u.UserEmail
                                                    .Trim()
                                                    .ToLower()
                                                    .Contains(
                                                        string.IsNullOrWhiteSpace(search) ?
                                                        search :
                                                        search.Trim().ToLower()) ||
                                                            u.UserName
                                                            .Trim()
                                                            .ToLower()
                                                            .Contains(
                                                                string.IsNullOrWhiteSpace(search) ? 
                                                                search :
                                                                search.Trim().ToLower()
                                                            )
                                                    )
                                            .Include(u => u.UserFeatures)
                                            .Skip(o)
                                            .Take(l)
                                            .ToListAsync();
                }
                else
                {
                    limitedUsers = Users
                                    .Where(
                                            u =>
                                                u.UserEmail
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    string.IsNullOrWhiteSpace(search) ?
                                                    search :
                                                    search.Trim().ToLower()) ||
                                                u.UserName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    string.IsNullOrWhiteSpace(search) ?
                                                    search :
                                                    search.Trim().ToLower()
                                                )
                                            )
                                            .Skip(o)
                                            .Take(l)
                                            .ToList();
                }

                return limitedUsers.WithoutPasswords().ToList();
            }
            return new List<Users>();
        }

        public Task ChangeRole(ulong id, ValidatedUserRoleModel user)
        {
            throw new NotImplementedException();
        }

        public async Task<int> Count(string search = null)
        {
            int searchUsersCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchUsersCount = await _context.Users.Where(
                        u =>
                        u.UserName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        u.UserEmail.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .CountAsync();
                }
                else
                {
                    searchUsersCount = await _context.Users.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchUsersCount = Users.Where(
                        u =>
                        u.UserName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        u.UserEmail.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchUsersCount = Users.Count;
                }
            }

            return searchUsersCount;
        }

        public async Task<Users> Delete(ulong id)
        {
            Users user = null;

            if (_context != null)
            {
                user = await _context.Users.FindAsync(id);

                if (user != null)
                {
                    _context.Users.Remove(user);
                }
                await _context.SaveChangesAsync();                
            }
            else
            {
                user = Users.Where(u => u.Id == id).FirstOrDefault();

                if (user != null)
                {
                    Users.Remove(user);
                }
            }

            return user;
        }

        public async Task<bool> Edit(ulong id, UpdatedUser user)
        {
            bool userUpdated = false;
            bool existingUserName = false;
            bool existingUserEmail = false;

            if (_context != null)
            {
                existingUserName = await _context.Users.AnyAsync(u => u.Id != user.Id && u.UserName == user.UserName);              

                existingUserEmail = await _context.Users.AnyAsync(u => u.Id != user.Id && u.UserEmail == user.UserEmail);

                if (existingUserName)
                {
                    throw new ExistingUserException("Username is taken");
                }

                if (existingUserEmail)
                {
                    throw new ExistingUserException("Email is taken");
                }

                // hash/salt new password
                string salt = _authenticationService.GenerateSalt();
                string hash = _authenticationService.HashPassword(user.UserPassword, salt);

                var currentUser = await _context.Users.FindAsync(user.Id);

                try
                {
                    if (currentUser != null)
                    {
                        currentUser.UserName = user.UserName;
                        currentUser.UserPasswordHash = hash;
                        currentUser.UserPasswordSalt = salt;
                        currentUser.FirstName = user.FirstName;
                        currentUser.LastName = user.LastName ?? currentUser?.LastName;
                        currentUser.UserEmail = user.UserEmail;
                        currentUser.UserRole = user.UserRole ?? currentUser?.UserRole;
                        currentUser.DateCreated = currentUser?.DateCreated;
                        _context.Entry(currentUser).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        userUpdated = true;
                    }
                }
                catch (DbUpdateConcurrencyException)
                {
                    return false;
                }
            }
            else
            {
                existingUserName = Users.Any(u => u.Id != user.Id && u.UserName == user.UserName);
                existingUserEmail = Users.Any(u => u.Id != user.Id && u.UserEmail == user.UserEmail);

                if (existingUserName)
                {
                    throw new ExistingUserException("Username is taken");
                }

                if (existingUserEmail)
                {
                    throw new ExistingUserException("Email is taken");
                }

                var authenticationService = new AuthenticationService(
                        new AppSettings { Secret = "Secret1", Pepper = "Pepper1" },
                        this
                    );

                // hash/salt new password
                string salt = authenticationService.GenerateSalt();
                string hash = authenticationService.HashPassword(user.UserPassword, salt);

                var currentUser = Users.FirstOrDefault(u => u.Id == user.Id);

                if (currentUser != null)
                {
                    currentUser.UserName = user.UserName;
                    currentUser.UserPasswordHash = hash;
                    currentUser.UserPasswordSalt = salt;
                    currentUser.FirstName = user.FirstName;
                    currentUser.LastName = user.LastName ?? currentUser?.LastName;
                    currentUser.UserEmail = user.UserEmail;
                    currentUser.UserRole = user.UserRole ?? currentUser?.UserRole;
                    currentUser.DateCreated = currentUser?.DateCreated;
                    userUpdated = true;
                }
            }

            return userUpdated;
        }

        public async Task<Users> ReadById(ulong id)
        {
            List<Users> results;

            if (_context != null)
            {
                results = await _context
                                    .Users
                                    .Where(u => u.Id == id)
                                    .Include(u => u.UserFeatures)
                                    .ToListAsync();
            }
            else
            {
                results = Users
                            .Where(u => u.Id == id)
                            .ToList();
            }

            if (results.Count < 1)
            {
                return null;
            }
            return results[0].WithoutPassword();
        }

        public async Task<(Users, List<Accounts>)> ReadByToken(Guid token)
        {
            Users user = null;
            List<Accounts> associatedAccounts = null;
            
            if (_context != null)
            {
                associatedAccounts = await _context.Accounts.FromSqlInterpolated($"SELECT * FROM accounts WHERE recover_password_token = UNHEX(REPLACE({token}, {"-"}, {""}))").ToListAsync();

                if (associatedAccounts.Count > 0)
                {
                    var userId = associatedAccounts[0].UserId;
                    user = await _context.Users.FirstOrDefaultAsync(u => u.Id == userId);
                }

                
            }
            else
            {
                associatedAccounts = Users
                                        .Where(u => u.Accounts.RecoverPasswordToken == token.ToByteArray())
                                        .Select(u => u.Accounts)
                                        .ToList();

                if (associatedAccounts.Count > 0)
                {
                    var userId = associatedAccounts[0].UserId;
                    user = Users.FirstOrDefault(u => u.Id == userId);
                }
            }

            return (user, associatedAccounts);
        }

        public Task SignIn(AuthenticatedUserModel user)
        {
            throw new NotImplementedException();
        }
    }
}
