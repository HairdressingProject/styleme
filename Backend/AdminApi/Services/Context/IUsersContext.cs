using AdminApi.Entities;
using AdminApi.Models_v2_1;
using AdminApi.Models_v2_1.Validation;
using AdminApi.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AdminApi.Controllers;
using AdminApi.Helpers.Exceptions;

namespace AdminApi.Services.Context
{
    /// <summary>
    /// Includes BREAD methods that perform tasks for <see cref="UsersController"/>  
    /// </summary>
    public interface IUsersContext
    {
        /// <summary>
        /// Browses all users
        /// </summary>
        /// <param name="limit">Limits the number of results found</param>
        /// <param name="offset">Offsets the position from which users should be returned</param>
        /// <param name="search">Only returns users that match this query</param>
        /// <returns>Users found</returns>
        Task<List<Users>> Browse(
            string limit = "1000", 
            string offset = "0", 
            string search = ""
            );

        /// <summary>
        /// Gets a user by ID
        /// </summary>
        /// <param name="id">User's ID</param>
        /// <returns>User found or null</returns>
        Task<Users> ReadById(ulong id);

        /// <summary>
        /// Gets a user by their JWT token sent in the request
        /// </summary>
        /// <param name="token">JWT token from the request (e.g. from cookies or Authorization header)</param>
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
        /// Authenticates a user
        /// </summary>
        /// <returns></returns>
        Task Authenticate();

        /// <summary>
        /// Deletes a user
        /// </summary>
        /// <param name="id">ID of the user to be deleted</param>
        /// <returns>User removed or null (if the operation failed)</returns>
        Task<Users> Delete(ulong id);

        /// <summary>
        /// Gets the current total count of users
        /// </summary>
        /// <param name="search">
        /// Optionally, only get the count of results found from the search query
        /// </param>
        /// <returns></returns>
        Task<int> Count(string search = null);
    }
}
