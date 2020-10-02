using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("hair_styles")]
    public partial class HairStyles
    {
        public HairStyles()
        {
            HairStyleLinks = new HashSet<HairStyleLinks>();
            History = new HashSet<History>();
            ModelPictures = new HashSet<ModelPictures>();
        }

        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Required]
        [Column("hair_style_name", TypeName = "varchar(128)")]
        public string HairStyleName { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("HairStyle")]
        public virtual ICollection<HairStyleLinks> HairStyleLinks { get; set; }
        [InverseProperty("HairStyle")]
        public virtual ICollection<History> History { get; set; }
        [InverseProperty("HairStyle")]
        public virtual ICollection<ModelPictures> ModelPictures { get; set; }
    }
}
