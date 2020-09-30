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
     * This controller handles all routes in the format: "/hair_lengths/"
     * 
    **/
    // [Authorize]
    [Route("hair_lengths")]
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

        // GET: hair_lengths
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HairLengths>>> GetHairLengths(
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
                    var limitedHairLengths = await _context
                                                    .HairLengths
                                                    .Where(
                                                    r =>
                                                    r.HairLengthName.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                    )
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new { hairLengths = limitedHairLengths });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var hairLengths = await _context.HairLengths.ToListAsync();
            return Ok(new { hairLengths = hairLengths });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetHairLengthsCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.HairLengths.Where(
                                                    r =>
                                                    r.HairLengthName.Trim().ToLower().Contains(search.Trim().ToLower())
                                                    ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var hairLengths = await _context.HairLengths.CountAsync();
            return Ok(new
            {
                count = hairLengths
            });
        }

        // GET: hair_lengths/5
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

        // PUT: hair_lengths/5
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

            HairLengths currentHL = await _context.HairLengths.FindAsync(id);            

            try
            {
                if (currentHL != null)
                {
                    currentHL.HairLengthName = hairLengths.HairLengthName;
                    _context.Entry(currentHL).State = EntityState.Modified;
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

        // POST: hair_lengths
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

        // DELETE: hair_lengths/5
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
