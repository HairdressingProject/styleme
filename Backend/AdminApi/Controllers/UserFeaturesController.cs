using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AdminApi.Models_v2_1;
using AdminApi.Helpers;
using Microsoft.AspNetCore.Cors;

namespace AdminApi.Controllers
{
    /**
     * UserFeaturesController
     * This controller handles all routes in the format: "/api/user_features/"
     * 
    **/
    // [Authorize]
    [Route("api/user_features")]
    [ApiController]
    public class UserFeaturesController : ControllerBase
    {
        private readonly hair_project_dbContext _context;
        private readonly Services.IAuthorizationService _authorizationService;

        public UserFeaturesController(hair_project_dbContext context, Services.IAuthorizationService authorizationService)
        {
            _context = context;
            _authorizationService = authorizationService;
        }

        // GET: api/user_features
        [EnableCors("Policy1")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserFeatures>>> GetUserFeatures()
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var userFeatures = await _context.UserFeatures.ToListAsync();
            return Ok(new { userFeatures });
        }

        // GET: api/user_features/5
        [HttpGet("{id}")]
        public async Task<ActionResult<UserFeatures>> GetUserFeatures(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }
            var userFeatures = await _context.UserFeatures.FindAsync(id);

            if (userFeatures == null)
            {
                return NotFound();
            }

            return userFeatures;
        }

        // PUT: api/user_features/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUserFeatures(ulong id, [FromBody] UserFeatures userFeatures)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            if (id != userFeatures.Id)
            {
                return BadRequest(new { errors = new { Id = new string[] { "ID sent does not match the one in the endpoint" } }, status = 400 });
            }

            // Check existing resources
            var errors = await CheckExistingResources(userFeatures);

            if (errors != null)
            {
                return NotFound(errors);
            }

            UserFeatures uf = await _context.UserFeatures.FindAsync(id);

            try
            {
                if (uf != null)
                {
                    uf.UserId = userFeatures.UserId;
                    uf.FaceShapeId = userFeatures.FaceShapeId;
                    uf.SkinToneId = userFeatures.SkinToneId;
                    uf.HairStyleId = userFeatures.HairStyleId;
                    uf.HairLengthId = userFeatures.HairLengthId;
                    uf.HairColourId = userFeatures.HairColourId;
                    _context.Entry(uf).State = EntityState.Modified;
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

        // POST: api/user_features
        [HttpPost]
        public async Task<ActionResult<UserFeatures>> PostUserFeatures(UserFeatures userFeatures)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            // Check existing resources
            var errors = await CheckExistingResources(userFeatures);

            if (errors != null)
            {
                return NotFound(errors);
            }

            _context.UserFeatures.Add(userFeatures);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUserFeatures", new { id = userFeatures.Id }, userFeatures);
        }

        // DELETE: api/user_features/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<UserFeatures>> DeleteUserFeatures(ulong id)
        {
            if (!_authorizationService.ValidateJWTCookie(Request))
            {
                return Unauthorized(new { errors = new { Token = new string[] { "Invalid token" } }, status = 401 });
            }

            var userFeatures = await _context.UserFeatures.FindAsync(id);
            if (userFeatures == null)
            {
                return NotFound();
            }

            _context.UserFeatures.Remove(userFeatures);
            await _context.SaveChangesAsync();

            return userFeatures;
        }

        private bool UserFeaturesExists(ulong id)
        {
            return _context.UserFeatures.Any(e => e.Id == id);
        }

        private async Task<bool> CorrespondingResourceExists(UserFeatures userFeatures, ResourceTypes resourceType)
        {
            switch(resourceType)
            {
                case ResourceTypes.USERS:
                    return await _context.Users.AnyAsync(u => u.Id == userFeatures.UserId);

                case ResourceTypes.FACE_SHAPES:
                    return await _context.FaceShapes.AnyAsync(f => f.Id == userFeatures.FaceShapeId);

                case ResourceTypes.SKIN_TONES:
                    return await _context.SkinTones.AnyAsync(f => f.Id == userFeatures.SkinToneId);

                case ResourceTypes.HAIR_STYLES:
                    return await _context.HairStyles.AnyAsync(h => h.Id == userFeatures.HairStyleId);

                case ResourceTypes.HAIR_LENGTHS:
                    return await _context.HairLengths.AnyAsync(h => h.Id == userFeatures.HairLengthId);

                case ResourceTypes.COLOURS:
                    return await _context.Colours.AnyAsync(c => c.Id == userFeatures.HairColourId);

                default:
                    return false;
            }
        }

        private async Task<object> CheckExistingResources(UserFeatures userFeatures)
        {
            // Check existing user
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.USERS))
            {
                return new { errors = new { UserId = new string[] { "No matching user entry was found" } }, status = 404 };
            }

            // Check existing face shape
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.FACE_SHAPES))
            {
                return new { errors = new { FaceShapeId = new string[] { "No matching face shape entry was found" } }, status = 404 };
            }

            // Check existing skin tone
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.SKIN_TONES))
            {
                return new { errors = new { SkinToneId = new string[] { "No matching skin tone entry was found" } }, status = 404 };
            }

            // Check existing hair style
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.HAIR_STYLES))
            {
                return new { errors = new { HairStyleId = new string[] { "No matching hair style entry was found" } }, status = 404 };
            }

            // Check existing hair length
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.HAIR_LENGTHS))
            {
                return new { errors = new { HairLengthId = new string[] { "No matching hair length entry was found" } }, status = 404 };
            }

            // Check existing hair colour
            if (!await CorrespondingResourceExists(userFeatures, ResourceTypes.COLOURS))
            {
                return new { errors = new { HairColourId = new string[] { "No matching hair colour entry was found" } }, status = 404 };
            }

            return null;
        }
    }
}
