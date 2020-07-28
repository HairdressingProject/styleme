using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Models
{
    public class Token
    {
        [Required(ErrorMessage = "User token is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User token should not be empty or white space")]
        public string UserToken { get; set; }
    }
}
