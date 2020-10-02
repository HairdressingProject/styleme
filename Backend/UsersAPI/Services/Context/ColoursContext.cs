using UsersAPI.Helpers.Exceptions;
using UsersAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UsersAPI.Services.Context
{
    public class ColoursContext : IColoursContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<Colours> Colours { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="colours">Sample list of colours</param>
        public ColoursContext(List<Colours> colours)
        {
            Colours = colours;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public ColoursContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new colour
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique colours, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="colour">Colour to be added</param>
        /// <returns>Colour added</returns>
        public Task<Colours> Add(Colours colour)
        {
            Colours colourAdded = null;

            if (_context != null)
            {
                _context.Colours.Add(colour);
                colourAdded = colour;
            }
            else
            {
                Colours.Add(colour);
                colourAdded = colour;
            }

            return Task.FromResult(colourAdded);
        }

        /// <summary>
        /// Browses colours
        /// </summary>
        /// <param name="limit">Optionally limits the number of colours returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which colours will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 colours
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a colour by 
        ///     <see cref="Colours.ColourName"/> or 
        ///     <see cref="Colours.ColourHash"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<Colours>> Browse(
            string limit = "1000",
            string offset = "0",
            string search = ""
            )
        {
            List<Colours> limitedColours = new List<Colours>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedColours = await _context
                                            .Colours
                                            .Where(
                                            r =>
                                            r.ColourName
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower()) ||
                                            r.ColourHash
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
                        limitedColours = Colours
                                            .Where(
                                            r =>
                                            r.ColourName
                                            .Trim()
                                            .ToLower()
                                            .Contains(
                                                string.IsNullOrWhiteSpace(search) ?
                                                search :
                                                search.Trim().ToLower()) ||
                                            r.ColourHash
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

            return limitedColours;
        }

        /// <summary>
        /// Counts colours
        /// </summary>
        /// <param name="search">
        ///     Optionally only count colours which
        ///     <see cref="Colours.ColourName"/> or
        ///     <see cref="Colours.ColourHash"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>Colours count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchColoursCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchColoursCount = await _context.Colours.Where(
                                                r =>
                                                r.ColourName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    search.Trim().ToLower()) ||
                                                r.ColourHash
                                                .Trim()
                                                .ToLower()
                                                .Contains(search.Trim().ToLower())
                                                ).CountAsync();
                }
                else
                {
                    searchColoursCount = await _context.Colours.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchColoursCount = Colours.Where(
                        c =>
                        c.ColourName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                        c.ColourHash.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchColoursCount = Colours.Count;
                }
            }

            return searchColoursCount;
        }

        /// <summary>
        /// Deletes a colour by ID
        /// </summary>
        /// <param name="id">ID of the colour to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the user with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>Colour deleted</returns>
        public async Task<Colours> Delete(ulong id)
        {
            Colours colour = null;

            if (_context != null)
            {
                colour = await _context.Colours.FindAsync(id);

                if (colour != null)
                {
                    _context.Colours.Remove(colour);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("Colour not found");
                }                               
            }
            else
            {
                colour = Colours.Where(u => u.Id == id).FirstOrDefault();

                if (colour != null)
                {
                    Colours.Remove(colour);
                }
                else
                {
                    throw new ResourceNotFoundException("Colour not found");
                }
            }

            return colour;
        }

        /// <summary>
        /// Updates an existing colour
        /// </summary>
        /// <param name="id">ID of the colour to be updated</param>
        /// <param name="updatedColour">Updated colour object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="updatedColour"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, Colours updatedColour)
        {
            bool colourUpdated = false;

            if (_context != null)
            {
                Colours currentColour = await _context.Colours.FindAsync(id);

                try
                {
                    if (currentColour != null)
                    {
                        currentColour.ColourName = updatedColour.ColourName;
                        currentColour.ColourHash = updatedColour.ColourHash;
                        _context.Entry(currentColour).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        colourUpdated = true;
                    }

                    throw new ResourceNotFoundException("Colour not found");
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                Colours currentFaceShape = Colours.FirstOrDefault(fs => fs.Id == id);

                if (currentFaceShape != null)
                {
                    int currentColourIndex = Colours.FindIndex(c => c.Id == id);
                    Colours[currentColourIndex] = updatedColour;
                    colourUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("Colour not found");
                }
            }

            return colourUpdated;
        }

        /// <summary>
        /// Retrieves a colour by ID
        /// </summary>
        /// <param name="id">ID of the colour to be retrieved</param>
        /// <returns>Colour found or null</returns>
        public async Task<Colours> ReadById(ulong id)
        {
            List<Colours> results;

            if (_context != null)
            {
                results = await _context
                                    .Colours
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = Colours
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
