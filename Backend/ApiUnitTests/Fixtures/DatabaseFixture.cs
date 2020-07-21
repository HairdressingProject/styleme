using AdminApi.Models_v2_1;
using System;
using System.Collections.Generic;
using System.Text;

namespace ApiUnitTests.Fixtures
{
    public class DatabaseFixture
    {
        public List<Users> Users { get; set; }

        public DatabaseFixture()
        {
            Users = new List<Users>
            {
                new Users
                {
                    Id = 1,
                    FirstName = "Admin",
                    LastName = "Instrator",
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
