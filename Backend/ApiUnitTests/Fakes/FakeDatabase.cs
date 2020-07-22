using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Seeds;
using System;
using System.Collections.Generic;

namespace ApiUnitTests.Fakes
{
    public class FakeDatabase
    {
        public List<Users> Users { get; set; }
        public List<Colours> Colours { get; set; }

        public FakeDatabase() 
        {
            Users = new List<Users>();
        }

        public void SeedUsers()
        {
            Users = UsersSeed.Seed();
        }

        public UsersContext SeedUsersContext()
        {
            SeedUsers();
            return new UsersContext(Users);
        }

        public void SeedColours()
        {
            Colours = ColoursSeed.Seed();
        }

        public ColoursContext SeedColoursContext()
        {
            SeedColours();
            return new ColoursContext(Colours);
        }
    }
}
