using AdminApi.Models_v2_1.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
{
    [Table("skin_tones")]
    public partial class SkinTones
    {
        public SkinTones()
        {
            SkinToneLinks = new HashSet<SkinToneLinks>();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Skin tone name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Skin tone name should not be empty or white space")]
        [MaxLength(128)]
        [Column("skin_tone_name", TypeName = "varchar(128)")]
        public string SkinToneName { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [InverseProperty("SkinTone")]
        public virtual ICollection<SkinToneLinks> SkinToneLinks { get; set; }
    }
}
