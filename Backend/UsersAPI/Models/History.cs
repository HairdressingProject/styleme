using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.Models
{
    [Table("history")]
    public partial class History
    {
        [Key]
        [Column("id", TypeName = "bigint(20) unsigned")]
        public ulong Id { get; set; }
        [Column("picture_id", TypeName = "bigint(20) unsigned")]
        public ulong PictureId { get; set; }
        [Column("original_picture_id", TypeName = "bigint(20) unsigned")]
        public ulong? OriginalPictureId { get; set; }
        [Column("previous_picture_id", TypeName = "bigint(20) unsigned")]
        public ulong? PreviousPictureId { get; set; }
        [Column("hair_colour_id", TypeName = "bigint(20) unsigned")]
        public ulong? HairColourId { get; set; }
        [Column("hair_style_id", TypeName = "bigint(20) unsigned")]
        public ulong? HairStyleId { get; set; }
        [Column("face_shape_id", TypeName = "bigint(20) unsigned")]
        public ulong? FaceShapeId { get; set; }
        [Column("user_id", TypeName = "bigint(20) unsigned")]
        public ulong UserId { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [ForeignKey(nameof(FaceShapeId))]
        [InverseProperty(nameof(FaceShapes.History))]
        public virtual FaceShapes FaceShape { get; set; }
        [ForeignKey(nameof(HairColourId))]
        [InverseProperty(nameof(Colours.History))]
        public virtual Colours HairColour { get; set; }
        [ForeignKey(nameof(HairStyleId))]
        [InverseProperty(nameof(HairStyles.History))]
        public virtual HairStyles HairStyle { get; set; }
        [ForeignKey(nameof(OriginalPictureId))]
        [InverseProperty(nameof(Pictures.HistoryOriginalPicture))]
        public virtual Pictures OriginalPicture { get; set; }
        [ForeignKey(nameof(PictureId))]
        [InverseProperty(nameof(Pictures.HistoryPicture))]
        public virtual Pictures Picture { get; set; }
        [ForeignKey(nameof(PreviousPictureId))]
        [InverseProperty(nameof(Pictures.HistoryPreviousPicture))]
        public virtual Pictures PreviousPicture { get; set; }
        [ForeignKey(nameof(UserId))]
        [InverseProperty(nameof(Users.History))]
        public virtual Users User { get; set; }
    }
}
