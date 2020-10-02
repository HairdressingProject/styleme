/* using System.Collections.Generic;
using System.Threading.Tasks;
using UsersAPI.Models;
using Xunit;
using UsersAPI.Services.Context;
using UsersAPIUnitTests.Fakes;
using System.Linq;
using UsersAPI.Entities;
using UsersAPI.Helpers.Exceptions;

namespace UsersAPIUnitTests.Context
{
    public class UserFeaturesContextTests
    {
        private UserFeaturesContext _userFeaturesContext;
        private FakeDatabase _db;

        public UserFeaturesContextTests()
        {
            _db = new FakeDatabase();
           _userFeaturesContext = new UserFeaturesContext(
               _db.UserFeatures, 
               _db.Users, 
               _db.FaceShapes, 
               _db.Colours, 
               _db.HairLengths, 
               _db.HairStyles,
                _db.SkinTones
                );
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfUserFeatures()
        {
            // Arrange     
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            List<UserFeatures> expected = _db.UserFeatures;

            // Act
            List<UserFeatures> actual = await _userFeaturesContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredUserFeatures()
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            List<UserFeatures> expected = _db.UserFeatures.FindAll(u => u.UserName == "johnny");

            // Act
            // Equivalent to GET /users?limit=1000&offset=0&search=john
            List<UserFeatures> actual = await_userFeaturesContext.Browse("1000", "0" , "john");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            int expected = _db.UserFeatures.Count;

            // Act
            int actual = await_userFeaturesContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            int expected = 1;

            // Act
            // Equivalent to GET /users/count?search=john
            int actual = await_userFeaturesContext.Count("john");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsUserById()
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            ulong id = 1;
            UserFeatures expected = _db.UserFeatures.FirstOrDefault(u => u.Id == id);

            // Act
            UserFeatures actual = await_userFeaturesContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            ulong id = 2;
            List<UserFeatures> currentUserFeatures = _db.UserFeatures;
            UserFeatures current = _db.UserFeatures.FirstOrDefault(u => u.Id == id);
            UserFeatures updated = current.ShallowCopy();
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
            bool actual = await_userFeaturesContext.Edit(id, updatedUser);
            UserFeatures u = _db.UserFeatures.FirstOrDefault(u => u.Id == id);
            _db.UserFeatures = new List<UserFeatures>(currentUserFeatures);

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
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            int currentUserFeaturesCount = _db.UserFeatures.Count;
            List<UserFeatures> currentUserFeatures = _db.UserFeatures;
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
            UserFeatures actual = await_userFeaturesContext.Add(expected);
            int updatedUserFeaturesCount = _db.UserFeatures.Count;
            _db.UserFeatures = new List<UserFeatures>(currentUserFeatures);

            // Assert
            Assert.Equal(expected.UserName, actual.UserName);
            Assert.Equal(currentUserFeaturesCount + 1, updatedUserFeaturesCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsUserDeleted()
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            ulong id = 2;
            List<UserFeatures> currentUserFeatures = _db.UserFeatures;
            int currentUserFeaturesCount = _db.UserFeatures.Count;
            UserFeatures expected = _db.UserFeatures.FirstOrDefault(u => u.Id == id);

            // Act
            UserFeatures actual = await_userFeaturesContext.Delete(id);
            int updatedUserFeaturesCount = _db.UserFeatures.Count;
            _db.UserFeatures = new List<UserFeatures>(currentUserFeatures);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentUserFeaturesCount - 1, updatedUserFeaturesCount);
        }

        private async Task TestEditUserWithException(
            ulong id, 
            bool sameUserName = false, 
            bool sameUserEmail = false
            )
        {
            // Arrange
           _userFeaturesContext = _db.SeedUserFeaturesContext();
            List<UserFeatures> currentUserFeatures = _db.UserFeatures;
            UserFeatures current = _db.UserFeatures.FirstOrDefault(u => u.Id == id);
            UserFeatures updated = current.ShallowCopy();

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
            await Assert.ThrowsAsync<ExistingUserException>(() =>_userFeaturesContext.Edit(id, updatedUser));
        }
    }
}
 */