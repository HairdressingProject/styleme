using Microsoft.EntityFrameworkCore;

namespace UsersAPI.Models
{
    public partial class hairdressing_project_dbContext : DbContext
    {
        public hairdressing_project_dbContext()
        {
        }

        public hairdressing_project_dbContext(DbContextOptions<hairdressing_project_dbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Accounts> Accounts { get; set; }
        public virtual DbSet<Colours> Colours { get; set; }
        public virtual DbSet<FaceShapeLinks> FaceShapeLinks { get; set; }
        public virtual DbSet<FaceShapes> FaceShapes { get; set; }
        public virtual DbSet<HairLengthLinks> HairLengthLinks { get; set; }
        public virtual DbSet<HairLengths> HairLengths { get; set; }
        public virtual DbSet<HairStyleLinks> HairStyleLinks { get; set; }
        public virtual DbSet<HairStyles> HairStyles { get; set; }
        public virtual DbSet<History> History { get; set; }
        public virtual DbSet<ModelPictures> ModelPictures { get; set; }
        public virtual DbSet<Pictures> Pictures { get; set; }
        public virtual DbSet<Users> Users { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Accounts>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PRIMARY");

                entity.HasIndex(e => e.RecoverPasswordToken)
                    .HasName("recover_password_token")
                    .IsUnique();

                entity.HasIndex(e => e.UserId)
                    .HasName("user_id");

                entity.Property(e => e.UserId).ValueGeneratedNever();

                entity.Property(e => e.AccountConfirmed).HasDefaultValueSql("'0'");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.RecoverPasswordToken).IsFixedLength();

                entity.Property(e => e.UnusualActivity).HasDefaultValueSql("'0'");

                entity.HasOne(d => d.User)
                    .WithOne(p => p.Accounts)
                    .HasForeignKey<Accounts>(d => d.UserId)
                    .HasConstraintName("fk_user_id");
            });

            modelBuilder.Entity<Colours>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.ColourHash)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.ColourName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();
            });

            modelBuilder.Entity<FaceShapeLinks>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("face_shape_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.LinkName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.HasOne(d => d.FaceShape)
                    .WithMany(p => p.FaceShapeLinks)
                    .HasForeignKey(d => d.FaceShapeId)
                    .HasConstraintName("face_shape_links_ibfk_1");
            });

            modelBuilder.Entity<FaceShapes>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.ShapeName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<HairLengthLinks>(entity =>
            {
                entity.HasIndex(e => e.HairLengthId)
                    .HasName("hair_length_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.LinkName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.HasOne(d => d.HairLength)
                    .WithMany(p => p.HairLengthLinks)
                    .HasForeignKey(d => d.HairLengthId)
                    .HasConstraintName("hair_length_links_ibfk_1");
            });

            modelBuilder.Entity<HairLengths>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.HairLengthName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<HairStyleLinks>(entity =>
            {
                entity.HasIndex(e => e.HairStyleId)
                    .HasName("hair_style_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.LinkName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.HasOne(d => d.HairStyle)
                    .WithMany(p => p.HairStyleLinks)
                    .HasForeignKey(d => d.HairStyleId)
                    .HasConstraintName("hair_style_links_ibfk_1");
            });

            modelBuilder.Entity<HairStyles>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.HairStyleName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<History>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("fk_history_face_shape_id");

                entity.HasIndex(e => e.HairColourId)
                    .HasName("fk_history_hair_colour_id");

                entity.HasIndex(e => e.HairStyleId)
                    .HasName("fk_history_hair_style_id");

                entity.HasIndex(e => e.OriginalPictureId)
                    .HasName("fk_history_original_picture_id");

                entity.HasIndex(e => e.PictureId)
                    .HasName("fk_history_picture_id");

                entity.HasIndex(e => e.PreviousPictureId)
                    .HasName("fk_history_previous_picture_id");

                entity.HasIndex(e => e.UserId)
                    .HasName("fk_history_user_id");

                entity.HasIndex(e => new { e.Id, e.PictureId, e.OriginalPictureId, e.PreviousPictureId, e.HairColourId, e.HairStyleId, e.FaceShapeId, e.UserId })
                    .HasName("id")
                    .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0, 0, 0, 0, 0, 0, 0 });

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.HasOne(d => d.FaceShape)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.FaceShapeId)
                    .HasConstraintName("fk_history_face_shape_id");

                entity.HasOne(d => d.HairColour)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.HairColourId)
                    .HasConstraintName("fk_history_hair_colour_id");

                entity.HasOne(d => d.HairStyle)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.HairStyleId)
                    .HasConstraintName("fk_history_hair_style_id");

                entity.HasOne(d => d.OriginalPicture)
                    .WithMany(p => p.HistoryOriginalPicture)
                    .HasForeignKey(d => d.OriginalPictureId)
                    .HasConstraintName("fk_history_original_picture_id");

                entity.HasOne(d => d.Picture)
                    .WithMany(p => p.HistoryPicture)
                    .HasForeignKey(d => d.PictureId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_history_picture_id");

                entity.HasOne(d => d.PreviousPicture)
                    .WithMany(p => p.HistoryPreviousPicture)
                    .HasForeignKey(d => d.PreviousPictureId)
                    .HasConstraintName("fk_history_previous_picture_id");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_history_user_id");
            });

            modelBuilder.Entity<ModelPictures>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("fk_face_shape_id");

                entity.HasIndex(e => e.FileName)
                    .HasName("file_name")
                    .IsUnique();

                entity.HasIndex(e => e.HairColourId)
                    .HasName("fk_hair_colour_id");

                entity.HasIndex(e => e.HairLengthId)
                    .HasName("fk_hair_length_id");

                entity.HasIndex(e => e.HairStyleId)
                    .HasName("fk_hair_style_id");

                entity.HasIndex(e => new { e.Id, e.FileName, e.FilePath, e.HairStyleId, e.HairLengthId, e.FaceShapeId, e.HairColourId })
                    .HasName("id")
                    .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0, 0, 0, 0, 0, 0 });

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.FileName)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.FilePath)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.HasOne(d => d.FaceShape)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.FaceShapeId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("fk_face_shape_id");

                entity.HasOne(d => d.HairColour)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.HairColourId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("fk_hair_colour_id");

                entity.HasOne(d => d.HairLength)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.HairLengthId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("fk_hair_length_id");

                entity.HasOne(d => d.HairStyle)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.HairStyleId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("fk_hair_style_id");
            });

            modelBuilder.Entity<Pictures>(entity =>
            {
                entity.HasIndex(e => e.FileName)
                    .HasName("file_name")
                    .IsUnique();

                entity.HasIndex(e => new { e.Id, e.FileName, e.FilePath })
                    .HasName("id")
                    .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0, 0 });

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.FileName)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.FilePath)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id");

                entity.HasIndex(e => e.UserEmail)
                    .HasName("user_email")
                    .IsUnique();

                entity.HasIndex(e => e.UserName)
                    .HasName("user_name")
                    .IsUnique();

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.DateUpdated).ValueGeneratedOnUpdate();

                entity.Property(e => e.FirstName)
                    .HasDefaultValueSql("'user'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LastName)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserEmail)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserName)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserPasswordHash)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserPasswordSalt)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserRole)
                    .HasDefaultValueSql("'user'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
