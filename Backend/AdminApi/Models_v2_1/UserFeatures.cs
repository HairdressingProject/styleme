using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class UserFeatures
    {
        public ulong Id { get; set; }
        public ulong UserId { get; set; }
        public ulong FaceShapeId { get; set; }
        public ulong SkinToneId { get; set; }
        public ulong HairStyleId { get; set; }
        public ulong HairLengthId { get; set; }
        public ulong HairColourId { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual Users User { get; set; }
    }
}
