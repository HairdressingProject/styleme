using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("hair_lengths")]
    public partial class HairLengths
    {
        public HairLengths()
        {
            HairLengthLinks = new HashSet<HairLengthLinks>();
            ModelPictures = new HashSet<ModelPictures>();
        }

        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Required]
        [Column("hair_length_name", TypeName = "varchar(128)")]
        public string HairLengthName { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("HairLength")]
        public virtual ICollection<HairLengthLinks> HairLengthLinks { get; set; }
        [InverseProperty("HairLength")]
        public virtual ICollection<ModelPictures> ModelPictures { get; set; }
    }
}
