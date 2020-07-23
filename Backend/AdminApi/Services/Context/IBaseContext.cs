using System.Collections.Generic;
using System.Threading.Tasks;
using AdminApi.Helpers.Exceptions;

namespace AdminApi.Services.Context
{
    /// <summary>
    /// Base context to be inherited by each context type
    /// </summary>
    /// <typeparam name="T">Resource type (e.g. Users, Colours, etc.)</typeparam>
    public interface IBaseContext<T>
    {
        /// <summary>
        /// Browses all resources
        /// </summary>
        /// <param name="limit">Limits the number of results found</param>
        /// <param name="offset">Offsets the position from which resources should be returned</param>
        /// <param name="search">Only returns resources that match this query</param>
        /// <returns>Resources found</returns>
        Task<List<T>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            );

        /// <summary>
        /// Gets a resource by its ID
        /// </summary>
        /// <param name="id">Resource's ID</param>
        /// <returns>Resource found or null</returns>
        Task<T> ReadById(ulong id);

        /// <summary>
        /// Updates a resource
        /// </summary>
        /// <param name="id">ID of the resource to be updated</param>
        /// <param name="resource">Updated resource object</param>
        /// <exception cref="ExistingResourceException">
        ///     Thrown if another resource with the same property values already exists
        /// </exception>
        /// <returns>Result of the operation</returns>
        Task<bool> Edit(ulong id, T resource);

        /// <summary>
        /// Adds a new resource
        /// </summary>
        /// <param name="resource">resource to be added</param>
        /// <returns>resource added or null or if the operation failed</returns>
        Task<T> Add(T resource);

        /// <summary>
        /// Deletes a resource
        /// </summary>
        /// <param name="id">ID of the resource to be deleted</param>
        /// <returns>resource removed or null (if the operation failed)</returns>
        Task<T> Delete(ulong id);

        /// <summary>
        /// Gets the current total count of resources
        /// </summary>
        /// <param name="search">
        /// Optionally, only get the count of results found from the search query
        /// </param>
        /// <returns></returns>
        Task<int> Count(string search = null);
    }
}
