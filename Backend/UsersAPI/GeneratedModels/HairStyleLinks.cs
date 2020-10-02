using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("hair_style_links")]
    public partial class HairStyleLinks
    {
        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
        [Column("hair_style_id", TypeName = "int(11)")]
        public int HairStyleId { get; set; }
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

        [ForeignKey(nameof(HairStyleId))]
        [InverseProperty(nameof(HairStyles.HairStyleLinks))]
        public virtual HairStyles HairStyle { get; set; }
    }
}
