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
     * HairLengthsController
     * This controller handles all routes in the format: "/api/hair_lengths/"
     * 
    **/
    // [Authorize]
    [Route("api/hair_lengths")]
    [ApiController]
    public class HairLengthsController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public HairLengthsController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: api/hair_lengths
        [EnableCors("Policy1")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HairLengths>>> GetHairLengths()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            return await _context.HairLengths.ToListAsync();
        }

        // GET: api/hair_lengths/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HairLengths>> GetHairLengths(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairLengths = await _context.HairLengths.FindAsync(id);

            if (hairLengths == null)
            {
                return NotFound();
            }

            return hairLengths;
        }

        // PUT: api/hair_lengths/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHairLengths(ulong id, [FromBody] HairLengths hairLengths)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != hairLengths.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            _context.Entry(hairLengths).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!HairLengthsExists(id))
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

        // POST: api/hair_lengths
        [HttpPost]
        public async Task<ActionResult<HairLengths>> PostHairLengths([FromBody] HairLengths hairLengths)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            _context.HairLengths.Add(hairLengths);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetHairLengths", new { id = hairLengths.Id }, hairLengths);
        }

        // DELETE: api/hair_lengths/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<HairLengths>> DeleteHairLengths(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairLengths = await _context.HairLengths.FindAsync(id);
            if (hairLengths == null)
            {
                return NotFound();
            }

            _context.HairLengths.Remove(hairLengths);
            await _context.SaveChangesAsync();

            return hairLengths;
        }

        private bool HairLengthsExists(ulong id)
        {
            return _context.HairLengths.Any(e => e.Id == id);
        }
    }
}
