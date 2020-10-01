using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("hair_length_links")]
    public partial class HairLengthLinks
    {
        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Column("hair_length_id", TypeName = "int(11)")]
        public int HairLengthId { get; set; }
        [Required]
        [Column("link_name", TypeName = "varchar(128)")]
        public string LinkName { get; set; }
        [Required]
        [Column("link_url", TypeName = "varchar(512)")]
        public string LinkUrl { get; set; }
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [ForeignKey(nameof(HairLengthId))]
        [InverseProperty(nameof(HairLengths.HairLengthLinks))]
        public virtual HairLengths HairLength { get; set; }
    }
}
