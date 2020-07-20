using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Moq;
using AdminApi.Services;
using AdminApi.Models_v2_1;
using AdminApi.Controllers;
using Xunit;
using Microsoft.EntityFrameworkCore;

namespace ApiUnitTests.Controllers
{
    public class UsersControllerTests
    {
        [Fact]
        public async Task GetUsers_ReturnsActionResult_WithAllUsers()
        {
            // Arrange
            var mockDbCtx = new Mock<hair_project_dbContext>();
            var mockAuthService = new Mock<IAuthorizationService>();
            var mockUserService = new Mock<IUserService>();
            var mockEmailService = new Mock<IEmailService>();

            var usersController = new UsersController(mockDbCtx.Object, mockUserService.Object, mockAuthService.Object, mockEmailService.Object);

            // Act
            var result = await usersController.GetUsers();

            // Assert
            Assert.IsType<ActionResult<IEnumerable<Users>>>(result);
        }
    }
}
