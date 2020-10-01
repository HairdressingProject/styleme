using UsersAPI.Models.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.Models
{
    [Table("hair_styles")]
    public partial class HairStyles
    {
        public HairStyles()
        {
            HairStyleLinks = new HashSet<HairStyleLinks>();
        }

        public HairStyles ShallowCopy()
        {
            return (HairStyles)MemberwiseClone();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Hair style name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair style name should not be empty or white space")]
        [MaxLength(128)]
        [Column("hair_style_name", TypeName = "varchar(128)")]
        public string HairStyleName { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("HairStyle")]
        public virtual ICollection<HairStyleLinks> HairStyleLinks { get; set; }
    }
}
