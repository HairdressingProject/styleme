using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;

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
        public async Task<ActionResult<IEnumerable<FaceShapeLinks>>> GetFaceShapeLinks(
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
                    var limitedFaceShapeLinks = await _context
                                                .FaceShapeLinks
                                                .Include(fsl => fsl.FaceShape)
                                                .Skip(o)
                                                .Take(l)
                                                .ToListAsync();

                    return Ok(new { faceShapeLinks = limitedFaceShapeLinks });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var faceShapeLinks = await _context.FaceShapeLinks.Include(fsl => fsl.FaceShape).ToListAsync();

            return Ok(new { faceShapeLinks = faceShapeLinks });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetFaceShapeLinksCount()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapeLinksCount = await _context.FaceShapeLinks.CountAsync();
            return Ok(new
            {
                count = faceShapeLinksCount
            });
        }

        // GET: api/face_shape_links/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FaceShapeLinks>> GetFaceShapeLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var faceShapeLinks = await _context.FaceShapeLinks.Include(fsl => fsl.FaceShape).FirstOrDefaultAsync(fsl => fsl.Id == id);

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

            FaceShapeLinks fsl = await _context.FaceShapeLinks.FindAsync(id);            

            try
            {
                if (fsl != null)
                {
                    fsl.LinkName = faceShapeLinks.LinkName;
                    fsl.LinkUrl = faceShapeLinks.LinkUrl;
                    fsl.FaceShapeId = faceShapeLinks.FaceShapeId;

                    _context.Entry(fsl).State = EntityState.Modified;
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
