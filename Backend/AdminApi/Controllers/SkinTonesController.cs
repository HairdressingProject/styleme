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
     * SkinTonesController
     * This controller handles all routes in the format: "/skin_tones/"
     * 
    **/
    // [Authorize]
    [Route("skin_tones")]
    [ApiController]
    public class SkinTonesController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public SkinTonesController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: skin_tones
        [EnableCors("Policy1")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SkinTones>>> GetSkinTones(
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
                    var limitedSkinTones = await _context
                                                    .SkinTones
                                                    .Where(
                                                    r =>
                                                    r.SkinToneName.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                    )
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new { skinTones = limitedSkinTones });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var skinTones = await _context.SkinTones.ToListAsync();

            return Ok(new { skinTones = skinTones });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetSkinTonesCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.SkinTones.Where(
                                                    r =>
                                                    r.SkinToneName.Trim().ToLower().Contains(search.Trim().ToLower())
                                                    ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var skinTonesCount = await _context.SkinTones.CountAsync();
            return Ok(new
            {
                count = skinTonesCount
            });
        }

        // GET: skin_tones/5
        [HttpGet("{id}")]
        public async Task<ActionResult<SkinTones>> GetSkinTones(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var skinTones = await _context.SkinTones.FindAsync(id);

            if (skinTones == null)
            {
                return NotFound();
            }

            return skinTones;
        }

        // PUT: skin_tones/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSkinTones(ulong id, [FromBody] SkinTones skinTones)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != skinTones.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            SkinTones st = await _context.SkinTones.FindAsync(id);

            try
            {
                if (st != null)
                {
                    st.SkinToneName = skinTones.SkinToneName;
                    _context.Entry(st).State = EntityState.Modified;
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

        // POST: skin_tones
        [HttpPost]
        public async Task<ActionResult<SkinTones>> PostSkinTones([FromBody] SkinTones skinTones)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            _context.SkinTones.Add(skinTones);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetSkinTones", new { id = skinTones.Id }, skinTones);
        }

        // DELETE: skin_tones/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<SkinTones>> DeleteSkinTones(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var skinTones = await _context.SkinTones.FindAsync(id);
            if (skinTones == null)
            {
                return NotFound();
            }

            _context.SkinTones.Remove(skinTones);
            await _context.SaveChangesAsync();

            return skinTones;
        }

        private bool SkinTonesExists(ulong id)
        {
            return _context.SkinTones.Any(e => e.Id == id);
        }
    }
}
