using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
{
    [Table("accounts")]
    public partial class Accounts
    {
        [Key]
        [Column("user_id")]
        public ulong? UserId { get; set; }

        [MaxLength(16)]
        [MinLength(16)]
        [Column("recover_password_token", TypeName = "binary(16)")]
        public byte[] RecoverPasswordToken { get; set; }

        [Column("account_confirmed")]
        public bool? AccountConfirmed { get; set; }

        [Column("unusual_activity")]
        public bool? UnusualActivity { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [ForeignKey(nameof(UserId))]
        [InverseProperty(nameof(Users.Accounts))]
        public virtual Users User { get; set; }
    }
}
