using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class UserFeatures
    {
        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "User ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"User ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("user_id")]
        public ulong UserId { get; set; }

        [Required(ErrorMessage = "Face shape ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Face shape ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Face shape ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("face_shape_id")]
        public ulong FaceShapeId { get; set; }

        [Required(ErrorMessage = "Skin tone ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Skin tone ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Skin tone ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("skin_tone_id")]
        public ulong SkinToneId { get; set; }

        [Required(ErrorMessage = "Hair style ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair style ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair style ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("hair_style_id")]
        public ulong HairStyleId { get; set; }

        [Required(ErrorMessage = "Hair length ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair length ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair length ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("hair_length_id")]
        public ulong HairLengthId { get; set; }

        [Required(ErrorMessage = "Hair colour ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair colour ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair colour ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("hair_colour_id")]
        public ulong HairColourId { get; set; }

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }

        [JsonPropertyName("user")]
        public virtual Users User { get; set; }
    }
}
