using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Seeds;
using System.Collections.Generic;

namespace ApiUnitTests.Fakes
{
    public class FakeDatabase
    {
        public List<Users> Users { get; set; }

        public FakeDatabase() 
        {
            Users = new List<Users>();
        }

        public void Seed()
        {
            Users = UsersSeed.Seed();
        }

        public UsersContext SeedUsersContext()
        {
            Seed();
            return new UsersContext(Users);
        }
    }
}
