using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;

namespace AdminApi.Controllers
{
    /**
     * HairStyleLinksController
     * This controller handles all routes in the format: "/api/hair_style_links/"
     * 
    **/
    // [Authorize]
    [Route("api/hair_style_links")]
    [ApiController]
    public class HairStyleLinksController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public HairStyleLinksController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: api/hair_style_links
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HairStyleLinks>>> GetHairStyleLinks(
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
                    var limitedHairStyleLinks = await _context
                                                    .HairStyleLinks
                                                    .Where(
                                                    hsl =>
                                                        hsl
                                                        .LinkName
                                                        .Trim()
                                                        .ToLower()
                                                        .Contains(string.IsNullOrWhiteSpace(search) ? search :
                                                                search.Trim().ToLower()
                                                                ) ||
                                                                hsl.LinkUrl.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                )
                                                    .Include(hsl => hsl.HairStyle)
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new { hairStyleLinks = limitedHairStyleLinks });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var hairStyleLinks = await _context.HairStyleLinks.Include(hsl => hsl.HairStyle).ToListAsync();

            return Ok(new { hairStyleLinks = hairStyleLinks });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetHairStyleLinksCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.HairStyleLinks.Where(
                                                    hsl =>
                                                        hsl
                                                        .LinkName
                                                        .Trim()
                                                        .ToLower()
                                                        .Contains(search.Trim().ToLower()) ||
                                                                hsl.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                                                ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var hairStyleLinks = await _context.HairStyleLinks.CountAsync();
            return Ok(new
            {
                count = hairStyleLinks
            });
        }

        // GET: api/hair_style_links/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HairStyleLinks>> GetHairStyleLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairStyleLinks = await _context.HairStyleLinks.Include(hsl => hsl.HairStyle).FirstOrDefaultAsync();

            if (hairStyleLinks == null)
            {
                return NotFound();
            }

            return hairStyleLinks;
        }

        // PUT: api/hair_style_links/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHairStyleLinks(ulong id, [FromBody] HairStyleLinks hairStyleLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != hairStyleLinks.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            var correspondingHairStyle = await _context.HairStyles.FirstOrDefaultAsync(h => h.Id == hairStyleLinks.HairStyleId);

            if (correspondingHairStyle == null)
            {
                return NotFound(new { errors = new { HairStyleId = new string[] { "No matching hair style entry was found" } }, status = 404 });
            }

            HairStyleLinks hsl = await _context.HairStyleLinks.FindAsync(id);

            try
            {
                if (hsl != null)
                {
                    hsl.LinkName = hairStyleLinks.LinkName;
                    hsl.LinkUrl = hairStyleLinks.LinkUrl;
                    hsl.HairStyleId = hairStyleLinks.HairStyleId;
                    _context.Entry(hsl).State = EntityState.Modified;
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

        // POST /api/hair_style_links
        [HttpPost]
        public async Task<ActionResult<HairStyleLinks>> PostHairStyleLinks([FromBody] HairStyleLinks hairStyleLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var correspondingHairStyle = await _context.HairStyles.FirstOrDefaultAsync(h => h.Id == hairStyleLinks.HairStyleId);

            if (correspondingHairStyle == null)
            {
                return NotFound(new { errors = new { HairStyleId = new string[] { "No matching hair style entry was found" } }, status = 404 });
            }

            _context.HairStyleLinks.Add(hairStyleLinks);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetHairStyleLinks", new { id = hairStyleLinks.Id }, hairStyleLinks);
        }

        // DELETE: api/hair_style_links/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<HairStyleLinks>> DeleteHairStyleLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairStyleLinks = await _context.HairStyleLinks.FindAsync(id);
            if (hairStyleLinks == null)
            {
                return NotFound();
            }

            _context.HairStyleLinks.Remove(hairStyleLinks);
            await _context.SaveChangesAsync();

            return hairStyleLinks;
        }

        private bool HairStyleLinksExists(ulong id)
        {
            return _context.HairStyleLinks.Any(e => e.Id == id);
        }
    }
}
