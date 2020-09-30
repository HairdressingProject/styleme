using AdminApi.Helpers.Exceptions;
using AdminApi.Models_v2_1;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services.Context
{
    public class SkinTonesContext : ISkinTonesContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<SkinTones> SkinTones { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="skinTones">Sample list of skinTones</param>
        public SkinTonesContext(List<SkinTones> skinTones)
        {
            SkinTones = skinTones;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for skin tones</param>
        public SkinTonesContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new skinTone
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique skinTones, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="skinTone">SkinTone to be added</param>
        /// <returns>SkinTone added</returns>
        public Task<SkinTones> Add(SkinTones skinTone)
        {
            SkinTones skinToneAdded = null;

            if (_context != null)
            {
                _context.SkinTones.Add(skinTone);
                skinToneAdded = skinTone;
            }
            else
            {
                SkinTones.Add(skinTone);
                skinToneAdded = skinTone;
            }

            return Task.FromResult(skinToneAdded);
        }

        /// <summary>
        /// Browses skinTones
        /// </summary>
        /// <param name="limit">Optionally limits the number of skinTones returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which skinTones will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 skinTones
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a skinTone by 
        ///     <see cref="SkinTones.SkinToneName"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<SkinTones>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<SkinTones> limitedSkinTones = new List<SkinTones>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedSkinTones = await _context
                                            .SkinTones
                                            .Where(
                                            r =>
                                            r.SkinToneName
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
                        limitedSkinTones = SkinTones
                                            .Where(
                                            r =>
                                            r.SkinToneName
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

            return limitedSkinTones;
        }

        /// <summary>
        /// Counts skinTones
        /// </summary>
        /// <param name="search">
        ///     Optionally only count skinTones which
        ///     <see cref="SkinTones.SkinToneName"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>SkinTones count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchSkinTonesCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchSkinTonesCount = await _context.SkinTones.Where(
                                                r =>
                                                r.SkinToneName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    search.Trim().ToLower())
                                                ).CountAsync();
                }
                else
                {
                    searchSkinTonesCount = await _context.SkinTones.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchSkinTonesCount = SkinTones.Where(
                        c =>
                        c.SkinToneName.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchSkinTonesCount = SkinTones.Count;
                }
            }

            return searchSkinTonesCount;
        }

        /// <summary>
        /// Deletes a skinTone by ID
        /// </summary>
        /// <param name="id">ID of the skinTone to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the skin tone with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>SkinTone deleted</returns>
        public async Task<SkinTones> Delete(ulong id)
        {
            SkinTones skinTone = null;

            if (_context != null)
            {
                skinTone = await _context.SkinTones.FindAsync(id);

                if (skinTone != null)
                {
                    _context.SkinTones.Remove(skinTone);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("SkinTone not found");
                }
            }
            else
            {
                skinTone = SkinTones.Where(u => u.Id == id).FirstOrDefault();

                if (skinTone != null)
                {
                    SkinTones.Remove(skinTone);
                }
                else
                {
                    throw new ResourceNotFoundException("SkinTone not found");
                }
            }

            return skinTone;
        }

        /// <summary>
        /// Updates an existing skinTone
        /// </summary>
        /// <param name="id">ID of the skinTone to be updated</param>
        /// <param name="updatedSkinTone">Updated skinTone object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedSkinTone"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, SkinTones updatedSkinTone)
        {
            bool skinToneUpdated = false;

            if (_context != null)
            {
                SkinTones currentSkinTone = await _context.SkinTones.FindAsync(id);

                try
                {
                    if (currentSkinTone != null)
                    {
                        currentSkinTone.SkinToneName = updatedSkinTone.SkinToneName;
                        _context.Entry(currentSkinTone).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        skinToneUpdated = true;
                    }

                    throw new ResourceNotFoundException("SkinTone not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                SkinTones currentFaceShape = SkinTones.FirstOrDefault(fs => fs.Id == id);

                if (currentFaceShape != null)
                {
                    int currentSkinToneIndex = SkinTones.FindIndex(c => c.Id == id);
                    SkinTones[currentSkinToneIndex] = updatedSkinTone;
                    skinToneUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("SkinTone not found");
                }
            }

            return skinToneUpdated;
        }

        /// <summary>
        /// Retrieves a skinTone by ID
        /// </summary>
        /// <param name="id">ID of the skinTone to be retrieved</param>
        /// <returns>SkinTone found or null</returns>
        public async Task<SkinTones> ReadById(ulong id)
        {
            List<SkinTones> results;

            if (_context != null)
            {
                results = await _context
                                    .SkinTones
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = SkinTones
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
