using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace UsersAPI.GeneratedModels
{
    public partial class fastapi_picturesContext : DbContext
    {
        public fastapi_picturesContext()
        {
        }

        public fastapi_picturesContext(DbContextOptions<fastapi_picturesContext> options)
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
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseMySql("server=localhost;database=fastapi_pictures;user=pictures-admin;password=Password1;treattinyasboolean=true", x => x.ServerVersion("10.5.4-mariadb"));
            }
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
                    .HasName("ix_accounts_user_id");

                entity.Property(e => e.UserId).ValueGeneratedNever();

                entity.Property(e => e.AccountConfirmed).HasDefaultValueSql("'0'");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.UnusualActivity).HasDefaultValueSql("'0'");

                entity.HasOne(d => d.User)
                    .WithOne(p => p.Accounts)
                    .HasForeignKey<Accounts>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("accounts_ibfk_1");
            });

            modelBuilder.Entity<Colours>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("ix_colours_id");

                entity.Property(e => e.ColourHash)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.ColourName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");
            });

            modelBuilder.Entity<FaceShapeLinks>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("face_shape_id");

                entity.HasIndex(e => e.Id)
                    .HasName("ix_face_shape_links_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

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
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("face_shape_links_ibfk_1");
            });

            modelBuilder.Entity<FaceShapes>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("ix_face_shapes_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

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
                    .HasName("ix_hair_length_links_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

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
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("hair_length_links_ibfk_1");
            });

            modelBuilder.Entity<HairLengths>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("ix_hair_lengths_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

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
                    .HasName("ix_hair_style_links_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

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
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("hair_style_links_ibfk_1");
            });

            modelBuilder.Entity<HairStyles>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("ix_hair_styles_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.HairStyleName)
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<History>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("ix_history_face_shape_id");

                entity.HasIndex(e => e.HairColourId)
                    .HasName("ix_history_hair_colour_id");

                entity.HasIndex(e => e.HairStyleId)
                    .HasName("ix_history_hair_style_id");

                entity.HasIndex(e => e.Id)
                    .HasName("ix_history_id");

                entity.HasIndex(e => e.OriginalPictureId)
                    .HasName("ix_history_original_picture_id");

                entity.HasIndex(e => e.PictureId)
                    .HasName("ix_history_picture_id");

                entity.HasIndex(e => e.PreviousPictureId)
                    .HasName("ix_history_previous_picture_id");

                entity.HasIndex(e => e.UserId)
                    .HasName("ix_history_user_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.HasOne(d => d.FaceShape)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.FaceShapeId)
                    .HasConstraintName("history_ibfk_6");

                entity.HasOne(d => d.HairColour)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.HairColourId)
                    .HasConstraintName("history_ibfk_4");

                entity.HasOne(d => d.HairStyle)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.HairStyleId)
                    .HasConstraintName("history_ibfk_5");

                entity.HasOne(d => d.OriginalPicture)
                    .WithMany(p => p.HistoryOriginalPicture)
                    .HasForeignKey(d => d.OriginalPictureId)
                    .HasConstraintName("history_ibfk_2");

                entity.HasOne(d => d.Picture)
                    .WithMany(p => p.HistoryPicture)
                    .HasForeignKey(d => d.PictureId)
                    .HasConstraintName("history_ibfk_1");

                entity.HasOne(d => d.PreviousPicture)
                    .WithMany(p => p.HistoryPreviousPicture)
                    .HasForeignKey(d => d.PreviousPictureId)
                    .HasConstraintName("history_ibfk_3");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.History)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("history_ibfk_7");
            });

            modelBuilder.Entity<ModelPictures>(entity =>
            {
                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("face_shape_id");

                entity.HasIndex(e => e.FileName)
                    .HasName("file_name")
                    .IsUnique();

                entity.HasIndex(e => e.HairColourId)
                    .HasName("hair_colour_id");

                entity.HasIndex(e => e.HairLengthId)
                    .HasName("hair_length_id");

                entity.HasIndex(e => e.HairStyleId)
                    .HasName("hair_style_id");

                entity.HasIndex(e => e.Id)
                    .HasName("ix_model_pictures_id");

                entity.Property(e => e.FileName)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.FilePath)
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.HasOne(d => d.FaceShape)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.FaceShapeId)
                    .HasConstraintName("model_pictures_ibfk_3");

                entity.HasOne(d => d.HairColour)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.HairColourId)
                    .HasConstraintName("model_pictures_ibfk_4");

                entity.HasOne(d => d.HairLength)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.HairLengthId)
                    .HasConstraintName("model_pictures_ibfk_2");

                entity.HasOne(d => d.HairStyle)
                    .WithMany(p => p.ModelPictures)
                    .HasForeignKey(d => d.HairStyleId)
                    .HasConstraintName("model_pictures_ibfk_1");
            });

            modelBuilder.Entity<Pictures>(entity =>
            {
                entity.HasIndex(e => e.FileName)
                    .HasName("file_name")
                    .IsUnique();

                entity.HasIndex(e => e.Id)
                    .HasName("ix_pictures_id");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

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
                    .HasName("ix_users_id");

                entity.HasIndex(e => e.UserEmail)
                    .HasName("user_email")
                    .IsUnique();

                entity.HasIndex(e => e.UserName)
                    .HasName("user_name")
                    .IsUnique();

                entity.Property(e => e.DateCreated).HasDefaultValueSql("current_timestamp()");

                entity.Property(e => e.FirstName)
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
