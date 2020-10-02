using UsersAPI.Models;

namespace UsersAPI.Entities
{
    public class TokenisedUser
    {
        public ulong? Id { get; set; }

        // This property stores the token needed for authentication
        public string Token { get; set; }

        public Users BaseUser { get; set; }

        public TokenisedUser(ulong? id, string token = null, Users baseUser = null)
        {
            Id = id;
            Token = token;
            BaseUser = baseUser;
        }
    }
}
