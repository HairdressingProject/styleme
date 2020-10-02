using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("face_shape_links")]
    public partial class FaceShapeLinks
    {
        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Column("face_shape_id", TypeName = "int(11)")]
        public int FaceShapeId { get; set; }
        [Required]
        [Column("link_name", TypeName = "varchar(128)")]
        public string LinkName { get; set; }
        [Required]
        [Column("link_url", TypeName = "varchar(512)")]
        public string LinkUrl { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [ForeignKey(nameof(FaceShapeId))]
        [InverseProperty(nameof(FaceShapes.FaceShapeLinks))]
        public virtual FaceShapes FaceShape { get; set; }
    }
}
