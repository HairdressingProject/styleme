using AdminApi.Models_v2_1.Validation;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AdminApi.Models_v2_1
{
    [Table("user_features")]
    public partial class UserFeatures
    {
        [Key]
        [Column("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "User ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"User ID must only contain numbers (0 is not allowed)")]
        [Column("user_id")]
        public ulong UserId { get; set; }

        [Required(ErrorMessage = "Face shape ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Face shape ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Face shape ID must only contain numbers (0 is not allowed)")]
        [Column("face_shape_id")]
        public ulong FaceShapeId { get; set; }

        [Required(ErrorMessage = "Skin tone ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Skin tone ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Skin tone ID must only contain numbers (0 is not allowed)")]
        [Column("skin_tone_id")]
        public ulong SkinToneId { get; set; }

        [Required(ErrorMessage = "Hair style ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair style ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair style ID must only contain numbers (0 is not allowed)")]
        [Column("hair_style_id")]
        public ulong HairStyleId { get; set; }

        [Required(ErrorMessage = "Hair length ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair length ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair length ID must only contain numbers (0 is not allowed)")]
        [Column("hair_length_id")]
        public ulong HairLengthId { get; set; }

        [Required(ErrorMessage = "Hair colour ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair colour ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair colour ID must only contain numbers (0 is not allowed)")]
        [Column("hair_colour_id")]
        public ulong HairColourId { get; set; }

        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }

        [Column("date_modified", TypeName = "datetime")]
        public DateTime? DateModified { get; set; }

        [ForeignKey(nameof(UserId))]
        [InverseProperty(nameof(Users.UserFeatures))]
        public virtual Users User { get; set; }
    }
}
