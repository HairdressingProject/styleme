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
     * This controller handles all routes in the format: "/hair_length_links/"
     * 
    **/
    // [Authorize]
    [Route("hair_length_links")]
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

        // GET: hair_length_links
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HairLengthLinks>>> GetHairLengthLinks(
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
                    var limitedHairLengthLinks = await _context
                                                    .HairLengthLinks
                                                    .Where(
                                                    hll =>
                                                        hll
                                                        .LinkName
                                                        .Trim()
                                                        .ToLower()
                                                        .Contains(string.IsNullOrWhiteSpace(search) ? search :
                                                                search.Trim().ToLower()
                                                                ) ||
                                                                hll.LinkUrl.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                )
                                                    .Include(hll => hll.HairLength)
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new { hairLengthLinks = limitedHairLengthLinks });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var hairLengthLinks = await _context.HairLengthLinks.Include(hll => hll.HairLength).ToListAsync();

            return Ok(new { hairLengthLinks = hairLengthLinks });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetHairLengthLinksCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.HairLengthLinks.Where(
                                                    hll =>
                                                        hll
                                                        .LinkName
                                                        .Trim()
                                                        .ToLower()
                                                        .Contains(search.Trim().ToLower()) ||
                                                                hll.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                                                ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var hairLengthLinks = await _context.HairLengthLinks.CountAsync();
            return Ok(new
            {
                count = hairLengthLinks
            });
        }

        // GET: hair_length_links/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HairLengthLinks>> GetHairLengthLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairLengthLinks = await _context.HairLengthLinks.Include(hll => hll.HairLength).FirstOrDefaultAsync(hll => hll.Id == id);

            if (hairLengthLinks == null)
            {
                return NotFound();
            }

            return hairLengthLinks;
        }

        // PUT: hair_length_links/5
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

            HairLengthLinks currentHLL = await _context.HairLengthLinks.FindAsync(id);

            

            try
            {
                if (currentHLL != null)
                {
                    currentHLL.LinkName = hairLengthLinks.LinkName;
                    currentHLL.LinkUrl = hairLengthLinks.LinkUrl;
                    currentHLL.HairLengthId = hairLengthLinks.HairLengthId;
                    _context.Entry(currentHLL).State = EntityState.Modified;
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

        // POST: hair_length_links
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

        // DELETE: hair_length_links/5
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
