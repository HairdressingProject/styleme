using UsersAPI.Models;
using UsersAPI.Services.Context;
using UsersAPIUnitTests.Seeds;
using System;
using System.Collections.Generic;

namespace UsersAPIUnitTests.Fakes
{
    /// <summary>
    /// Fake database containing collections of all the model classes used in the API
    /// </summary>
    public class FakeDatabase
    {
        public List<Users> Users { get; set; }
        public List<UserFeatures> UserFeatures { get; set; }
        public List<Colours> Colours { get; set; }
        public List<FaceShapes> FaceShapes { get; set; }
        public List<FaceShapeLinks> FaceShapeLinks { get; set; }
        public List<HairLengths> HairLengths { get; set; }
        public List<HairLengthLinks> HairLengthLinks { get; set; }
        public List<HairStyles> HairStyles { get; set; }
        public List<HairStyleLinks> HairStyleLinks { get; set; }
        public List<SkinTones> SkinTones { get; set; }
        public List<SkinToneLinks> SkinToneLinks { get; set; }

        public FakeDatabase() { }

        /**
         * USERS
         */
        public void SeedUsers()
        {
            Users = UsersSeed.Seed();
        }

        public UsersContext SeedUsersContext()
        {
            SeedUsers();
            return new UsersContext(Users);
        }

        /**
         * USER FEATURES
         */
        public void SeedUserFeatures()
        {
            UserFeatures = UserFeaturesSeed.Seed();
        }

        public UserFeaturesContext SeedUserFeaturesContext()
        {
            SeedUsers();
            SeedFaceShapes();
            SeedColours();
            SeedHairLengths();
            SeedHairStyles();
            SeedSkinTones();
            SeedUserFeatures();

            return new UserFeaturesContext(
                UserFeatures,
                Users,
                FaceShapes,
                Colours,
                HairLengths,
                HairStyles,
                SkinTones
                );
        }

        /**
         * COLOURS
         */
        public void SeedColours()
        {
            Colours = ColoursSeed.Seed();
        }

        public ColoursContext SeedColoursContext()
        {
            SeedColours();
            return new ColoursContext(Colours);
        }

        /**
         * FACE SHAPES
         */
        public void SeedFaceShapes()
        {
            FaceShapes = FaceShapesSeed.Seed();
        }

        public FaceShapesContext SeedFaceShapesContext()
        {
            SeedFaceShapes();
            return new FaceShapesContext(FaceShapes);
        }

        /**
        * FACE SHAPE LINKS
        */
        public void SeedFaceShapeLinks()
        {
            FaceShapeLinks = FaceShapeLinksSeed.Seed();
        }

        public FaceShapeLinksContext SeedFaceShapeLinksContext()
        {
            SeedFaceShapeLinks();
            return new FaceShapeLinksContext(FaceShapeLinks);
        }

        /**
         * HAIR LENGTHS
         */
        public void SeedHairLengths()
        {
            HairLengths = HairLengthsSeed.Seed();
        }

        public HairLengthsContext SeedHairLengthsContext()
        {
            SeedHairLengths();
            return new HairLengthsContext(HairLengths);
        }

        /**
         * HAIR LENGTH LINKS
         */
        public void SeedHairLengthLinks()
        {
            HairLengthLinks = HairLengthLinksSeed.Seed();
        }

        public HairLengthLinksContext SeedHairLengthLinksContext()
        {
            SeedHairLengthLinks();
            return new HairLengthLinksContext(HairLengthLinks);
        }

        /**
         * HAIR STYLES
         */
        public void SeedHairStyles()
        {
            HairStyles = HairStylesSeed.Seed();
        }

        public HairStylesContext SeedHairStylesContext()
        {
            SeedHairStyles();
            return new HairStylesContext(HairStyles);
        }

        /**
        * HAIR STYLE LINKS
        */
        public void SeedHairStyleLinks()
        {
            HairStyleLinks = HairStyleLinksSeed.Seed();
        }

        public HairStyleLinksContext SeedHairStyleLinksContext()
        {
            SeedHairStyleLinks();
            return new HairStyleLinksContext(HairStyleLinks);
        }

        /**
         * SKIN TONES
         */
        public void SeedSkinTones()
        {
            SkinTones = SkinTonesSeed.Seed();
        }

        public SkinTonesContext SeedSkinTonesContext()
        {
            SeedSkinTones();
            return new SkinTonesContext(SkinTones);
        }

        /**
         * SKIN TONE LINKS
         */
        public void SeedSkinToneLinks()
        {
            SkinToneLinks = SkinToneLinksSeed.Seed();
        }

        public SkinToneLinksContext SeedSkinToneLinksContext()
        {
            SeedSkinToneLinks();
            return new SkinToneLinksContext(SkinToneLinks);
        }
    }
}
