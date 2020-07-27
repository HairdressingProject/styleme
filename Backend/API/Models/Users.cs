using AdminApi.Helpers;
using AdminApi.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AdminApi.Models
{
    public partial class Users
    {
        public Users()
        {
            UserFeatures = new HashSet<UserFeatures>();
        }

        /**
         * JsonPropertyNames are important to map each property from JSON POST/PUT requests to the corresponding column name in the database
         * Otherwise an exception may be thrown
         * An alternative is to import NewtonSoftJson and add this code to the ConfigureServices method in the Startup.cs file:
         * 
         * services
         * .AddControllers()
         * .AddNewtonsoftJson(options => 
         *                      options
         *                      .SerializerSettings
         *                      .ContractResolver = new DefaultContractResolver() 
         *                      { 
         *                          NamingStrategy = new SnakeCaseNamingStrategy() 
         *                      })
         * 
         * However, the solution in place uses the native System.Text.Json module
         * See: https://github.com/dotnet/runtime/issues/782
         * 
         */
        [JsonPropertyName("id")]
        public ulong? Id { get; set; }

        [Required(ErrorMessage = "Username is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Username should not be empty or white space")]
        [MaxLength(32)]
        [JsonPropertyName("user_name")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Password is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Password should not be empty or white space")]
        [MinLength(6, ErrorMessage = "Password should contain at least 6 characters")]
        [MaxLength(512, ErrorMessage = "Password cannot exceed 512 characters")]
        [JsonPropertyName("user_password")]
        public string UserPassword { get; set; }

        [Required(ErrorMessage = "Email is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"Email should not be empty or white space")]
        [MaxLength(512)]
        [JsonPropertyName("user_email")]
        public string UserEmail { get; set; }

        [Required(ErrorMessage = "First name is required", AllowEmptyStrings = false)]
        [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"First name should not be empty or white space")]
        [MaxLength(128)]
        [JsonPropertyName("first_name")]
        public string FirstName { get; set; }

        [MaxLength(128)]
        [JsonPropertyName("last_name")]
        public string LastName { get; set; }

        // [NotNullOrEmptyOrWhiteSpace(ErrorMessage = @"User role should not be empty or white space")]
        // [RequiredUserRole(AllowEmptyStrings = false, ErrorMessage = "Invalid user role.")]
        [JsonPropertyName("user_role")]
        public string UserRole { get; set; } = Enum.GetName(typeof(UserRoles), UserRoles.USER).ToLower();

        [JsonPropertyName("date_created")]
        public DateTime DateCreated { get; set; }

        [JsonPropertyName("date_modified")]
        public DateTime? DateModified { get; set; }

        [JsonPropertyName("user_features")]
        public virtual ICollection<UserFeatures> UserFeatures { get; set; }
    }
}
