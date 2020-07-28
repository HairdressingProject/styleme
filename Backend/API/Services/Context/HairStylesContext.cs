using AdminApi.Helpers.Exceptions;
using AdminApi.Models_v2_1;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services.Context
{
    public class HairStylesContext : IHairStylesContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<HairStyles> HairStyles { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="hairStyles">Sample list of HairStyles</param>
        public HairStylesContext(List<HairStyles> hairStyles)
        {
            HairStyles = hairStyles;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for hair styles</param>
        public HairStylesContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new hair style
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique hair styles, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="hairStyle">hair style to be added</param>
        /// <returns>hair style added</returns>
        public Task<HairStyles> Add(HairStyles hairStyle)
        {
            HairStyles hairStyleAdded = null;

            if (_context != null)
            {
                _context.HairStyles.Add(hairStyle);
                hairStyleAdded = hairStyle;
            }
            else
            {
                HairStyles.Add(hairStyle);
                hairStyleAdded = hairStyle;
            }

            return Task.FromResult(hairStyleAdded);
        }

        /// <summary>
        /// Browses HairStyles
        /// </summary>
        /// <param name="limit">Optionally limits the number of HairStyles returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which HairStyles will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 HairStyles
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a hairStyle by 
        ///     <see cref="HairStyles.HairStyleName"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<HairStyles>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<HairStyles> limitedHairStyles = new List<HairStyles>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedHairStyles = await _context
                                            .HairStyles
                                            .Where(
                                            r =>
                                            r.HairStyleName
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower())
                                            )
                                            .ToListAsync();
                    }
                    else
                    {
                        limitedHairStyles = HairStyles
                                            .Where(
                                            r =>
                                            r.HairStyleName
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower())
                                            )
                                            .ToList();
                    }
                }
            }

            return limitedHairStyles;
        }

        /// <summary>
        /// Counts HairStyles
        /// </summary>
        /// <param name="search">
        ///     Optionally only count HairStyles which
        ///     <see cref="HairStyles.HairStyleName"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>HairStyles count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchHairStylesCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairStylesCount = await _context.HairStyles.Where(
                                                r =>
                                                r.HairStyleName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    search.Trim().ToLower())
                                                ).CountAsync();
                }
                else
                {
                    searchHairStylesCount = await _context.HairStyles.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairStylesCount = HairStyles.Where(
                        c =>
                        c.HairStyleName.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchHairStylesCount = HairStyles.Count;
                }
            }

            return searchHairStylesCount;
        }

        /// <summary>
        /// Deletes a hairStyle by ID
        /// </summary>
        /// <param name="id">ID of the hairStyle to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the hair style with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>HairStyle deleted</returns>
        public async Task<HairStyles> Delete(ulong id)
        {
            HairStyles hairStyle = null;

            if (_context != null)
            {
                hairStyle = await _context.HairStyles.FindAsync(id);

                if (hairStyle != null)
                {
                    _context.HairStyles.Remove(hairStyle);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("HairStyle not found");
                }
            }
            else
            {
                hairStyle = HairStyles.Where(u => u.Id == id).FirstOrDefault();

                if (hairStyle != null)
                {
                    HairStyles.Remove(hairStyle);
                }
                else
                {
                    throw new ResourceNotFoundException("HairStyle not found");
                }
            }

            return hairStyle;
        }

        /// <summary>
        /// Updates an existing hairStyle
        /// </summary>
        /// <param name="id">ID of the hairStyle to be updated</param>
        /// <param name="updatedHairStyle">Updated hairStyle object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedHairStyle"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, HairStyles updatedHairStyle)
        {
            bool hairStyleUpdated = false;

            if (_context != null)
            {
                HairStyles currentHairStyle = await _context.HairStyles.FindAsync(id);

                try
                {
                    if (currentHairStyle != null)
                    {
                        currentHairStyle.HairStyleName = updatedHairStyle.HairStyleName;
                        _context.Entry(currentHairStyle).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        hairStyleUpdated = true;
                    }

                    throw new ResourceNotFoundException("HairStyle not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                HairStyles currentHairStyle = HairStyles.FirstOrDefault(hl => hl.Id == id);

                if (currentHairStyle != null)
                {
                    int currentHairStyleIndex = HairStyles.FindIndex(c => c.Id == id);
                    HairStyles[currentHairStyleIndex] = updatedHairStyle;
                    hairStyleUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("HairStyle not found");
                }
            }

            return hairStyleUpdated;
        }

        /// <summary>
        /// Retrieves a hairStyle by ID
        /// </summary>
        /// <param name="id">ID of the hairStyle to be retrieved</param>
        /// <returns>HairStyle found or null</returns>
        public async Task<HairStyles> ReadById(ulong id)
        {
            List<HairStyles> results;

            if (_context != null)
            {
                results = await _context
                                    .HairStyles
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = HairStyles
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
