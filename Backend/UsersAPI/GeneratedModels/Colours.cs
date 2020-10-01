using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("colours")]
    public partial class Colours
    {
        public Colours()
        {
            History = new HashSet<History>();
            ModelPictures = new HashSet<ModelPictures>();
        }

        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Required]
        [Column("colour_name", TypeName = "varchar(64)")]
        public string ColourName { get; set; }
        [Required]
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
