using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using UsersAPI.Models;
using Microsoft.AspNetCore.Cors;

namespace UsersAPI.Controllers
{
    /**
     * FaceShapesControllerC:\Users\Stefan\Desktop\Complex UX\Admin-Portal-v2\Backend\UsersAPI\Controllers\FaceShapesController.cs
     * This controller handles all routes in the format: "/face_shapes/"
     * 
    **/
    // [Authorize]
    [Route("face_shapes")]
    [ApiController]
    public class FaceShapesController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public FaceShapesController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: face_shapes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FaceShapes>>> GetFaceShapes(
            [FromQuery(Name = "limit")] string limit = "1000",
            [FromQuery(Name = "offset")] string offset = "0",
            [FromQuery(Name = "search")] string search = ""
            )
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    var limitedFaceShapes = await _context
                                                    .FaceShapes
                                                    .Where(
                                                    r =>
                                                    r.ShapeName.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                    )
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new { faceShapes = limitedFaceShapes });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }


            var faceShapes = await _context.FaceShapes.ToListAsync();
            return Ok(new { faceShapes = faceShapes });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetFaceShapesCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.FaceShapes.Where(
                                                    r =>
                                                    r.ShapeName.Trim().ToLower().Contains(search.Trim().ToLower())
                                                    ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var faceShapes = await _context.FaceShapes.CountAsync();
            return Ok(new
            {
                count = faceShapes
            });
        }

        // GET: face_shapes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FaceShapes>> GetFaceShapes(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapes = await _context.FaceShapes.FindAsync(id);

            if (faceShapes == null)
            {
                return NotFound();
            }

            return faceShapes;
        }

        // PUT: face_shapes/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFaceShapes(ulong id, [FromBody] FaceShapes faceShapes)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != faceShapes.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            FaceShapes currentFaceShape = await _context.FaceShapes.FindAsync(id);

            try
            {
                if (currentFaceShape != null)
                {
                    currentFaceShape.ShapeName = faceShapes.ShapeName;
                    _context.Entry(currentFaceShape).State = EntityState.Modified;
                    await _context.SaveChangesAsync();
                    return Ok();
                }
                return NotFound();
            }
            catch (DbUpdateConcurrencyException)
            {
                return StatusCode(500);
            }
        }

        // POST: face_shapes
        [HttpPost]
        public async Task<ActionResult<FaceShapes>> PostFaceShapes([FromBody] FaceShapes faceShapes)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            _context.FaceShapes.Add(faceShapes);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetFaceShapes", new { id = faceShapes.Id }, faceShapes);
        }

        // DELETE: face_shapes/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<FaceShapes>> DeleteFaceShapes(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapes = await _context.FaceShapes.FindAsync(id);
            if (faceShapes == null)
            {
                return NotFound();
            }

            _context.FaceShapes.Remove(faceShapes);
            await _context.SaveChangesAsync();

            return faceShapes;
        }

        private bool FaceShapesExists(ulong id)
        {
            return _context.FaceShapes.Any(e => e.Id == id);
        }
    }
}
