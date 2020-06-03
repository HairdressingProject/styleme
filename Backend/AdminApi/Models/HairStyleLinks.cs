using AdminApi.Validation;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class HairStyleLinks
    {
        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Hair style ID is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair style ID should not be empty or white space")]
        [RegularExpression(@"^[1-9]{1}$|^[1-9][0-9]+$", ErrorMessage = @"Hair style ID must only contain numbers (0 is not allowed)")]
        [JsonPropertyName("hair_style_id")]
        public ulong HairStyleId { get; set; }

        [Required(ErrorMessage = "Link name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Link name should not be empty or white space")]
        [MaxLength(128)]
        [JsonPropertyName("link_name")]
        public string LinkName { get; set; }

        [Required(ErrorMessage = "Link URL is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Link URL should not be empty or white space")]
        [MaxLength(512)]
        [JsonPropertyName("link_url")]
        public string LinkUrl { get; set; }

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }

        [JsonPropertyName("hair_style")]
        public virtual HairStyles HairStyle { get; set; }
    }
}
