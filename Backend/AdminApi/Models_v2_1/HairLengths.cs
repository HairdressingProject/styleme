using AdminApi.Models_v2_1.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
{
    [Table("hair_lengths")]
    public partial class HairLengths
    {
        public HairLengths()
        {
            HairLengthLinks = new HashSet<HairLengthLinks>();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Hair length name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair length name should not be empty or white space")]
        [MaxLength(128)]
        [Column("hair_length_name", TypeName = "varchar(128)")]
        public string HairLengthName { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [InverseProperty("HairLength")]
        public virtual ICollection<HairLengthLinks> HairLengthLinks { get; set; }
    }
}
