using UsersAPI.Models;
using System.Collections.Generic;

namespace UsersAPIUnitTests.Seeds
{
    public class UsersSeed
    {
        public static List<Users> Seed()
        {
            return new List<Users>
            {
                new Users
                {
                    Id = 1,
                    FirstName = "Admin",
                    LastName = "Istrator",
                    UserName = "admin",
                    UserEmail = "admin@mail.com",
                    UserRole = "admin",
                    UserPasswordHash = "hash1",
                    UserPasswordSalt = "salt1"
                },
                new Users
                {
                    Id = 2,
                    FirstName = "John",
                    LastName = "Doe",
                    UserName = "johnny",
                    UserEmail = "johnny@b.goode",
                    UserRole = "developer",
                    UserPasswordHash = "hash2",
                    UserPasswordSalt = "salt2"
                }
            };
        }
    }
}
