using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2;

namespace AdminApi.Controllers
{
    /**
     * FaceShapeLinksController
     * This controller handles all routes in the format: "/api/face_shape_links/"
     * 
    **/
    // [Authorize]
    [Route("api/face_shape_links")]
    [ApiController]
    public class FaceShapeLinksController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public FaceShapeLinksController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: api/face_shape_links
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FaceShapeLinks>>> GetFaceShapeLinks()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            return await _context.FaceShapeLinks.ToListAsync();
        }

        // GET: api/face_shape_links/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FaceShapeLinks>> GetFaceShapeLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapeLinks = await _context.FaceShapeLinks.FindAsync(id);

            if (faceShapeLinks == null)
            {
                return NotFound();
            }

            return faceShapeLinks;
        }

        // PUT: api/face_shape_links/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFaceShapeLinks(ulong id, [FromBody] FaceShapeLinks faceShapeLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != faceShapeLinks.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            var correspondingFaceShape = await _context.FaceShapes.FirstOrDefaultAsync(f => f.Id == faceShapeLinks.FaceShapeId);

            if (correspondingFaceShape == null)
            {
                return NotFound(new { errors = new { FaceShapeId = new string[]{ "No matching face shape entry was found"} }, status = 404 });
            }

            _context.Entry(faceShapeLinks).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FaceShapeLinksExists(id))
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

        // POST: api/face_shape_links
        [HttpPost]
        public async Task<ActionResult<FaceShapeLinks>> PostFaceShapeLinks([FromBody] FaceShapeLinks faceShapeLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var correspondingFaceShape = await _context.FaceShapes.FirstOrDefaultAsync(f => f.Id == faceShapeLinks.FaceShapeId);

            if (correspondingFaceShape == null)
            {
                return BadRequest(new { errors = new { FaceShapeId = new string[] { "No matching face shape entry was found" } }, status = 400 });
            }

            if (faceShapeLinks.Id != null)
            {
                faceShapeLinks.Id = null;
            }

            _context.FaceShapeLinks.Add(faceShapeLinks);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetFaceShapeLinks", new { id = faceShapeLinks.Id }, faceShapeLinks);
        }

        // DELETE: api/face_shape_links/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<FaceShapeLinks>> DeleteFaceShapeLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapeLinks = await _context.FaceShapeLinks.FindAsync(id);
            if (faceShapeLinks == null)
            {
                return NotFound();
            }

            _context.FaceShapeLinks.Remove(faceShapeLinks);
            await _context.SaveChangesAsync();

            return faceShapeLinks;
        }

        private bool FaceShapeLinksExists(ulong id)
        {
            return _context.FaceShapeLinks.Any(e => e.Id == id);
        }
    }
}
