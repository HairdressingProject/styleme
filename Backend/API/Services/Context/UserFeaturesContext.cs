using AdminApi.Helpers;
using AdminApi.Helpers.Exceptions;
using AdminApi.Models_v2_1;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services.Context
{
    public class UserFeaturesContext : IUserFeaturesContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<UserFeatures> UserFeatures { get; set; }
        public List<Users> Users { get; set; }
        public List<FaceShapes> FaceShapes { get; set; }
        public List<Colours> HairColours { get; set; }
        public List<HairLengths> HairLengths { get; set; }
        public List<HairStyles> HairStyles { get; set; }
        public List<SkinTones> SkinTones { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="userFeatures">Sample list of userFeatures</param>
        public UserFeaturesContext(
            List<UserFeatures> userFeatures,
            List<Users> users,
            List<FaceShapes> faceShapes,
            List<Colours> hairColours,
            List<HairLengths> hairLengths,
            List<HairStyles> hairStyles,
            List<SkinTones> skinTones
            )
        {
            UserFeatures = userFeatures;
            Users = users;
            FaceShapes = faceShapes;
            HairColours = hairColours;
            HairLengths = hairLengths;
            HairStyles = hairStyles;
            SkinTones = skinTones;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for skin tones</param>
        public UserFeaturesContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new userFeature
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique userFeatures, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="userFeature">SkinTone to be added</param>
        /// <returns>User feature added</returns>
        public async Task<UserFeatures> Add(UserFeatures userFeature)
        {
            UserFeatures userFeatureAdded = null;
            var errors = await CheckExistingResources(userFeature);

            if (!errors.Item1)
            {
                throw new ResourceNotFoundException(
                    $"The corresponding {errors.Item2.GetType().Name} was not found"
                    );
            }

            if (_context != null)
            {
                _context.UserFeatures.Add(userFeature);
                await _context.SaveChangesAsync();
                userFeatureAdded = await _context.UserFeatures.FindAsync(userFeature.Id);
            }
            else
            {
                UserFeatures.Add(userFeature);
                userFeatureAdded = userFeature;
            }

            return userFeatureAdded;
        }

        /// <summary>
        /// Browses userFeatures
        /// </summary>
        /// <param name="limit">Optionally limits the number of userFeatures returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which userFeatures will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 userFeatures
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a userFeature by 
        ///     <see cref="Users.UserName"/> or
        ///     <see cref="Users.UserEmail"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<UserFeatures>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<UserFeatures> limitedUserFeatures = new List<UserFeatures>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedUserFeatures = await _context
                                                    .UserFeatures
                                                    .Include(uf => uf.User)
                                                    .Where(
                                                        uf =>
                                                            uf.User.UserName.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                            ||
                                                            uf.User.UserEmail.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                            )
                                                    .Include(uf => uf.HairColour)
                                                    .Include(uf => uf.HairStyle)
                                                    .Include(uf => uf.HairLength)
                                                    .Include(uf => uf.SkinTone)
                                                    .Include(uf => uf.FaceShape)
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                        limitedUserFeatures.ForEach(uf =>
                        {
                            uf.User = uf.User.WithoutPassword();
                        });
                    }
                    else
                    {
                        limitedUserFeatures = IncludeProperties(UserFeatures)
                                                  .Where(
                                                        uf =>
                                                            uf.User
                                                            .UserName
                                                            .Trim()
                                                            .ToLower()
                                                            .Contains(
                                                                string.IsNullOrWhiteSpace(search) ? 
                                                                search : 
                                                                search.Trim().ToLower())
                                                            ||
                                                            uf.User
                                                            .UserEmail
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
                else
                {
                    throw new InvalidQueriesException("Invalid queries");
                }
            }
            else
            {
                if (_context != null)
                {
                    limitedUserFeatures = await _context.UserFeatures
                                               .Include(uf => uf.User)
                                               .Include(uf => uf.HairColour)
                                               .Include(uf => uf.HairStyle)
                                               .Include(uf => uf.HairLength)
                                               .Include(uf => uf.SkinTone)
                                               .Include(uf => uf.FaceShape)
                                               .ToListAsync();
                }
                else
                {
                    limitedUserFeatures = IncludeProperties(UserFeatures).ToList();
                }
                

                if (limitedUserFeatures.Count > 0)
                {
                    // remove user passwords
                    limitedUserFeatures.ForEach(uf =>
                    {
                        uf.User = uf.User.WithoutPassword();
                    });
                }
            }           

            return limitedUserFeatures;
        }

        /// <summary>
        /// Counts userFeatures
        /// </summary>
        /// <param name="search">
        ///     Optionally only count userFeatures which
        ///     <see cref="Users.UserEmail"/> or
        ///     <see cref="Users.UserName"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>UserFeatures count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchUserFeaturesCount = 0;

            if (!string.IsNullOrWhiteSpace(search))
            {
                if (_context != null)
                {
                    searchUserFeaturesCount = await _context
                                                .UserFeatures
                                                .Include(uf => uf.User)
                                                .Where(
                                                        uf =>
                                                            uf.User
                                                            .UserName
                                                            .Trim()
                                                            .ToLower()
                                                            .Contains(search.Trim().ToLower())
                                                            ||
                                                            uf.User
                                                            .UserEmail
                                                            .Trim()
                                                            .ToLower()
                                                            .Contains(search.Trim().ToLower())
                                                        )
                                                .CountAsync();
                }
                else
                {
                    searchUserFeaturesCount = IncludeProperties(UserFeatures)
                                                .Where(
                                                        uf =>
                                                            uf.User
                                                            .UserName
                                                            .Trim()
                                                            .ToLower()
                                                            .Contains(search.Trim().ToLower())
                                                            ||
                                                            uf.User
                                                            .UserEmail
                                                            .Trim()
                                                            .ToLower()
                                                            .Contains(search.Trim().ToLower())
                                                        )
                                                .Count();
                }
            }
            else
            {
                if (_context != null)
                {
                    searchUserFeaturesCount = await _context.UserFeatures.CountAsync();
                }
                else
                {
                    searchUserFeaturesCount = UserFeatures.Count;
                }
            }

            return searchUserFeaturesCount;
        }

        /// <summary>
        /// Deletes a userFeature by ID
        /// </summary>
        /// <param name="id">ID of the userFeature to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user feature with the corresponding <paramref name="id"/> is not found
        /// </exception>
        /// <returns>User feature deleted</returns>
        public async Task<UserFeatures> Delete(ulong id)
        {
            UserFeatures userFeature = null;

            if (_context != null)
            {
                userFeature = await _context.UserFeatures.FindAsync(id);

                if (userFeature != null)
                {
                    _context.UserFeatures.Remove(userFeature);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("User feature not found");
                }
            }
            else
            {
                userFeature = UserFeatures.Where(u => u.Id == id).FirstOrDefault();

                if (userFeature != null)
                {
                    UserFeatures.Remove(userFeature);
                }
                else
                {
                    throw new ResourceNotFoundException("User feature not found");
                }
            }

            return userFeature;
        }

        /// <summary>
        /// Updates an existing userFeature
        /// </summary>
        /// <param name="id">ID of the userFeature to be updated</param>
        /// <param name="updatedUserFeature">Updated userFeature object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <paramref name="updatedUserFeature"/> or any of its properties are not found
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, UserFeatures updatedUserFeature)
        {
            bool userFeatureUpdated = false;

            // Check existing resources
            var errors = await CheckExistingResources(updatedUserFeature);

            if (!errors.Item1)
            {
                throw new ResourceNotFoundException($"Related {errors.Item2.GetType().Name} does not exist");
            }

            UserFeatures uf;

            if (_context != null)
            {
                uf = await _context.UserFeatures.FindAsync(id);

                try
                {
                    if (uf != null)
                    {
                        uf.UserId = updatedUserFeature.UserId;
                        uf.FaceShapeId = updatedUserFeature.FaceShapeId;
                        uf.SkinToneId = updatedUserFeature.SkinToneId;
                        uf.HairStyleId = updatedUserFeature.HairStyleId;
                        uf.HairLengthId = updatedUserFeature.HairLengthId;
                        uf.HairColourId = updatedUserFeature.HairColourId;
                        _context.Entry(uf).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        userFeatureUpdated = true;
                    }
                    else
                    {
                        throw new ResourceNotFoundException("User feature not found");
                    }
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                uf = UserFeatures.FirstOrDefault(u => u.Id == id);
                int ufIndex = UserFeatures.IndexOf(uf);

                if (uf != null)
                {
                    uf.UserId = updatedUserFeature.UserId;
                    uf.FaceShapeId = updatedUserFeature.FaceShapeId;
                    uf.SkinToneId = updatedUserFeature.SkinToneId;
                    uf.HairStyleId = updatedUserFeature.HairStyleId;
                    uf.HairLengthId = updatedUserFeature.HairLengthId;
                    uf.HairColourId = updatedUserFeature.HairColourId;

                    UserFeatures[ufIndex] = uf;
                }
                else
                {
                    throw new ResourceNotFoundException("User feature not found");
                }
            }            

            return userFeatureUpdated;
        }

        /// <summary>
        /// Retrieves a userFeature by ID
        /// </summary>
        /// <param name="id">ID of the userFeature to be retrieved</param>
        /// <returns>User feature found or null</returns>
        public async Task<UserFeatures> ReadById(ulong id)
        {
            List<UserFeatures> results;

            if (_context != null)
            {
                results = await _context
                                    .UserFeatures
                                    .Where(u => u.Id == id)
                                    .Include(uf => uf.User)
                                    .ToListAsync();
            }
            else
            {
                results = IncludeProperties(UserFeatures)
                                .Where(u => u.Id == id)
                                .ToList();
            }

            if (results.Count < 1)
            {
                return null;
            }

            return results
                    .Select(uf =>
                            {
                                uf.User = uf.User.WithoutPassword();
                                return uf;
                            })
                    .FirstOrDefault();
        }

        /// <summary>
        /// Checks whether the specified <paramref name="resourceType"/> 
        /// present in <paramref name="userFeatures"/>
        /// exists in the database
        /// </summary>
        /// <param name="userFeatures">
        /// </param>
        /// <param name="resourceType">
        ///     <see cref="ResourceTypes"/> to be verified
        /// </param>
        /// <returns></returns>
        private async Task<bool> CorrespondingResourceExists(UserFeatures userFeatures, ResourceTypes resourceType)
        {
            switch (resourceType)
            {
                case ResourceTypes.USERS:
                    return _context != null ?
                        await _context.Users.AnyAsync(u => u.Id == userFeatures.UserId) :
                        Users.Any(u => u.Id == userFeatures.UserId);

                case ResourceTypes.FACE_SHAPES:
                    return _context != null ?
                        await _context.FaceShapes.AnyAsync(f => f.Id == userFeatures.FaceShapeId) :
                        FaceShapes.Any(fs => fs.Id == userFeatures.FaceShapeId);

                case ResourceTypes.SKIN_TONES:
                    return _context != null ?
                        await _context.SkinTones.AnyAsync(f => f.Id == userFeatures.SkinToneId) :
                        SkinTones.Any(st => st.Id == userFeatures.SkinToneId);

                case ResourceTypes.HAIR_STYLES:
                    return _context != null ?
                        await _context.HairStyles.AnyAsync(h => h.Id == userFeatures.HairStyleId) :
                        HairStyles.Any(hs => hs.Id == userFeatures.HairStyleId);

                case ResourceTypes.HAIR_LENGTHS:
                    return _context != null ?
                        await _context.HairLengths.AnyAsync(h => h.Id == userFeatures.HairLengthId) :
                        HairLengths.Any(hl => hl.Id == userFeatures.HairLengthId);

                case ResourceTypes.COLOURS:
                    return _context != null ?
                        await _context.Colours.AnyAsync(c => c.Id == userFeatures.HairColourId) :
                        HairColours.Any(hc => hc.Id == userFeatures.HairColourId);

                default:
                    return false;
            }
        }

        /// <summary>
        /// Convenience method related to 
        /// <see cref="CorrespondingResourceExists(Models_v2_1.UserFeatures, ResourceTypes)"/>
        /// that determines which resource is missing from <paramref name="userFeatures"/>
        /// </summary>
        /// <param name="userFeatures"></param>
        /// <returns>Whether there is a resource missing and which type it belongs to</returns>
        private async Task<(bool, ResourceTypes)> CheckExistingResources(UserFeatures userFeatures)
        {
            // Check existing user
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.USERS))
            {
                return (false, ResourceTypes.USERS);
            }

            // Check existing face shape
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.FACE_SHAPES))
            {
                return (false, ResourceTypes.FACE_SHAPES);
            }

            // Check existing skin tone
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.SKIN_TONES))
            {
                return (false, ResourceTypes.SKIN_TONES);
            }

            // Check existing hair style
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.HAIR_STYLES))
            {
                return (false, ResourceTypes.HAIR_STYLES);
            }

            // Check existing hair length
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.HAIR_LENGTHS))
            {
                return (false, ResourceTypes.HAIR_LENGTHS);
            }

            // Check existing hair colour
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.COLOURS))
            {
                return (false, ResourceTypes.COLOURS);
            }

            return (true, ResourceTypes.USER_FEATURES);
        }

        /// <summary>
        /// Maps all related properties to <paramref name="userFeatures"/>
        /// </summary>
        /// <param name="userFeatures">User features to be mapped</param>
        /// <returns>Iterable collection of mapped user features</returns>
        public IEnumerable<UserFeatures> IncludeProperties(List<UserFeatures> userFeatures)
        {
            return userFeatures
                .Select(
                        uf =>
                        {
                            uf.User = Users.FirstOrDefault(u => u.Id == uf.UserId);
                            return uf;
                        }
                    )
                    .Select(
                        uf =>
                        {
                            uf.FaceShape = FaceShapes.FirstOrDefault(
                                fs => fs.Id == uf.FaceShapeId
                                );
                            return uf;
                        }
                    )
                    .Select(
                        uf =>
                        {
                            uf.HairColour = HairColours.FirstOrDefault(
                                c => c.Id == uf.HairColourId
                                );
                            return uf;
                        }
                    )
                    .Select(
                        uf =>
                        {
                            uf.SkinTone = SkinTones.FirstOrDefault(
                                st => st.Id == uf.SkinToneId
                                );
                            return uf;
                        }
                    )
                    .Select(
                        uf =>
                        {
                            uf.HairLength = HairLengths.FirstOrDefault(
                                hl => hl.Id == uf.HairLengthId
                                );
                            return uf;
                        }
                    )
                    .Select(
                        uf =>
                        {
                            uf.HairStyle = HairStyles.FirstOrDefault(
                                hs => hs.Id == uf.HairStyleId
                                );
                            return uf;
                        }
                    );
        }
    }
}
