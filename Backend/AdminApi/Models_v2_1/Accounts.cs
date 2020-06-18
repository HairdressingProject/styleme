using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class Accounts
    {
        public ulong UserId { get; set; }
        public byte[] RecoverPasswordToken { get; set; }
        public bool? AccountConfirmed { get; set; }
        public bool? UnusualActivity { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual Users User { get; set; }
    }
}
