using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2;

namespace AdminApi.Controllers
{
    /**
     * HairStylesController
     * This controller handles all routes in the format: "/api/hair_styles/"
     * 
    **/
    // [Authorize]
    [Route("api/hair_styles")]
    [ApiController]
    public class HairStylesController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public HairStylesController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: api/hair_styles
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HairStyles>>> GetHairStyles()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            return await _context.HairStyles.ToListAsync();
        }

        // GET: api/hair_styles/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HairStyles>> GetHairStyles(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairStyles = await _context.HairStyles.FindAsync(id);

            if (hairStyles == null)
            {
                return NotFound();
            }

            return hairStyles;
        }

        // PUT: api/hair_styles/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHairStyles(ulong id, [FromBody] HairStyles hairStyles)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != hairStyles.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            _context.Entry(hairStyles).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!HairStylesExists(id))
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

        // POST: api/hair_styles
        [HttpPost]
        public async Task<ActionResult<HairStyles>> PostHairStyles([FromBody] HairStyles hairStyles)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (hairStyles.Id != null)
            {
                hairStyles.Id = null;
            }

            _context.HairStyles.Add(hairStyles);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetHairStyles", new { id = hairStyles.Id }, hairStyles);
        }

        // DELETE: api/hair_styles/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<HairStyles>> DeleteHairStyles(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairStyles = await _context.HairStyles.FindAsync(id);
            if (hairStyles == null)
            {
                return NotFound();
            }

            _context.HairStyles.Remove(hairStyles);
            await _context.SaveChangesAsync();

            return hairStyles;
        }

        private bool HairStylesExists(ulong id)
        {
            return _context.HairStyles.Any(e => e.Id == id);
        }
    }
}
