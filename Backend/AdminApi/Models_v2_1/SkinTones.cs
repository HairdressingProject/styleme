using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class SkinTones
    {
        public SkinTones()
        {
            SkinToneLinks = new HashSet<SkinToneLinks>();
        }

        public ulong Id { get; set; }
        public string SkinToneName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual ICollection<SkinToneLinks> SkinToneLinks { get; set; }
    }
}
