using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class HairStyles
    {
        public HairStyles()
        {
            HairStyleLinks = new HashSet<HairStyleLinks>();
        }

        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Hair style name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Hair style name should not be empty or white space")]
        [MaxLength(128)]
        [JsonPropertyName("hair_style_name")]
        public string HairStyleName { get; set; }

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }

        [JsonPropertyName("hair_style_links")]
        public virtual ICollection<HairStyleLinks> HairStyleLinks { get; set; }
    }
}
