﻿using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.Models
{
    [Table("model_pictures")]
    public partial class ModelPictures
    {
        [Key]
        [Column("id", TypeName = "bigint(20) unsigned")]
        public ulong Id { get; set; }
        [Required]
        [Column("file_name", TypeName = "varchar(255)")]
        public string FileName { get; set; }
        [Column("file_path", TypeName = "varchar(255)")]
        public string FilePath { get; set; }
        [Column("file_size", TypeName = "int(11)")]
        public int? FileSize { get; set; }
        [Column("height", TypeName = "int(11)")]
        public int? Height { get; set; }
        [Column("width", TypeName = "int(11)")]
        public int? Width { get; set; }
        [Column("hair_style_id", TypeName = "bigint(20) unsigned")]
        public ulong? HairStyleId { get; set; }
        [Column("hair_length_id", TypeName = "bigint(20) unsigned")]
        public ulong? HairLengthId { get; set; }
        [Column("face_shape_id", TypeName = "bigint(20) unsigned")]
        public ulong? FaceShapeId { get; set; }
        [Column("hair_colour_id", TypeName = "bigint(20) unsigned")]
        public ulong? HairColourId { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [ForeignKey(nameof(FaceShapeId))]
        [InverseProperty(nameof(FaceShapes.ModelPictures))]
        public virtual FaceShapes FaceShape { get; set; }
        [ForeignKey(nameof(HairColourId))]
        [InverseProperty(nameof(Colours.ModelPictures))]
        public virtual Colours HairColour { get; set; }
        [ForeignKey(nameof(HairLengthId))]
        [InverseProperty(nameof(HairLengths.ModelPictures))]
        public virtual HairLengths HairLength { get; set; }
        [ForeignKey(nameof(HairStyleId))]
        [InverseProperty(nameof(HairStyles.ModelPictures))]
        public virtual HairStyles HairStyle { get; set; }
    }
}
