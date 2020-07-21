using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using Moq;
using AdminApi.Services;
using AdminApi.Models_v2_1;
using AdminApi.Controllers;
using Xunit;
using AdminApi.Services.Context;
using ApiUnitTests.Fixtures;

namespace ApiUnitTests.Context
{
    public class UsersContextTests : IClassFixture<DatabaseFixture>
    {
        private UsersContext _usersContext;
        private DatabaseFixture _db;

        public UsersContextTests(DatabaseFixture db)
        {
            _db = db;
            _usersContext = new UsersContext(_db.Users);
        }

        [Fact]
        public async Task Browse_ReturnsListOfUsers()
        {
            // Arrange           
            List<Users> expected = _db.Users;

            // Act
            List<Users> actual = await _usersContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }
    }
}
