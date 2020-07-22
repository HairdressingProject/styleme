using AdminApi.Models_v2_1.Validation;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
{
    [Table("hair_length_links")]
    public partial class HairLengthLinks
    {
        public HairLengthLinks ShallowCopy()
        {
            return (HairLengthLinks)MemberwiseClone();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Hair length ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair length ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair length ID must only contain numbers (0 is not allowed)")]
        [Column("hair_length_id")]
        public ulong HairLengthId { get; set; }

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
        public DateTime DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [ForeignKey(nameof(HairLengthId))]
        [InverseProperty(nameof(HairLengths.HairLengthLinks))]
        public virtual HairLengths HairLength { get; set; }
    }
}
