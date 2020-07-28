using AdminApi.Helpers;
using AdminApi.Validation;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Entities
{
    public class SignUpUser
    {
        [Required(ErrorMessage = "Username is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Username should not be empty or white space")]
        [MaxLength(32, ErrorMessage = "Username should have a maximum of 32 characters")]
        [Column("user_name", TypeName = "varchar(32)")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Password is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Password should not be empty or white space")]
        [MinLength(6, ErrorMessage = "Password should contain at least 6 characters")]
        [MaxLength(512, ErrorMessage = "Password cannot exceed 512 characters")]
        public string UserPassword { get; set; }

        [Required(ErrorMessage = "Email is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Email should not be empty or white space")]
        [MaxLength(512)]
        [Column("user_email", TypeName = "varchar(512)")]
        public string UserEmail { get; set; }

        [Required(ErrorMessage = "First name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"First name should not be empty or white space")]
        [MaxLength(128)]
        [Column("first_name", TypeName = "varchar(128)")]
        public string FirstName { get; set; }

        [MaxLength(128)]
        [Column("last_name", TypeName = "varchar(128)")]
        public string LastName { get; set; }

        [Required]
        [Column("user_role", TypeName = "enum('admin','developer','user')")]
        public string UserRole { get; set; } = Enum.GetName(typeof(UserRoles), UserRoles.USER).ToLower();
    }
}
