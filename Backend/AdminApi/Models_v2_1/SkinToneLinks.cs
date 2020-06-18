using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class SkinToneLinks
    {
        public ulong Id { get; set; }
        public ulong SkinToneId { get; set; }
        public string LinkName { get; set; }
        public string LinkUrl { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual SkinTones SkinTone { get; set; }
    }
}
