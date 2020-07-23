using AdminApi.Models_v2_1.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
{
    [Table("face_shapes")]
    public partial class FaceShapes
    {
        public FaceShapes()
        {
            FaceShapeLinks = new HashSet<FaceShapeLinks>();
        }

        public FaceShapes ShallowCopy()
        {
            return (FaceShapes)MemberwiseClone();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Shape name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Shape name should not be empty or white space")]
        [MaxLength(128)]
        [Column("shape_name", TypeName = "varchar(128)")]
        public string ShapeName { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [InverseProperty("FaceShape")]
        public virtual ICollection<FaceShapeLinks> FaceShapeLinks { get; set; }
    }
}
