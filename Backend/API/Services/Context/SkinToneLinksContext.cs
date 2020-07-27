using AdminApi.Helpers.Exceptions;
using AdminApi.Models_v2_1;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services.Context
{
    public class SkinToneLinksContext : ISkinToneLinksContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<SkinToneLinks> SkinToneLinks { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="skinToneLinks">Sample list of skinToneLinks</param>
        public SkinToneLinksContext(List<SkinToneLinks> skinToneLinks)
        {
            SkinToneLinks = skinToneLinks;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public SkinToneLinksContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new skinToneLink
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique skinToneLinks, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="skinToneLink">SkinToneLink to be added</param>
        /// <returns>SkinToneLink added</returns>
        public Task<SkinToneLinks> Add(SkinToneLinks skinToneLink)
        {
            SkinToneLinks skinToneLinkAdded = null;

            if (_context != null)
            {
                _context.SkinToneLinks.Add(skinToneLink);
                skinToneLinkAdded = skinToneLink;
            }
            else
            {
                SkinToneLinks.Add(skinToneLink);
                skinToneLinkAdded = skinToneLink;
            }

            return Task.FromResult(skinToneLinkAdded);
        }

        /// <summary>
        /// Browses skinToneLinks
        /// </summary>
        /// <param name="limit">Optionally limits the number of skinToneLinks returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which skinToneLinks will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 skinToneLinks
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a skinToneLink by 
        ///     <see cref="SkinToneLinks.LinkName"/> or 
        ///     <see cref="SkinToneLinks.LinkUrl"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<SkinToneLinks>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<SkinToneLinks> limitedSkinToneLinks = new List<SkinToneLinks>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedSkinToneLinks = await _context
                                            .SkinToneLinks
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
                        limitedSkinToneLinks = SkinToneLinks
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

            return limitedSkinToneLinks;
        }

        /// <summary>
        /// Counts skinToneLinks
        /// </summary>
        /// <param name="search">
        ///     Optionally only count skinToneLinks which
        ///     <see cref="SkinToneLinks.LinkName"/> or
        ///     <see cref="SkinToneLinks.LinkUrl"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>SkinToneLinks count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchSkinToneLinksCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchSkinToneLinksCount = await _context.SkinToneLinks.Where(
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
                    searchSkinToneLinksCount = await _context.SkinToneLinks.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchSkinToneLinksCount = SkinToneLinks.Where(
                        c =>
                        c.LinkName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        c.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchSkinToneLinksCount = SkinToneLinks.Count;
                }
            }

            return searchSkinToneLinksCount;
        }

        /// <summary>
        /// Deletes a skinToneLink by ID
        /// </summary>
        /// <param name="id">ID of the skinToneLink to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>SkinToneLink deleted</returns>
        public async Task<SkinToneLinks> Delete(ulong id)
        {
            SkinToneLinks skinToneLink = null;

            if (_context != null)
            {
                skinToneLink = await _context.SkinToneLinks.FindAsync(id);

                if (skinToneLink != null)
                {
                    _context.SkinToneLinks.Remove(skinToneLink);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("SkinToneLink not found");
                }
            }
            else
            {
                skinToneLink = SkinToneLinks.Where(u => u.Id == id).FirstOrDefault();

                if (skinToneLink != null)
                {
                    SkinToneLinks.Remove(skinToneLink);
                }
                else
                {
                    throw new ResourceNotFoundException("SkinToneLink not found");
                }
            }

            return skinToneLink;
        }

        /// <summary>
        /// Updates an existing skinToneLink
        /// </summary>
        /// <param name="id">ID of the skinToneLink to be updated</param>
        /// <param name="updatedSkinToneLink">Updated skinToneLink object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedSkinToneLink"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, SkinToneLinks updatedSkinToneLink)
        {
            bool skinToneLinkUpdated = false;

            if (_context != null)
            {
                SkinToneLinks currentSkinToneLink = await _context.SkinToneLinks.FindAsync(id);

                try
                {
                    if (currentSkinToneLink != null)
                    {
                        currentSkinToneLink.LinkName = updatedSkinToneLink.LinkName;
                        currentSkinToneLink.LinkUrl = updatedSkinToneLink.LinkUrl;
                        _context.Entry(currentSkinToneLink).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        skinToneLinkUpdated = true;
                    }

                    throw new ResourceNotFoundException("SkinToneLink not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                SkinToneLinks currentSkinToneLink = SkinToneLinks.FirstOrDefault(fs => fs.Id == id);

                if (currentSkinToneLink != null)
                {
                    int currentSkinToneLinkIndex = SkinToneLinks.FindIndex(c => c.Id == id);
                    SkinToneLinks[currentSkinToneLinkIndex] = updatedSkinToneLink;
                    skinToneLinkUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("SkinToneLink not found");
                }
            }

            return skinToneLinkUpdated;
        }

        /// <summary>
        /// Retrieves a skinToneLink by ID
        /// </summary>
        /// <param name="id">ID of the skinToneLink to be retrieved</param>
        /// <returns>SkinToneLink found or null</returns>
        public async Task<SkinToneLinks> ReadById(ulong id)
        {
            List<SkinToneLinks> results;

            if (_context != null)
            {
                results = await _context
                                    .SkinToneLinks
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = SkinToneLinks
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
