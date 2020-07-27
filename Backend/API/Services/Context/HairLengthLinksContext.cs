using AdminApi.Helpers.Exceptions;
using AdminApi.Models_v2_1;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services.Context
{
    public class HairLengthLinksContext : IHairLengthLinksContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<HairLengthLinks> HairLengthLinks { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="hairLengthLinks">Sample list of hairLengthLinks</param>
        public HairLengthLinksContext(List<HairLengthLinks> hairLengthLinks)
        {
            HairLengthLinks = hairLengthLinks;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public HairLengthLinksContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new hairLengthLink
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique hairLengthLinks, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="hairLengthLink">HairLengthLink to be added</param>
        /// <returns>HairLengthLink added</returns>
        public Task<HairLengthLinks> Add(HairLengthLinks hairLengthLink)
        {
            HairLengthLinks hairLengthLinkAdded = null;

            if (_context != null)
            {
                _context.HairLengthLinks.Add(hairLengthLink);
                hairLengthLinkAdded = hairLengthLink;
            }
            else
            {
                HairLengthLinks.Add(hairLengthLink);
                hairLengthLinkAdded = hairLengthLink;
            }

            return Task.FromResult(hairLengthLinkAdded);
        }

        /// <summary>
        /// Browses hairLengthLinks
        /// </summary>
        /// <param name="limit">Optionally limits the number of hairLengthLinks returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which hairLengthLinks will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 hairLengthLinks
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a hairLengthLink by 
        ///     <see cref="HairLengthLinks.LinkName"/> or 
        ///     <see cref="HairLengthLinks.LinkUrl"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<HairLengthLinks>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<HairLengthLinks> limitedHairLengthLinks = new List<HairLengthLinks>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedHairLengthLinks = await _context
                                            .HairLengthLinks
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
                        limitedHairLengthLinks = HairLengthLinks
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

            return limitedHairLengthLinks;
        }

        /// <summary>
        /// Counts hairLengthLinks
        /// </summary>
        /// <param name="search">
        ///     Optionally only count hairLengthLinks which
        ///     <see cref="HairLengthLinks.LinkName"/> or
        ///     <see cref="HairLengthLinks.LinkUrl"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>HairLengthLinks count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchHairLengthLinksCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairLengthLinksCount = await _context.HairLengthLinks.Where(
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
                    searchHairLengthLinksCount = await _context.HairLengthLinks.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairLengthLinksCount = HairLengthLinks.Where(
                        c =>
                        c.LinkName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        c.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchHairLengthLinksCount = HairLengthLinks.Count;
                }
            }

            return searchHairLengthLinksCount;
        }

        /// <summary>
        /// Deletes a hairLengthLink by ID
        /// </summary>
        /// <param name="id">ID of the hairLengthLink to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>HairLengthLink deleted</returns>
        public async Task<HairLengthLinks> Delete(ulong id)
        {
            HairLengthLinks hairLengthLink = null;

            if (_context != null)
            {
                hairLengthLink = await _context.HairLengthLinks.FindAsync(id);

                if (hairLengthLink != null)
                {
                    _context.HairLengthLinks.Remove(hairLengthLink);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("HairLengthLink not found");
                }
            }
            else
            {
                hairLengthLink = HairLengthLinks.Where(u => u.Id == id).FirstOrDefault();

                if (hairLengthLink != null)
                {
                    HairLengthLinks.Remove(hairLengthLink);
                }
                else
                {
                    throw new ResourceNotFoundException("HairLengthLink not found");
                }
            }

            return hairLengthLink;
        }

        /// <summary>
        /// Updates an existing hairLengthLink
        /// </summary>
        /// <param name="id">ID of the hairLengthLink to be updated</param>
        /// <param name="updatedHairLengthLink">Updated hairLengthLink object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedHairLengthLink"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, HairLengthLinks updatedHairLengthLink)
        {
            bool hairLengthLinkUpdated = false;

            if (_context != null)
            {
                HairLengthLinks currentHairLengthLink = await _context.HairLengthLinks.FindAsync(id);

                try
                {
                    if (currentHairLengthLink != null)
                    {
                        currentHairLengthLink.LinkName = updatedHairLengthLink.LinkName;
                        currentHairLengthLink.LinkUrl = updatedHairLengthLink.LinkUrl;
                        _context.Entry(currentHairLengthLink).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        hairLengthLinkUpdated = true;
                    }

                    throw new ResourceNotFoundException("HairLengthLink not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                HairLengthLinks currentHairLengthLink = HairLengthLinks.FirstOrDefault(fs => fs.Id == id);

                if (currentHairLengthLink != null)
                {
                    int currentHairLengthLinkIndex = HairLengthLinks.FindIndex(c => c.Id == id);
                    HairLengthLinks[currentHairLengthLinkIndex] = updatedHairLengthLink;
                    hairLengthLinkUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("HairLengthLink not found");
                }
            }

            return hairLengthLinkUpdated;
        }

        /// <summary>
        /// Retrieves a hairLengthLink by ID
        /// </summary>
        /// <param name="id">ID of the hairLengthLink to be retrieved</param>
        /// <returns>HairLengthLink found or null</returns>
        public async Task<HairLengthLinks> ReadById(ulong id)
        {
            List<HairLengthLinks> results;

            if (_context != null)
            {
                results = await _context
                                    .HairLengthLinks
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = HairLengthLinks
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
