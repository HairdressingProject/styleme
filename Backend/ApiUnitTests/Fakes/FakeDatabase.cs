using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Seeds;
using System;
using System.Collections.Generic;

namespace ApiUnitTests.Fakes
{
    /// <summary>
    /// Fake database containing collections of all the model classes used in the API
    /// </summary>
    public class FakeDatabase
    {
        public List<Users> Users { get; set; }
        public List<Colours> Colours { get; set; }
        public List<FaceShapes> FaceShapes { get; set; }
        public List<HairLengths> HairLengths { get; set; }
        public List<HairStyles> HairStyles { get; set; }

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
    }
}
