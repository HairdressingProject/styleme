using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("face_shapes")]
    public partial class FaceShapes
    {
        public FaceShapes()
        {
            FaceShapeLinks = new HashSet<FaceShapeLinks>();
            History = new HashSet<History>();
            ModelPictures = new HashSet<ModelPictures>();
        }

        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Required]
        [Column("shape_name", TypeName = "varchar(128)")]
        public string ShapeName { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty("FaceShape")]
        public virtual ICollection<FaceShapeLinks> FaceShapeLinks { get; set; }
        [InverseProperty("FaceShape")]
        public virtual ICollection<History> History { get; set; }
        [InverseProperty("FaceShape")]
        public virtual ICollection<ModelPictures> ModelPictures { get; set; }
    }
}
