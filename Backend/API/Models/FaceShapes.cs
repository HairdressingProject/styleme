using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class FaceShapes
    {
        public FaceShapes()
        {
            FaceShapeLinks = new HashSet<FaceShapeLinks>();
        }

        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Shape name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Shape name should not be empty or white space")]
        [MaxLength(128)]
        [JsonPropertyName("shape_name")]
        public string ShapeName { get; set; }

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }

        [JsonPropertyName("face_shape_links")]
        public virtual ICollection<FaceShapeLinks> FaceShapeLinks { get; set; }
    }
}
