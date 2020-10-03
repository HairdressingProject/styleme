using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using UsersAPI.Models.Validation;

namespace UsersAPI.Models
{
    [Table("colours")]
    public partial class Colours
    {
        public Colours()
        {
            History = new HashSet<History>();
            ModelPictures = new HashSet<ModelPictures>();
        }

        public Colours ShallowCopy()
        {
            return (Colours)MemberwiseClone();
        }

        [Key]
        [Column("id", TypeName = "bigint(20) unsigned")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Colour name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Colour name should not be empty or white space")]
        [MaxLength(64)]
        [Column("colour_name", TypeName = "varchar(64)")]
        public string ColourName { get; set; }

        [Required(ErrorMessage = "Colour hash is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Colour hash should not be empty or white space")]
        [RegularExpression(@"^(#[a-fA-F0-9]{3}$)|(#[a-fA-F0-9]{6}$)",
            ErrorMessage = @"The colour hash must be a HEX code with one of the following patterns: #333 or #333333")]
        [Column("colour_hash", TypeName = "varchar(64)")]
        public string ColourHash { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("HairColour")]
        public virtual ICollection<History> History { get; set; }
        [InverseProperty("HairColour")]
        public virtual ICollection<ModelPictures> ModelPictures { get; set; }
    }
}
