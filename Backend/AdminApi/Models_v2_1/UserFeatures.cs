using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class UserFeatures
    {
        public ulong Id { get; set; }
        public ulong UserId { get; set; }
        public long FaceShapeId { get; set; }
        public long SkinToneId { get; set; }
        public long HairStyleId { get; set; }
        public long HairLengthId { get; set; }
        public long HairColourId { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual Users User { get; set; }
    }
}
