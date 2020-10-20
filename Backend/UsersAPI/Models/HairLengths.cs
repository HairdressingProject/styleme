using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using UsersAPI.Models.Validation;

namespace UsersAPI.Models
{
    [Table("hair_lengths")]
    public partial class HairLengths
    {
        public HairLengths()
        {
            HairLengthLinks = new HashSet<HairLengthLinks>();
            ModelPictures = new HashSet<ModelPictures>();
        }

        public HairLengths ShallowCopy()
        {
            return (HairLengths)MemberwiseClone();
        }

        [Key]
        [Column("id", TypeName = "bigint(20) unsigned")]
        public ulong Id { get; set; }

        [Required(ErrorMessage = "Hair length name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair length name should not be empty or white space")]
        [MaxLength(128)]
        [Column("hair_length_name", TypeName = "varchar(128)")]
        public string HairLengthName { get; set; }

        [Column("label", TypeName = "varchar(255)")]
        public string Label { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("HairLength")]
        public virtual ICollection<HairLengthLinks> HairLengthLinks { get; set; }
        [InverseProperty("HairLength")]
        public virtual ICollection<ModelPictures> ModelPictures { get; set; }
    }
}
