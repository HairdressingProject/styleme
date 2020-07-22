using System.Collections.Generic;
using System.Threading.Tasks;
using AdminApi.Models_v2_1;
using Xunit;
using AdminApi.Services.Context;
using ApiUnitTests.Fakes;
using System.Linq;
using AdminApi.Entities;
using AdminApi.Helpers.Exceptions;

namespace ApiUnitTests.Context
{
    public class UsersContextTests
    {
        private UsersContext _usersContext;
        private FakeDatabase _db;

        public UsersContextTests()
        {
            _db = new FakeDatabase();
            _usersContext = new UsersContext(_db.Users);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfUsers()
        {
            // Arrange     
            _usersContext = _db.SeedUsersContext();
            List<Users> expected = _db.Users;

            // Act
            List<Users> actual = await _usersContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredUsers()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            List<Users> expected = _db.Users.FindAll(u => u.UserName == "johnny");

            // Act
            // Equivalent to GET /users?limit=1000&offset=0&search=john
            List<Users> actual = await _usersContext.Browse("1000", "0" , "john");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            int expected = _db.Users.Count;

            // Act
            int actual = await _usersContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            int expected = 1;

            // Act
            // Equivalent to GET /users/count?search=john
            int actual = await _usersContext.Count("john");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsUserById()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            ulong id = 1;
            Users expected = _db.Users.FirstOrDefault(u => u.Id == id);

            // Act
            Users actual = await _usersContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            ulong id = 2;
            List<Users> currentUsers = _db.Users;
            Users current = _db.Users.FirstOrDefault(u => u.Id == id);
            Users updated = current.ShallowCopy();
            updated.UserEmail = "johnny@mail.com";
            UpdatedUser updatedUser = new UpdatedUser
            {
                Id = id,
                UserName = updated.UserName,
                UserEmail = updated.UserEmail,
                FirstName = updated.FirstName,
                LastName = updated.LastName,
                UserPassword = "Password1",
                UserRole = updated.UserRole
            };

            bool expected = true;

            // Act
            bool actual = await _usersContext.Edit(id, updatedUser);
            Users u = _db.Users.FirstOrDefault(u => u.Id == id);
            _db.Users = new List<Users>(currentUsers);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updated.UserEmail, u.UserEmail);            
        }

        [Fact(DisplayName = "Edit with existing username")]
        public async Task Edit_SameUserName_ThrowsExistingUserException()
        {
            await TestEditUserWithException(2, true);
        }

        [Fact(DisplayName = "Edit with existing email")]
        public async Task Edit_SameUserEmail_ThrowsExistingUserException()
        {
            await TestEditUserWithException(2, false, true);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsUserAdded()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            int currentUsersCount = _db.Users.Count;
            List<Users> currentUsers = _db.Users;
            SignUpUser expected = new SignUpUser
            {
                UserName = "carl",
                UserEmail = "carl@mail.com",
                FirstName = "Carl",
                LastName = "Johnson",
                UserPassword = "Password1",
                UserRole = "user"
            };

            // Act
            Users actual = await _usersContext.Add(expected);
            int updatedUsersCount = _db.Users.Count;
            _db.Users = new List<Users>(currentUsers);

            // Assert
            Assert.Equal(expected.UserName, actual.UserName);
            Assert.Equal(currentUsersCount + 1, updatedUsersCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsUserDeleted()
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            ulong id = 2;
            List<Users> currentUsers = _db.Users;
            int currentUsersCount = _db.Users.Count;
            Users expected = _db.Users.FirstOrDefault(u => u.Id == id);

            // Act
            Users actual = await _usersContext.Delete(id);
            int updatedUsersCount = _db.Users.Count;
            _db.Users = new List<Users>(currentUsers);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentUsersCount - 1, updatedUsersCount);
        }

        private async Task TestEditUserWithException(
            ulong id, 
            bool sameUserName = false, 
            bool sameUserEmail = false
            )
        {
            // Arrange
            _usersContext = _db.SeedUsersContext();
            List<Users> currentUsers = _db.Users;
            Users current = _db.Users.FirstOrDefault(u => u.Id == id);
            Users updated = current.ShallowCopy();

            // Act
            switch ((sameUserName, sameUserEmail))
            {
                case (true, false):
                    updated.UserName = "admin";
                    break;

                case (false, true):
                    updated.UserEmail = "admin@mail.com";
                    break;

                case (true, true):
                    updated.UserName = "admin";
                    updated.UserEmail = "admin@mail.com";
                    break;

                default:
                    // (false, false)
                    break;            
            }

            // UserPassword doesn't matter for the purposes of these tests
            UpdatedUser updatedUser = new UpdatedUser
            {
                Id = id,
                UserName = updated.UserName,
                UserEmail = updated.UserEmail,
                FirstName = updated.FirstName,
                LastName = updated.LastName,
                UserPassword = "Password1",
                UserRole = updated.UserRole
            };

            // Assert
            await Assert.ThrowsAsync<ExistingUserException>(() => _usersContext.Edit(id, updatedUser));
        }
    }
}
