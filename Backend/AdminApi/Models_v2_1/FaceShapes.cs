using System;
using System.Collections.Generic;

namespace AdminApi.Models_v2_1
{
    public partial class FaceShapes
    {
        public FaceShapes()
        {
            FaceShapeLinks = new HashSet<FaceShapeLinks>();
        }

        public ulong Id { get; set; }
        public string ShapeName { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }

        public virtual ICollection<FaceShapeLinks> FaceShapeLinks { get; set; }
    }
}
