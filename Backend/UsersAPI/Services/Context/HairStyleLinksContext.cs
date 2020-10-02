using UsersAPI.Helpers.Exceptions;
using UsersAPI.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UsersAPI.Services.Context
{
    public class HairStyleLinksContext : IHairStyleLinksContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<HairStyleLinks> HairStyleLinks { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="hairStyleLinks">Sample list of hairStyleLinks</param>
        public HairStyleLinksContext(List<HairStyleLinks> hairStyleLinks)
        {
            HairStyleLinks = hairStyleLinks;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public HairStyleLinksContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new hairStyleLink
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique hairStyleLinks, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="hairStyleLink">HairStyleLink to be added</param>
        /// <returns>HairStyleLink added</returns>
        public Task<HairStyleLinks> Add(HairStyleLinks hairStyleLink)
        {
            HairStyleLinks hairStyleLinkAdded = null;

            if (_context != null)
            {
                _context.HairStyleLinks.Add(hairStyleLink);
                hairStyleLinkAdded = hairStyleLink;
            }
            else
            {
                HairStyleLinks.Add(hairStyleLink);
                hairStyleLinkAdded = hairStyleLink;
            }

            return Task.FromResult(hairStyleLinkAdded);
        }

        /// <summary>
        /// Browses hairStyleLinks
        /// </summary>
        /// <param name="limit">Optionally limits the number of hairStyleLinks returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which hairStyleLinks will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 hairStyleLinks
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a hairStyleLink by 
        ///     <see cref="HairStyleLinks.LinkName"/> or 
        ///     <see cref="HairStyleLinks.LinkUrl"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<HairStyleLinks>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<HairStyleLinks> limitedHairStyleLinks = new List<HairStyleLinks>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedHairStyleLinks = await _context
                                            .HairStyleLinks
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
                        limitedHairStyleLinks = HairStyleLinks
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

            return limitedHairStyleLinks;
        }

        /// <summary>
        /// Counts hairStyleLinks
        /// </summary>
        /// <param name="search">
        ///     Optionally only count hairStyleLinks which
        ///     <see cref="HairStyleLinks.LinkName"/> or
        ///     <see cref="HairStyleLinks.LinkUrl"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>HairStyleLinks count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchHairStyleLinksCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairStyleLinksCount = await _context.HairStyleLinks.Where(
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
                    searchHairStyleLinksCount = await _context.HairStyleLinks.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairStyleLinksCount = HairStyleLinks.Where(
                        c =>
                        c.LinkName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        c.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchHairStyleLinksCount = HairStyleLinks.Count;
                }
            }

            return searchHairStyleLinksCount;
        }

        /// <summary>
        /// Deletes a hairStyleLink by ID
        /// </summary>
        /// <param name="id">ID of the hairStyleLink to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>HairStyleLink deleted</returns>
        public async Task<HairStyleLinks> Delete(ulong id)
        {
            HairStyleLinks hairStyleLink = null;

            if (_context != null)
            {
                hairStyleLink = await _context.HairStyleLinks.FindAsync(id);

                if (hairStyleLink != null)
                {
                    _context.HairStyleLinks.Remove(hairStyleLink);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("HairStyleLink not found");
                }
            }
            else
            {
                hairStyleLink = HairStyleLinks.Where(u => u.Id == id).FirstOrDefault();

                if (hairStyleLink != null)
                {
                    HairStyleLinks.Remove(hairStyleLink);
                }
                else
                {
                    throw new ResourceNotFoundException("HairStyleLink not found");
                }
            }

            return hairStyleLink;
        }

        /// <summary>
        /// Updates an existing hairStyleLink
        /// </summary>
        /// <param name="id">ID of the hairStyleLink to be updated</param>
        /// <param name="updatedHairStyleLink">Updated hairStyleLink object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedHairStyleLink"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, HairStyleLinks updatedHairStyleLink)
        {
            bool hairStyleLinkUpdated = false;

            if (_context != null)
            {
                HairStyleLinks currentHairStyleLink = await _context.HairStyleLinks.FindAsync(id);

                try
                {
                    if (currentHairStyleLink != null)
                    {
                        currentHairStyleLink.LinkName = updatedHairStyleLink.LinkName;
                        currentHairStyleLink.LinkUrl = updatedHairStyleLink.LinkUrl;
                        _context.Entry(currentHairStyleLink).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        hairStyleLinkUpdated = true;
                    }

                    throw new ResourceNotFoundException("HairStyleLink not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                HairStyleLinks currentHairStyleLink = HairStyleLinks.FirstOrDefault(fs => fs.Id == id);

                if (currentHairStyleLink != null)
                {
                    int currentHairStyleLinkIndex = HairStyleLinks.FindIndex(c => c.Id == id);
                    HairStyleLinks[currentHairStyleLinkIndex] = updatedHairStyleLink;
                    hairStyleLinkUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("HairStyleLink not found");
                }
            }

            return hairStyleLinkUpdated;
        }

        /// <summary>
        /// Retrieves a hairStyleLink by ID
        /// </summary>
        /// <param name="id">ID of the hairStyleLink to be retrieved</param>
        /// <returns>HairStyleLink found or null</returns>
        public async Task<HairStyleLinks> ReadById(ulong id)
        {
            List<HairStyleLinks> results;

            if (_context != null)
            {
                results = await _context
                                    .HairStyleLinks
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = HairStyleLinks
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
