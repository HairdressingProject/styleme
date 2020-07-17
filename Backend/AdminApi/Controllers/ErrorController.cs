using Microsoft.AspNetCore.Mvc;

namespace AdminApi.Controllers {
    [ApiController]
    public class ErrorController : ControllerBase {
        [Route("/error")]
        public IActionResult Error() => Problem();
    }
}