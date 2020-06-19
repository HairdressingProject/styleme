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
        public async Task<ActionResult<IEnumerable<FaceShapes>>> GetFaceShapes()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            return await _context.FaceShapes.ToListAsync();
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

            _context.Entry(faceShapes).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FaceShapesExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
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
