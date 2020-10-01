using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using UsersAPI.Models;

namespace UsersAPI.Controllers
{
    /**
     * ColoursController
     * This controller handles all routes in the format: "/colours/*"
     * 
    **/
    // [Authorize]
    [Route("colours")]
    [ApiController]
    public class ColoursController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public ColoursController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: colours
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Colours>>> GetColours(
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
                    var limitedColours = await _context
                                                .Colours
                                                .Where(
                                                r =>
                                                r.ColourName.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower()) ||
                                                r.ColourHash.Trim().ToLower().Contains(string.IsNullOrWhiteSpace(search) ? search : search.Trim().ToLower())
                                                )
                                                .Skip(o)
                                                .Take(l)
                                                .ToListAsync();

                    return Ok(new { colours = limitedColours });
                }
                else
                {
                    return BadRequest(new { errors = new { queries = new string[] { "Invalid queries" }, status = 400 } });
                }
            }

            // default return
            var colours = await _context.Colours.ToListAsync();
            return Ok(new { colours = colours });
        }

        [HttpGet("count")]
        public async Task<ActionResult<int>> GetColoursCount([FromQuery(Name = "search")] string search = "")
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var searchCount = await _context.Colours.Where(
                                                r =>
                                                r.ColourName.Trim().ToLower().Contains(search.Trim().ToLower()) ||
                                                r.ColourHash.Trim().ToLower().Contains(search.Trim().ToLower())
                                                ).CountAsync();

                return Ok(new
                {
                    count = searchCount
                });
            }

            var coloursCount = await _context.Colours.CountAsync();
            return Ok(new
            {
                count = coloursCount
            });
        }

        // GET: colours/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Colours>> GetColours(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var colours = await _context.Colours.FindAsync(id);

            if (colours == null)
            {
                return NotFound();
            }

            return colours;
        }

        // PUT: colours/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutColours(ulong id, [FromBody] Colours colours)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != colours.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            Colours currentColour = await _context.Colours.FindAsync(id);

            try
            {
                if (currentColour != null)
                {
                    currentColour.ColourName = colours.ColourName;
                    currentColour.ColourHash = colours.ColourHash;
                    _context.Entry(currentColour).State = EntityState.Modified;
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

        // POST: colours
        [HttpPost]
        public async Task<ActionResult<Colours>> PostColours([FromBody] Colours colours)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            _context.Colours.Add(colours);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetColours", new { id = colours.Id }, colours);
        }

        // DELETE: colours/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Colours>> DeleteColours(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var colours = await _context.Colours.FindAsync(id);
            if (colours == null)
            {
                return NotFound();
            }

            _context.Colours.Remove(colours);
            await _context.SaveChangesAsync();

            return colours;
        }

        private Task<bool> ColoursExists(ulong id)
        {
            return _context.Colours.AnyAsync(e => e.Id == id);
        }
    }
}
