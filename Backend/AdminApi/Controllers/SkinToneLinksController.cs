using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;

namespace AdminApi.Controllers
{
    /**
     * SkinToneLinksController
     * This controller handles all routes in the format: "/skin_tone_links/"
     * 
    **/
    // [Authorize]
    [Route("skin_tone_links")]
    [ApiController]
    public class SkinToneLinksController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public SkinToneLinksController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: skin_tone_links
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SkinToneLinks>>> GetSkinToneLinks(
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
                    var limitedSkinToneLinks = await _context
                                                    .SkinToneLinks
                                                    .Where(
                                                    stl =>
                                                        stl
                                                        .LinkName
                                                        .Trim()
                                                        .ToLower()
                                                        .Contains(string.IsNullOrWhiteSpace(search) ? search :
                                                                search.Trim().ToLower()
                                                                ) ||
                                                                stl.LinkUrl.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                )
                                                    .Include(stl => stl.SkinTone)
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new { skinToneLinks = limitedSkinToneLinks });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var skinToneLinks = await _context.SkinToneLinks.Include(stl => stl.SkinTone).ToListAsync();
            return Ok(new { skinToneLinks = skinToneLinks });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetSkinToneLinksCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.SkinToneLinks.Where(
                                                    stl =>
                                                        stl
                                                        .LinkName
                                                        .Trim()
                                                        .ToLower()
                                                        .Contains(search.Trim().ToLower()) ||
                                                                stl.LinkUrl.Trim().ToLower().Contains(search.Trim().ToLower())
                                                ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var skinToneLinksCount = await _context.SkinToneLinks.CountAsync();
            return Ok(new
            {
                count = skinToneLinksCount
            });
        }

        // GET: skin_tone_links/5
        [HttpGet("{id}")]
        public async Task<ActionResult<SkinToneLinks>> GetSkinToneLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var skinToneLinks = await _context.SkinToneLinks.Include(stl => stl.SkinTone).FirstOrDefaultAsync();

            if (skinToneLinks == null)
            {
                return NotFound();
            }

            return skinToneLinks;
        }

        // PUT: skin_tone_links/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSkinToneLinks(ulong id, [FromBody] SkinToneLinks skinToneLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != skinToneLinks.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            var correspondingSkinTone = await _context.SkinTones.FirstOrDefaultAsync(h => h.Id == skinToneLinks.SkinToneId);

            if (correspondingSkinTone == null)
            {
                return NotFound(new { errors = new { SkinToneId = new string[] { "No matching skin tone entry was found" } }, status = 404 });
            }

            SkinToneLinks stl = await _context.SkinToneLinks.FindAsync(id);

            try
            {
                if (stl != null)
                {
                    stl.LinkName = skinToneLinks.LinkName;
                    stl.LinkUrl = skinToneLinks.LinkUrl;
                    stl.SkinToneId = skinToneLinks.SkinToneId;
                    _context.Entry(stl).State = EntityState.Modified;
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

        // POST: skin_tone_links
        [HttpPost]
        public async Task<ActionResult<SkinToneLinks>> PostSkinToneLinks(SkinToneLinks skinToneLinks)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var correspondingSkinTone = await _context.SkinTones.FirstOrDefaultAsync(h => h.Id == skinToneLinks.SkinToneId);

            if (correspondingSkinTone == null)
            {
                return NotFound(new { errors = new { SkinToneId = new string[] { "No matching skin tone entry was found" } }, status = 404 });
            }

            _context.SkinToneLinks.Add(skinToneLinks);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetSkinToneLinks", new { id = skinToneLinks.Id }, skinToneLinks);
        }

        // DELETE: skin_tone_links/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<SkinToneLinks>> DeleteSkinToneLinks(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var skinToneLinks = await _context.SkinToneLinks.FindAsync(id);
            if (skinToneLinks == null)
            {
                return NotFound();
            }

            _context.SkinToneLinks.Remove(skinToneLinks);
            await _context.SaveChangesAsync();

            return skinToneLinks;
        }

        private bool SkinToneLinksExists(ulong id)
        {
            return _context.SkinToneLinks.Any(e => e.Id == id);
        }
    }
}
