using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using UsersAPI.Models.Validation;

namespace UsersAPI.Models
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

        public FaceShapes ShallowCopy()
        {
            return (FaceShapes)MemberwiseClone();
        }

        [Key]
        [Column("id", TypeName = "bigint(20) unsigned")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Shape name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Shape name should not be empty or white space")]
        [MaxLength(128)]
        [Column("shape_name", TypeName = "varchar(128)")]
        public string ShapeName { get; set; }

        [Column("label", TypeName = "varchar(255)")]
        public string Label { get; set; }

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
