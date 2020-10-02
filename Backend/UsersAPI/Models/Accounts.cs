using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.Models
{
    [Table("accounts")]
    public partial class Accounts
    {
        [Key]
        [Column("user_id", TypeName = "int(11)")]
        public ulong? UserId { get; set; }

        [MaxLength(16)]
        [MinLength(16)]
        [Column("recover_password_token", TypeName = "tinyblob")]
        public byte[] RecoverPasswordToken { get; set; }
        [Column("account_confirmed")]
        public bool? AccountConfirmed { get; set; }
        [Column("unusual_activity")]
        public bool? UnusualActivity { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [ForeignKey(nameof(UserId))]
        [InverseProperty(nameof(Users.Accounts))]
        public virtual Users User { get; set; }
    }
}
