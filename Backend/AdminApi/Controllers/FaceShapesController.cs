using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;
using Microsoft.AspNetCore.Cors;

namespace AdminApi.Controllers
{
    /**
     * FaceShapesController
     * This controller handles all routes in the format: "/api/face_shapes/"
     * 
    **/
    // [Authorize]
    [Route("api/face_shapes")]
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

        // GET: api/face_shapes
        [EnableCors("Policy1")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FaceShapes>>> GetFaceShapes(
            [FromQuery(Name = "limit")] string limit,
            [FromQuery(Name = "offset")] string offset
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
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new
                    {
                        faceShapes = limitedFaceShapes
                    });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var faceShapes = await _context.FaceShapes.ToListAsync();

            return Ok(new { faceShapes });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetFaceShapesCount()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapes = await _context.FaceShapes.CountAsync();
            return Ok(new
            {
                count = faceShapes
            });
        }

        // GET: api/face_shapes/5
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

        // PUT: api/face_shapes/5
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

        // POST: api/face_shapes
        [EnableCors("Policy1")]
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

        // DELETE: api/face_shapes/5
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
