using System;
using System.ComponentModel.DataAnnotations;

namespace UsersAPI.Models.Validation
{
    public class NotNullOrEmptyOrWhiteSpace : ValidationAttribute
    {
        public NotNullOrEmptyOrWhiteSpace() : base("Invalid Field") { }
        public NotNullOrEmptyOrWhiteSpace(string Message) : base(Message) { }

        public override bool IsValid(object value)
        {
            if (value == null) return false;

            if (string.IsNullOrWhiteSpace(value.ToString())) return false;

            if (string.IsNullOrEmpty(value.ToString())) return false;

            return true;
        }

        protected override ValidationResult IsValid(Object value, ValidationContext validationContext)
        {
            if (IsValid(value)) return ValidationResult.Success;
            return new ValidationResult("Value cannot be empty or white space.");
        }
    }
}
