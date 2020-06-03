using AdminApi.Validation;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2
{
    [Table("skin_tone_links")]
    public partial class SkinToneLinks
    {
        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Skin tone ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Skin tone ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Skin tone ID must only contain numbers (0 is not allowed)")]
        [Column("skin_tone_id")]
        public ulong SkinToneId { get; set; }

        [Required(ErrorMessage = "Link name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Link name should not be empty or white space")]
        [MaxLength(128)]
        [Column("link_name", TypeName = "varchar(128)")]
        public string LinkName { get; set; }

        [Required(ErrorMessage = "Link URL is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Link URL should not be empty or white space")]
        [MaxLength(512)]
        [Column("link_url", TypeName = "varchar(512)")]
        public string LinkUrl { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [ForeignKey(nameof(SkinToneId))]
        [InverseProperty(nameof(SkinTones.SkinToneLinks))]
        public virtual SkinTones SkinTone { get; set; }
    }
}
