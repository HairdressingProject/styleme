using AdminApi.Validation;
using System.ComponentModel.DataAnnotations;

namespace AdminApi.Models_v2.Validation
{
    public class ValidatedUserEmailModel
    {
        [Required(ErrorMessage = "Username/email is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Username/email should not be empty or white space")]
        [MaxLength(512)]
        public string UserNameOrEmail { get; set; }
    }
}
