using AdminApi.Models_v2_1.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
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

        public string UserPasswordHash { get; set; }
        public string UserPasswordSalt { get; set; }

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

        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User role should not be empty or white space")]
        [RequiredUserRole(AllowEmptyStrings = false, ErrorMessage = "Invalid user role.")]
        [Column("user_role", TypeName = "enum('admin','developer','user')")]
        public string UserRole { get; set; }

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
