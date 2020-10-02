using UsersAPI.Helpers;
using System;
using System.ComponentModel.DataAnnotations;

namespace UsersAPI.Models.Validation
{
    public class RequiredUserRole : RequiredAttribute
    {
        public override bool IsValid(object value)
        {
            if (value == null) return false;

            return string.Equals(value.ToString(), value.ToString().Trim()) && Enum.TryParse<UserRoles>(value.ToString().ToUpper(), out _);
        }
    }
}
