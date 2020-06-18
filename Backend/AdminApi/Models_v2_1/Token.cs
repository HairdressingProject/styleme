using AdminApi.Validation;
using System.ComponentModel.DataAnnotations;

namespace AdminApi.Models_v2_1
{
    public class Token
    {
        [Required(ErrorMessage = "User token is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User token should not be empty or white space")]
        public string UserToken { get; set; }
    }
}
