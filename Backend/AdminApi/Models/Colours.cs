using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class Colours
    {
        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Colour name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Colour name should not be empty or white space")]
        [MaxLength(64)]
        [JsonPropertyName("colour_name")]
        public string ColourName { get; set; }

        [Required(ErrorMessage = "Colour hash is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Colour hash should not be empty or white space")]
        [RegularExpression(@"^(#[a-fA-F0-9]{3}$)|(#[a-fA-F0-9]{6}$)",
            ErrorMessage = @"The colour hash must be a HEX code with one of the following patterns: #333 or #333333")]
        [JsonPropertyName("colour_hash")]
        public string ColourHash { get; set; }

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }
    }
}
