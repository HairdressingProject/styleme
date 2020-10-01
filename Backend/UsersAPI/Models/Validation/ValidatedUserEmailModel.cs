using UsersAPI.Models.Validation;
using System.ComponentModel.DataAnnotations;

namespace UsersAPI.Models.Validation
{
    public class ValidatedUserEmailModel
    {
        [Required(ErrorMessage = "Username/email is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Username/email should not be empty or white space")]
        [MaxLength(512)]
        public string UserNameOrEmail { get; set; }
    }
}
