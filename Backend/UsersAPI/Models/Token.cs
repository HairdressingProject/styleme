using UsersAPI.Models.Validation;
using System.ComponentModel.DataAnnotations;

namespace UsersAPI.Models
{
    public class Token
    {
        [Required(ErrorMessage = "User token is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User token should not be empty or white space")]
        public string UserToken { get; set; }
    }
}
