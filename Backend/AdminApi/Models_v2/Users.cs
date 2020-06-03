using AdminApi.Helpers;
using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2
{
    [Table("users")]
    public partial class Users
    {
        public Users()
        {
            UserFeatures = new HashSet<UserFeatures>();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Username is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Username should not be empty or white space")]
        [MaxLength(32)]
        [Column("user_name", TypeName = "varchar(32)")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Password is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Password should not be empty or white space")]
        [MinLength(6, ErrorMessage = "Password should contain at least 6 characters")]
        [MaxLength(512, ErrorMessage = "Password cannot exceed 512 characters")]
        [Column("user_password", TypeName = "varchar(512)")]
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

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [InverseProperty("User")]
        public virtual Accounts Accounts { get; set; }
        [InverseProperty("User")]
        public virtual ICollection<UserFeatures> UserFeatures { get; set; }
    }
}
