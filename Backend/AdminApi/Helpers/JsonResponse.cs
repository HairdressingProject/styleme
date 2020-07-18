using System.Collections.Generic;
using System.Linq;

namespace AdminApi.Helpers
{
    public class JsonResponse
    {
        public string Message { get; set; }
        public int Status { get; set; }
        public Dictionary<string, string[]> Errors = null;

        public JsonResponse() { }

        public JsonResponse(string message, int status)
        {
            Message = message;
            Status = status;
        }

        public object FormatResponse()
        {
            if (Errors != null)
            {
                return new
                {
                    Message,
                    Status,
                    Errors
                };
            }
            return this;
        }
    }
}
