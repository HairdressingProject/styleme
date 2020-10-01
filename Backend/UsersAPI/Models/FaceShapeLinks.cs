using UsersAPI.Models.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.Models
{
    [Table("face_shape_links")]
    public partial class FaceShapeLinks
    {
        public FaceShapeLinks ShallowCopy()
        {
            return (FaceShapeLinks)MemberwiseClone();
        }

        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Face shape ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Face shape ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Face shape ID must only contain numbers (0 is not allowed)")]
        [Column("face_shape_id")]
        public ulong FaceShapeId { get; set; }

        [Required(ErrorMessage = "Link name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Link name should not be empty or white space")]
        [MaxLength(128)]
        [Column("link_name", TypeName = "varchar(128)")]
        public string LinkName { get; set; }

        [Required(ErrorMessage = "Link URL is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Link URL should not be empty or white space")]
        [MaxLength(512)]
        [Column("link_url", TypeName = "varchar(512)")]
        public string LinkUrl { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [ForeignKey(nameof(FaceShapeId))]
        [InverseProperty(nameof(FaceShapes.FaceShapeLinks))]
        public virtual FaceShapes FaceShape { get; set; }
    }
}
