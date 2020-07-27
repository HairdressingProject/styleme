using AdminApi.Helpers;
using System;
using System.ComponentModel.DataAnnotations;

namespace AdminApi.Models_v2_1.Validation
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
