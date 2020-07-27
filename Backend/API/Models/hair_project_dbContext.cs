using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace AdminApi.Models
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

        public virtual DbSet<Colours> Colours { get; set; }
        public virtual DbSet<FaceShapeLinks> FaceShapeLinks { get; set; }
        public virtual DbSet<FaceShapes> FaceShapes { get; set; }
        public virtual DbSet<HairLengthLinks> HairLengthLinks { get; set; }
        public virtual DbSet<HairLengths> HairLengths { get; set; }
        public virtual DbSet<HairStyleLinks> HairStyleLinks { get; set; }
        public virtual DbSet<HairStyles> HairStyles { get; set; }
        public virtual DbSet<SkinTones> SkinTones { get; set; }
        public virtual DbSet<SkinToneLinks> SkinToneLinks { get; set; }
        public virtual DbSet<UserFeatures> UserFeatures { get; set; }
        public virtual DbSet<Users> Users { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            /*if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseMySql("server=localhost;database=hair_project_db;user=dev_admin;password=administrator;treattinyasboolean=true", x => x.ServerVersion("8.0.19"));
            }*/ // ToDo: protec the connection string
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Colours>(entity =>
            {
                entity.ToTable("colours");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.ColourHash)
                    .IsRequired()
                    .HasColumnName("colour_hash")
                    .HasColumnType("varchar(64)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.ColourName)
                    .IsRequired()
                    .HasColumnName("colour_name")
                    .HasColumnType("varchar(64)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();
            });

            modelBuilder.Entity<FaceShapeLinks>(entity =>
            {
                entity.ToTable("face_shape_links");

                entity.HasIndex(e => e.FaceShapeId)
                    .HasName("face_shape_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.FaceShapeId)
                    .HasColumnName("face_shape_id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.LinkName)
                    .IsRequired()
                    .HasColumnName("link_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .IsRequired()
                    .HasColumnName("link_url")
                    .HasColumnType("varchar(512)")
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
                entity.ToTable("face_shapes");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.ShapeName)
                    .IsRequired()
                    .HasColumnName("shape_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<HairLengthLinks>(entity =>
            {
                entity.ToTable("hair_length_links");

                entity.HasIndex(e => e.HairLengthId)
                    .HasName("hair_length_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.HairLengthId)
                    .HasColumnName("hair_length_id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.LinkName)
                    .IsRequired()
                    .HasColumnName("link_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .IsRequired()
                    .HasColumnName("link_url")
                    .HasColumnType("varchar(512)")
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
                entity.ToTable("hair_lengths");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.HairLengthName)
                    .IsRequired()
                    .HasColumnName("hair_length_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<HairStyleLinks>(entity =>
            {
                entity.ToTable("hair_style_links");

                entity.HasIndex(e => e.HairStyleId)
                    .HasName("hair_style_id");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.HairStyleId)
                    .HasColumnName("hair_style_id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.LinkName)
                    .IsRequired()
                    .HasColumnName("link_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .IsRequired()
                    .HasColumnName("link_url")
                    .HasColumnType("varchar(512)")
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
                entity.ToTable("hair_styles");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.HairStyleName)
                    .IsRequired()
                    .HasColumnName("hair_style_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<SkinTones>(entity =>
            {
                entity.ToTable("skin_tones");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.SkinToneName)
                    .IsRequired()
                    .HasColumnName("skin_tone_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            modelBuilder.Entity<SkinToneLinks>(entity =>
            {
                entity.ToTable("skin_tone_links");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.HasIndex(e => e.SkinToneId)
                    .HasName("skin_tone_id");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.LinkName)
                    .IsRequired()
                    .HasColumnName("link_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LinkUrl)
                    .IsRequired()
                    .HasColumnName("link_url")
                    .HasColumnType("varchar(512)")
                    .HasDefaultValueSql("'** ERROR: missing category **'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.SkinToneId)
                    .HasColumnName("skin_tone_id")
                    .HasColumnType("bigint(20) unsigned");

                entity.HasOne(d => d.SkinTone)
                    .WithMany(p => p.SkinToneLinks)
                    .HasForeignKey(d => d.SkinToneId)
                    .HasConstraintName("skin_tone_links_ibfk_1");
            });

            modelBuilder.Entity<UserFeatures>(entity =>
            {
                entity.ToTable("user_features");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.HasIndex(e => e.UserId)
                    .HasName("user_id");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.FaceShapeId)
                    .HasColumnName("face_shape_id")
                    .HasColumnType("bigint(20)");

                entity.Property(e => e.HairColourId)
                    .HasColumnName("hair_colour_id")
                    .HasColumnType("bigint(20)");

                entity.Property(e => e.HairLengthId)
                    .HasColumnName("hair_length_id")
                    .HasColumnType("bigint(20)");

                entity.Property(e => e.HairStyleId)
                    .HasColumnName("hair_style_id")
                    .HasColumnType("bigint(20)");

                entity.Property(e => e.SkinToneId)
                    .HasColumnName("skin_tone_id")
                    .HasColumnType("bigint(20)");

                entity.Property(e => e.UserId)
                    .HasColumnName("user_id")
                    .HasColumnType("bigint(20) unsigned");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserFeatures)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("user_features_ibfk_1");
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.ToTable("users");

                entity.HasIndex(e => e.Id)
                    .HasName("id_2");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasColumnType("bigint(20) unsigned");

                entity.Property(e => e.DateCreated)
                    .HasColumnName("date_created")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified)
                    .HasColumnName("date_modified")
                    .HasColumnType("datetime")
                    .ValueGeneratedOnAddOrUpdate();

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasColumnName("first_name")
                    .HasColumnType("varchar(128)")
                    .HasDefaultValueSql("'user'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.LastName)
                    .HasColumnName("last_name")
                    .HasColumnType("varchar(128)")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserEmail)
                    .IsRequired()
                    .HasColumnName("user_email")
                    .HasColumnType("varchar(512)")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasColumnName("user_name")
                    .HasColumnType("varchar(32)")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserPassword)
                    .IsRequired()
                    .HasColumnName("user_password")
                    .HasColumnType("varchar(512)")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");

                entity.Property(e => e.UserRole)
                    .IsRequired()
                    .HasColumnName("user_role")
                    .HasColumnType("enum('admin','developer','user')")
                    .HasDefaultValueSql("'user'")
                    .HasCharSet("utf8mb4")
                    .HasCollation("utf8mb4_general_ci");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
