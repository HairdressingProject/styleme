using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Models_v2_1.Validation
{
    public class ValidatedChangeUserPasswordModel
    {
        [Required(ErrorMessage = "ID is required")]
        public ulong Id { get; set; }

        [Required(ErrorMessage = "Username/email is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Username/email should not be empty or white space")]
        [MaxLength(512)]
        public string UserNameOrEmail { get; set; }

        [Required(ErrorMessage = "Password is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Password should not be empty or white space")]
        [MinLength(6)]
        [MaxLength(512)]
        public string UserPassword { get; set; }
    }
}
