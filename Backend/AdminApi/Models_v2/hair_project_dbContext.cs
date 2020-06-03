using Microsoft.EntityFrameworkCore;

namespace AdminApi.Models_v2
{
    public partial class hair_project_dbContext : DbContext
    {
        public hair_project_dbContext()
        {
        }

        public hair_project_dbContext(DbContextOptions<hair_project_dbContext> options)
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
        public virtual DbSet<SkinToneLinks> SkinToneLinks { get; set; }
        public virtual DbSet<SkinTones> SkinTones { get; set; }
        public virtual DbSet<UserFeatures> UserFeatures { get; set; }
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

                entity.Property(e => e.AccountConfirmed).HasDefaultValueSql("'0'");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.RecoverPasswordToken).IsFixedLength();

                entity.Property(e => e.UnusualActivity).HasDefaultValueSql("'0'");

                entity.HasOne(d => d.User)
                    .WithOne(p => p.Accounts)
                    .HasForeignKey<Accounts>(d => d.UserId)
                    .OnDelete(DeleteBehavior.Cascade) // .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_user_id");
            });

            modelBuilder.Entity<Colours>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.ColourHash)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.ColourName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();
            });

            modelBuilder.Entity<FaceShapeLinks>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("face_shape_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

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
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

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
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

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
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

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
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

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
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.HairStyleName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<SkinToneLinks>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.HasIndex(e => e.SkinToneId)
                    .HasName("skin_tone_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.LinkName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.HasOne(d => d.SkinTone)
                    .WithMany(p => p.SkinToneLinks)
                    .HasForeignKey(d => d.SkinToneId)
                    .HasConstraintName("skin_tone_links_ibfk_1");
            });

            modelBuilder.Entity<SkinTones>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.SkinToneName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<UserFeatures>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.HasIndex(e => new { e.UserId, e.FaceShapeId, e.SkinToneId, e.HairStyleId, e.HairLengthId, e.HairColourId })
                    .HasName("user_id")
                    .IsUnique();

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserFeatures)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("user_features_ibfk_1");
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.HasIndex(e => e.UserEmail)
                    .HasName("user_email")
                    .IsUnique();

                entity.HasIndex(e => e.UserName)
                    .HasName("user_name")
                    .IsUnique();

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).ValueGeneratedOnAddOrUpdate();

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

                entity.Property(e => e.UserPassword)
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
