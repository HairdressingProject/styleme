using System.Collections.Generic;
using System.Linq;
using UsersAPI.Models;

namespace UsersAPI.Helpers
{
    public static class ExtensionMethods
    {
        public static IEnumerable<Users> WithoutPasswords(this IEnumerable<Users> users)
        {
            return users.Select(x => x.WithoutPassword());
        }

        public static Users WithoutPassword(this Users user)
        {
            user.UserPasswordHash = null;
            user.UserPasswordSalt = null;
            return user;
        }
    }
}
