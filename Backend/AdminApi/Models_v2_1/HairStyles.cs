using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class HairStyles
    {
        public HairStyles()
        {
            HairStyleLinks = new HashSet<HairStyleLinks>();
        }

        public ulong Id { get; set; }
        public string HairStyleName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual ICollection<HairStyleLinks> HairStyleLinks { get; set; }
    }
}
