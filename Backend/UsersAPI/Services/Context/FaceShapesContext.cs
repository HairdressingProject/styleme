using UsersAPI.Helpers.Exceptions;
using UsersAPI.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UsersAPI.Services.Context
{
    public class FaceShapesContext : IFaceShapesContext
    {
        private readonly hair_project_dbContext _context;
        private readonly IAuthenticationService _authenticationService;
        public List<FaceShapes> FaceShapes { get; set; }

        /// <summary>
        /// Constructor for testing purposes
        /// </summary>
        /// <param name="faceShapes">Sample list of faceShapes</param>
        public FaceShapesContext(List<FaceShapes> faceShapes)
        {
            FaceShapes = faceShapes;
        }

        /// <summary>
        /// Constructor to be added to the dependency injection container
        /// </summary>
        /// <param name="context">EF's database context</param>
        /// <param name="authenticationService">Authentication service for users</param>
        public FaceShapesContext(hair_project_dbContext context, IAuthenticationService authenticationService)
        {
            _context = context;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Adds a new face shape
        /// <para>
        ///     NOTE: Currently this method is not restricted to unique face shapes, so the operation always succeeds
        /// </para>
        /// </summary>
        /// <param name="faceShape">Face shape to be added</param>
        /// <returns>Face shape added</returns>
        public Task<FaceShapes> Add(FaceShapes faceShape)
        {
            FaceShapes faceShapeAdded = null;

            if (_context != null)
            {
                _context.FaceShapes.Add(faceShape);
                faceShapeAdded = faceShape;
            }
            else
            {
                FaceShapes.Add(faceShape);
                faceShapeAdded = faceShape;
            }

            return Task.FromResult(faceShapeAdded);
        }

        /// <summary>
        /// Browses face shapes
        /// </summary>
        /// <param name="limit">Optionally limits the number of face shapes returned</param>
        /// <param name="offset">
        ///     Optionally offsets the position from which face shapes will be counted
        /// <para>
        ///     Example: <code>offset = 5</code> ignores the first 5 face shapes
        /// </para>
        /// </param>
        /// <param name="search">
        ///     Optionally searches for a face shape by 
        ///     <see cref="FaceShapes.ShapeName"/>
        ///     (case insensitive)
        /// </param>
        /// <returns></returns>
        public async Task<List<FaceShapes>> Browse(
            string limit = "1000", 
            string offset = "0", 
            string search = ""
            )
        {
            List<FaceShapes> limitedFaceShapes = new List<FaceShapes>();

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    if (_context != null)
                    {
                        limitedFaceShapes = await _context
                                                    .FaceShapes
                                                    .Where(
                                                    r =>
                                                    r.ShapeName.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                    )
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();
                    }
                    else
                    {
                        limitedFaceShapes = FaceShapes
                                                .Where(
                                                r =>
                                                r.ShapeName
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

            return limitedFaceShapes;
        }

        /// <summary>
        /// Counts face shapes
        /// </summary>
        /// <param name="search">
        ///     Optionally only count face shapes which
        ///     <see cref="FaceShapes.ShapeName"/>
        ///     match this query
        ///     (case insensitive)
        /// </param>
        /// <returns>Face shapes count</returns>
        public async Task<int> Count(string search = null)
        {
            int searchFaceShapesCount = 0;

            if (_context != null)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchFaceShapesCount = await _context.FaceShapes.Where(
                                                r =>
                                                r.ShapeName
                                                .Trim()
                                                .ToLower()
                                                .Contains(
                                                    search.Trim().ToLower())
                                                ).CountAsync();
                }
                else
                {
                    searchFaceShapesCount = await _context.FaceShapes.CountAsync();
                }
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    searchFaceShapesCount = FaceShapes.Where(
                        fs =>
                        fs.ShapeName.Trim().ToLower().Contains(search.Trim().ToLower())
                    )
                    .Count();
                }
                else
                {
                    searchFaceShapesCount = FaceShapes.Count;
                }
            }

            return searchFaceShapesCount;
        }

        /// <summary>
        /// Deletes a face shape by ID
        /// </summary>
        /// <param name="id">ID of the face shape to be deleted</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if the face shape with the corresponding <seealso cref="id"/> is not found
        /// </exception>
        /// <returns>Face shape deleted</returns>
        public async Task<FaceShapes> Delete(ulong id)
        {
            FaceShapes faceShape = null;

            if (_context != null)
            {
                faceShape = await _context.FaceShapes.FindAsync(id);

                if (faceShape != null)
                {
                    _context.FaceShapes.Remove(faceShape);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    throw new ResourceNotFoundException("Face shape not found");
                }                
            }
            else
            {
                faceShape = FaceShapes.Where(u => u.Id == id).FirstOrDefault();

                if (faceShape != null)
                {
                    FaceShapes.Remove(faceShape);
                }
                else
                {
                    throw new ResourceNotFoundException("Face shape not found");
                }
            }

            return faceShape;
        }

        /// <summary>
        /// Updates an existing face shape
        /// </summary>
        /// <param name="id">ID of the face shape to be updated</param>
        /// <param name="faceShape">Updated face shape object</param>
        /// <exception cref="ResourceNotFoundException">
        ///     Thrown if <seealso cref="faceShape"/> does not exist
        /// </exception>
        /// <exception cref="DbUpdateConcurrencyException">
        /// </exception>
        /// <returns>Result of the operation</returns>
        public async Task<bool> Edit(ulong id, FaceShapes faceShape)
        {
            bool faceShapeUpdated = false;

            if (_context != null)
            {
                FaceShapes currentFaceShape = await _context.FaceShapes.FindAsync(id);

                try
                {
                    if (currentFaceShape != null)
                    {
                        currentFaceShape.ShapeName = faceShape.ShapeName;
                        _context.Entry(currentFaceShape).State = EntityState.Modified;
                        await _context.SaveChangesAsync();
                        faceShapeUpdated = true;
                    }
                    {
                        throw new ResourceNotFoundException("Face shape not found");
                    }                    
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    throw ex;
                }
            }
            else
            {
                FaceShapes currentFaceShape = FaceShapes.FirstOrDefault(fs => fs.Id == id);

                if (currentFaceShape != null)
                {
                    int currentFSIndex = FaceShapes.FindIndex(fs => fs.Id == id);
                    FaceShapes[currentFSIndex] = faceShape;
                    faceShapeUpdated = true;
                }
                else
                {
                    throw new ResourceNotFoundException("Face shape not found");
                }
            }

            return faceShapeUpdated;
        }

        /// <summary>
        /// Retrieves a face shape by ID
        /// </summary>
        /// <param name="id">ID of the face shape to be retrieved</param>
        /// <returns>Face shape found or null</returns>
        public async Task<FaceShapes> ReadById(ulong id)
        {
            List<FaceShapes> results;

            if (_context != null)
            {
                results = await _context
                                    .FaceShapes
                                    .Where(u => u.Id == id)
                                    .ToListAsync();
            }
            else
            {
                results = FaceShapes
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
