using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class SkinTones
    {
        public SkinTones()
        {
            SkinToneLinks = new HashSet<SkinToneLinks>();
        }

        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Skin tone name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Skin tone name should not be empty or white space")]
        [MaxLength(128)]
        [JsonPropertyName("skin_tone_name")]
        public string SkinToneName { get; set; }

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }

        [JsonPropertyName("skin_tone_links")]
        public virtual ICollection<SkinToneLinks> SkinToneLinks { get; set; }
    }
}
