using System.Collections.Generic;
using System.Dynamic;
using System.Linq;

namespace UsersAPI.Helpers
{
    /// <summary>
    /// Constructs a JSON object to be sent back in HTTP responses
    /// </summary>
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

        /// <summary>
        /// Formats JSON object with optional entries 
        /// <para>
        /// Note: Use with caution. It iterates through reflected properties of 
        /// <see cref="JsonResponse"/> so performance could be slow in some cases.
        /// </para>
        /// </summary>
        /// <param name="additionalEntries">Optional entries to be added to the response object</param>
        /// <returns>Formatted object with additional entries (if present) or the original object</returns>
        public object FormatResponse(Dictionary<string, object> additionalEntries = null)
        {
            if (additionalEntries != null)
            {
                foreach (var prop in GetType().GetProperties())
                {
                    additionalEntries[prop.Name] = prop.GetValue(this);
                }

                return additionalEntries;                
            }
            return this;
        }
    }
}
