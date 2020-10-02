using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UsersAPI.GeneratedModels
{
    [Table("pictures")]
    public partial class Pictures
    {
        public Pictures()
        {
            HistoryOriginalPicture = new HashSet<History>();
            HistoryPicture = new HashSet<History>();
            HistoryPreviousPicture = new HashSet<History>();
        }

        [Key]
        [Column("id", TypeName = "int(11)")]
        public int Id { get; set; }
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
        [Column("date_created", TypeName = "datetime")]
        public DateTime? DateCreated { get; set; }
        [Column("date_updated", TypeName = "datetime")]
        public DateTime? DateUpdated { get; set; }

        [InverseProperty(nameof(History.OriginalPicture))]
        public virtual ICollection<History> HistoryOriginalPicture { get; set; }
        [InverseProperty(nameof(History.Picture))]
        public virtual ICollection<History> HistoryPicture { get; set; }
        [InverseProperty(nameof(History.PreviousPicture))]
        public virtual ICollection<History> HistoryPreviousPicture { get; set; }
    }
}
