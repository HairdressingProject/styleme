using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;

namespace AdminApi.Controllers
{
    /**
     * HairLengthLinksController
     * This controller handles all routes in the format: "/api/hair_length_links/"
     * 
    **/
    // [Authorize]
    [Route("api/hair_length_links")]
    [ApiController]
    public class HairLengthLinksController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public HairLengthLinksController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: api/hair_length_links
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HairLengthLinks>>> GetHairLengthLinks()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            return await _context.HairLengthLinks.ToListAsync();
        }

        // GET: api/hair_length_links/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HairLengthLinks>> GetHairLengthLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairLengthLinks = await _context.HairLengthLinks.FindAsync(id);

            if (hairLengthLinks == null)
            {
                return NotFound();
            }

            return hairLengthLinks;
        }

        // PUT: api/hair_length_links/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHairLengthLinks(ulong id, [FromBody] HairLengthLinks hairLengthLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != hairLengthLinks.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            var correspondingHairLength = await _context.HairLengths.FirstOrDefaultAsync(h => h.Id == hairLengthLinks.HairLengthId);

            if (correspondingHairLength == null)
            {
                return NotFound(new { errors = new { HairLengthId = new string[] { "No matching hair length entry was found" } }, status = 404 });
            }

            _context.Entry(hairLengthLinks).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!HairLengthLinksExists(id))
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

        // POST: api/hair_length_links
        [HttpPost]
        public async Task<ActionResult<HairLengthLinks>> PostHairLengthLinks([FromBody] HairLengthLinks hairLengthLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var correspondingHairLength = await _context.HairLengths.FirstOrDefaultAsync(h => h.Id == hairLengthLinks.HairLengthId);

            if (correspondingHairLength == null)
            {
                return NotFound(new { errors = new { HairLengthId = new string[] { "No matching hair length entry was found" } }, status = 404 });
            }

            _context.HairLengthLinks.Add(hairLengthLinks);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetHairLengthLinks", new { id = hairLengthLinks.Id }, hairLengthLinks);
        }

        // DELETE: api/hair_length_links/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<HairLengthLinks>> DeleteHairLengthLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairLengthLinks = await _context.HairLengthLinks.FindAsync(id);
            if (hairLengthLinks == null)
            {
                return NotFound();
            }

            _context.HairLengthLinks.Remove(hairLengthLinks);
            await _context.SaveChangesAsync();

            return hairLengthLinks;
        }

        private bool HairLengthLinksExists(ulong id)
        {
            return _context.HairLengthLinks.Any(e => e.Id == id);
        }
    }
}
