using UsersAPI.Helpers.Exceptions;
using UsersAPI.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UsersAPI.Services.Context
{
    public class HairLengthsContext : IHairLengthsContext
    {
        private readonly hairdressing_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<HairLengths> HairLengths { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="hairLengths">Sample list of hairLengths</param>
        public HairLengthsContext(List<HairLengths> hairLengths)
        {
            HairLengths = hairLengths;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public HairLengthsContext(hairdressing_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new hair length
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique hair lengths, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="hairLength">Hair Length to be added</param>
        /// <returns>Hair Length added</returns>
        public Task<HairLengths> Add(HairLengths hairLength)
        {
            HairLengths hairLengthAdded = null;

            if (_context != null)
            {
                _context.HairLengths.Add(hairLength);
                hairLengthAdded = hairLength;
            }
            else
            {
                HairLengths.Add(hairLength);
                hairLengthAdded = hairLength;
            }

            return Task.FromResult(hairLengthAdded);
        }

        /// <summary>
        /// Browses hairLengths
        /// </summary>
        /// <param name="limit">Optionally limits the number of hairLengths returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which hairLengths will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 hairLengths
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a hairLength by 
        ///     <see cref="HairLengths.HairLengthName"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<HairLengths>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<HairLengths> limitedHairLengths = new List<HairLengths>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedHairLengths = await _context
                                            .HairLengths
                                            .Where(
                                            r =>
                                            r.HairLengthName
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
                        limitedHairLengths = HairLengths
                                            .Where(
                                            r =>
                                            r.HairLengthName
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

            return limitedHairLengths;
        }

        /// <summary>
        /// Counts hairLengths
        /// </summary>
        /// <param name="search">
        ///     Optionally only count hairLengths which
        ///     <see cref="HairLengths.HairLengthName"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>HairLengths count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchHairLengthsCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairLengthsCount = await _context.HairLengths.Where(
                                                r =>
                                                r.HairLengthName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    search.Trim().ToLower())
                                                ).CountAsync();
                }
                else
                {
                    searchHairLengthsCount = await _context.HairLengths.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchHairLengthsCount = HairLengths.Where(
                        c =>
                        c.HairLengthName.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchHairLengthsCount = HairLengths.Count;
                }
            }

            return searchHairLengthsCount;
        }

        /// <summary>
        /// Deletes a hairLength by ID
        /// </summary>
        /// <param name="id">ID of the hairLength to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>HairLength deleted</returns>
        public async Task<HairLengths> Delete(ulong id)
        {
            HairLengths hairLength = null;

            if (_context != null)
            {
                hairLength = await _context.HairLengths.FindAsync(id);

                if (hairLength != null)
                {
                    _context.HairLengths.Remove(hairLength);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("HairLength not found");
                }
            }
            else
            {
                hairLength = HairLengths.Where(u => u.Id == id).FirstOrDefault();

                if (hairLength != null)
                {
                    HairLengths.Remove(hairLength);
                }
                else
                {
                    throw new ResourceNotFoundException("HairLength not found");
                }
            }

            return hairLength;
        }

        /// <summary>
        /// Updates an existing hairLength
        /// </summary>
        /// <param name="id">ID of the hairLength to be updated</param>
        /// <param name="updatedHairLength">Updated hairLength object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedHairLength"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, HairLengths updatedHairLength)
        {
            bool hairLengthUpdated = false;

            if (_context != null)
            {
                HairLengths currentHairLength = await _context.HairLengths.FindAsync(id);

                try
                {
                    if (currentHairLength != null)
                    {
                        currentHairLength.HairLengthName = updatedHairLength.HairLengthName;
                        _context.Entry(currentHairLength).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        hairLengthUpdated = true;
                    }

                    throw new ResourceNotFoundException("HairLength not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                HairLengths currentFaceShape = HairLengths.FirstOrDefault(hl => hl.Id == id);

                if (currentFaceShape != null)
                {
                    int currentHairLengthIndex = HairLengths.FindIndex(c => c.Id == id);
                    HairLengths[currentHairLengthIndex] = updatedHairLength;
                    hairLengthUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("HairLength not found");
                }
            }

            return hairLengthUpdated;
        }

        /// <summary>
        /// Retrieves a hairLength by ID
        /// </summary>
        /// <param name="id">ID of the hairLength to be retrieved</param>
        /// <returns>HairLength found or null</returns>
        public async Task<HairLengths> ReadById(ulong id)
        {
            List<HairLengths> results;

            if (_context != null)
            {
                results = await _context
                                    .HairLengths
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = HairLengths
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
