using AdminApi.Models_v2;

namespace AdminApi.Entities
{
    public class User
    {
        public ulong? Id { get; set; }

        // This property stores the token needed for authentication
        public string Token { get; set; }

        public Users BaseUser { get; set; }

        public User(ulong? id, string token = null, Users baseUser = null)
        {
            Id = id;
            Token = token;
            BaseUser = baseUser;
        }
    }
}
