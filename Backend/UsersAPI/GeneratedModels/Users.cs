using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("users")]
    public partial class Users
    {
        public Users()
        {
            History = new HashSet<History>();
        }

        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Required]
        [Column("user_name", TypeName = "varchar(32)")]
        public string UserName { get; set; }
        [Required]
        [Column("user_password_hash", TypeName = "varchar(512)")]
        public string UserPasswordHash { get; set; }
        [Required]
        [Column("user_password_salt", TypeName = "varchar(512)")]
        public string UserPasswordSalt { get; set; }
        [Required]
        [Column("user_email", TypeName = "varchar(512)")]
        public string UserEmail { get; set; }
        [Required]
        [Column("first_name", TypeName = "varchar(128)")]
        public string FirstName { get; set; }
        [Column("last_name", TypeName = "varchar(128)")]
        public string LastName { get; set; }
        [Required]
        [Column("user_role", TypeName = "enum('user','developer','admin')")]
        public string UserRole { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("User")]
        public virtual Accounts Accounts { get; set; }
        [InverseProperty("User")]
        public virtual ICollection<History> History { get; set; }
    }
}
