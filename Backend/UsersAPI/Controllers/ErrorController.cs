using Microsoft.AspNetCore.Mvc;

namespace UsersAPI.Controllers {
    [ApiController]
    public class ErrorController : ControllerBase {
        [Route("/error")]
        public IActionResult Error() => Problem();
    }
}