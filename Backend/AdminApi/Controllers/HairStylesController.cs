using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;

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
        public async Task<ActionResult<IEnumerable<HairStyles>>> GetHairStyles(
            [FromQuery(Name = "limit")] string limit,
             [FromQuery(Name = "offset")] string offset)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (limit != null && offset != null)
            {
                if (int.TryParse(limit, out int l) && int.TryParse(offset, out int o))
                {
                    var limitedHairStyles = await _context
                                                    .HairStyles
                                                    .Skip(o)
                                                    .Take(l)
                                                    .ToListAsync();

                    return Ok(new
                    {
                        hairStyles = limitedHairStyles
                    });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            var hairStyles = await _context.HairStyles.ToListAsync();
            return Ok(new { hairStyles });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetHairStylesCount()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var hairStylesCount = await _context.HairStyles.CountAsync();
            return Ok(new
            {
                count = hairStylesCount
            });
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

            HairStyles hs = await _context.HairStyles.FindAsync(id);

            try
            {
                if (hs != null)
                {
                    hs.HairStyleName = hairStyles.HairStyleName;
                    _context.Entry(hs).State = EntityState.Modified;
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

        // POST: api/hair_styles
        [HttpPost]
        public async Task<ActionResult<HairStyles>> PostHairStyles([FromBody] HairStyles hairStyles)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
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
