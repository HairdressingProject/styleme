using UsersAPI.Helpers.Exceptions;
using UsersAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UsersAPI.Services.Context
{
    public class FaceShapeLinksContext : IFaceShapeLinksContext
    {
        private readonly hairdressing_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<FaceShapeLinks> FaceShapeLinks { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="faceShapeLinks">Sample list of faceShapeLinks</param>
        public FaceShapeLinksContext(List<FaceShapeLinks> faceShapeLinks)
        {
            FaceShapeLinks = faceShapeLinks;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public FaceShapeLinksContext(hairdressing_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new faceShapeLink
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique faceShapeLinks, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="faceShapeLink">FaceShapeLink to be added</param>
        /// <returns>FaceShapeLink added</returns>
        public Task<FaceShapeLinks> Add(FaceShapeLinks faceShapeLink)
        {
            FaceShapeLinks faceShapeLinkAdded = null;

            if (_context != null)
            {
                _context.FaceShapeLinks.Add(faceShapeLink);
                faceShapeLinkAdded = faceShapeLink;
            }
            else
            {
                FaceShapeLinks.Add(faceShapeLink);
                faceShapeLinkAdded = faceShapeLink;
            }

            return Task.FromResult(faceShapeLinkAdded);
        }

        /// <summary>
        /// Browses faceShapeLinks
        /// </summary>
        /// <param name="limit">Optionally limits the number of faceShapeLinks returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which faceShapeLinks will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 faceShapeLinks
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a faceShapeLink by 
        ///     <see cref="FaceShapeLinks.FaceShapeLinkName"/> or 
        ///     <see cref="FaceShapeLinks.FaceShapeLinkHash"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<FaceShapeLinks>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<FaceShapeLinks> limitedFaceShapeLinks = new List<FaceShapeLinks>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedFaceShapeLinks = await _context
                                            .FaceShapeLinks
                                            .Where(
                                            r =>
                                            r.LinkName
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower()) ||
                                            r.LinkUrl
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower())
                                            )
                                            .Skip(o)
                                            .Take(l)
                                            .ToListAsync();
                    }
                    else
                    {
                        limitedFaceShapeLinks = FaceShapeLinks
                                            .Where(
                                            r =>
                                            r.LinkName
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower()) ||
                                            r.LinkUrl
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower())
                                            )
                                            .Skip(o)
                                            .Take(l)
                                            .ToList();
                    }
                }
            }

            return limitedFaceShapeLinks;
        }

        /// <summary>
        /// Counts faceShapeLinks
        /// </summary>
        /// <param name="search">
        ///     Optionally only count faceShapeLinks which
        ///     <see cref="FaceShapeLinks.LinkName"/> or
        ///     <see cref="FaceShapeLinks.LinkUrl"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>FaceShapeLinks count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchFaceShapeLinksCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchFaceShapeLinksCount = await _context.FaceShapeLinks.Where(
                                                r =>
                                                r.LinkName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    search.Trim().ToLower()) ||
                                                r.LinkUrl
                                                .Trim()
                                                .ToLower()
                                                .Contains(search.Trim().ToLower())
                                                ).CountAsync();
                }
                else
                {
                    searchFaceShapeLinksCount = await _context.FaceShapeLinks.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchFaceShapeLinksCount = FaceShapeLinks.Where(
                        c =>
                        c.LinkName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        c.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchFaceShapeLinksCount = FaceShapeLinks.Count;
                }
            }

            return searchFaceShapeLinksCount;
        }

        /// <summary>
        /// Deletes a faceShapeLink by ID
        /// </summary>
        /// <param name="id">ID of the faceShapeLink to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>FaceShapeLink deleted</returns>
        public async Task<FaceShapeLinks> Delete(ulong id)
        {
            FaceShapeLinks faceShapeLink = null;

            if (_context != null)
            {
                faceShapeLink = await _context.FaceShapeLinks.FindAsync(id);

                if (faceShapeLink != null)
                {
                    _context.FaceShapeLinks.Remove(faceShapeLink);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("FaceShapeLink not found");
                }
            }
            else
            {
                faceShapeLink = FaceShapeLinks.Where(u => u.Id == id).FirstOrDefault();

                if (faceShapeLink != null)
                {
                    FaceShapeLinks.Remove(faceShapeLink);
                }
                else
                {
                    throw new ResourceNotFoundException("FaceShapeLink not found");
                }
            }

            return faceShapeLink;
        }

        /// <summary>
        /// Updates an existing faceShapeLink
        /// </summary>
        /// <param name="id">ID of the faceShapeLink to be updated</param>
        /// <param name="updatedFaceShapeLink">Updated faceShapeLink object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedFaceShapeLink"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, FaceShapeLinks updatedFaceShapeLink)
        {
            bool faceShapeLinkUpdated = false;

            if (_context != null)
            {
                FaceShapeLinks currentFaceShapeLink = await _context.FaceShapeLinks.FindAsync(id);

                try
                {
                    if (currentFaceShapeLink != null)
                    {
                        currentFaceShapeLink.LinkName = updatedFaceShapeLink.LinkName;
                        currentFaceShapeLink.LinkUrl = updatedFaceShapeLink.LinkUrl;
                        _context.Entry(currentFaceShapeLink).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        faceShapeLinkUpdated = true;
                    }

                    throw new ResourceNotFoundException("FaceShapeLink not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                FaceShapeLinks currentFaceShapeLink = FaceShapeLinks.FirstOrDefault(fs => fs.Id == id);

                if (currentFaceShapeLink != null)
                {
                    int currentFaceShapeLinkIndex = FaceShapeLinks.FindIndex(c => c.Id == id);
                    FaceShapeLinks[currentFaceShapeLinkIndex] = updatedFaceShapeLink;
                    faceShapeLinkUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("FaceShapeLink not found");
                }
            }

            return faceShapeLinkUpdated;
        }

        /// <summary>
        /// Retrieves a faceShapeLink by ID
        /// </summary>
        /// <param name="id">ID of the faceShapeLink to be retrieved</param>
        /// <returns>FaceShapeLink found or null</returns>
        public async Task<FaceShapeLinks> ReadById(ulong id)
        {
            List<FaceShapeLinks> results;

            if (_context != null)
            {
                results = await _context
                                    .FaceShapeLinks
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = FaceShapeLinks
                            .Where(u => u.Id == id)
                            .ToList();
            }

            if (results.Count < 1)
            {
                return null;
            }

            return results[0];
        }
    }
}
