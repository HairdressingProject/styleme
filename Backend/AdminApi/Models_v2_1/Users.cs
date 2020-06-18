using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class Users
    {
        public Users()
        {
            UserFeatures = new HashSet<UserFeatures>();
        }

        public ulong Id { get; set; }
        public string UserName { get; set; }
        public string UserPasswordHash { get; set; }
        public string UserPasswordSalt { get; set; }
        public string UserEmail { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string UserRole { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual Accounts Accounts { get; set; }
        public virtual ICollection<UserFeatures> UserFeatures { get; set; }
    }
}
