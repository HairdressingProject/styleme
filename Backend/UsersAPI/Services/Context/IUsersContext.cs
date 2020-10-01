using UsersAPI.Entities;
using UsersAPI.Models;
using UsersAPI.Models.Validation;
using UsersAPI.Helpers;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using UsersAPI.Controllers;
using UsersAPI.Helpers.Exceptions;

namespace UsersAPI.Services.Context
{
    /// <summary>
    /// Includes BREAD methods that perform tasks for <see cref="UsersController"/>  
    /// </summary>
    public interface IUsersContext : IBaseContext<Users>
    {
        /// <summary>
        /// Gets a user by their JWT token sent in the request
        /// </summary>
        /// <param name="token">GUID recover password token</param>
        /// <returns>User found and list of accounts found or (null, null)</returns>
        Task<(Users, List<Accounts>)> ReadByToken(Guid token);

        /// <summary>
        /// Updates a user
        /// </summary>
        /// <param name="id">ID of the user to be updated</param>
        /// <param name="user">Updated user object</param>
        /// <exception cref="ExistingUserException">
        ///     Thrown if another user has the same username or email
        /// </exception>
        /// <returns>Result of the operation</returns>
        Task<bool> Edit(ulong id, UpdatedUser user);

        /// <summary>
        /// Changes a user's role, as defined in <see cref="UserRoles"/>
        /// </summary>
        /// <param name="id">User's ID</param>
        /// <param name="user">Updated user</param>
        /// <returns></returns>
        Task ChangeRole(ulong id, ValidatedUserRoleModel user);

        /// <summary>
        /// Adds a new user
        /// </summary>
        /// <param name="user">User to be added</param>
        /// <returns>User added or null or if the operation failed</returns>
        Task<Users> Add(SignUpUser user);

        /// <summary>
        /// Performs a sign in action for an existing user
        /// </summary>
        /// <param name="user">User to be signed in</param>
        /// <returns></returns>
        Task SignIn(AuthenticatedUserModel user);

        /// <summary>
        /// Authenticates a user by their JWT token sent in the request
        /// </summary>
        /// <returns></returns>
        Task Authenticate();
    }
}
