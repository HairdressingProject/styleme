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
     * This controller handles all routes in the format: "/api/skin_tones/"
     * 
    **/
    // [Authorize]
    [Route("api/skin_tones")]
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

        // GET: api/skin_tones
        [EnableCors("Policy1")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SkinTones>>> GetSkinTones()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            return await _context.SkinTones.ToListAsync();
        }

        // GET: api/skin_tones/5
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

        // PUT: api/skin_tones/5
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

            if (st != null)
            {
                st.SkinToneName = skinTones.SkinToneName;
            }

            _context.Entry(st).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SkinTonesExists(id))
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

        // POST: api/skin_tones
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

        // DELETE: api/skin_tones/5
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
