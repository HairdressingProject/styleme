using UsersAPI.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace UsersAPIUnitTests.Seeds
{
    public class FaceShapesSeed
    {
        public static List<FaceShapes> Seed()
        {
            return new List<FaceShapes>
            {
                new FaceShapes
                {
                    Id = 1,
                    ShapeName = "oval"
                },
                new FaceShapes
                {
                    Id = 2,
                    ShapeName = "rectangular"
                }
            };
        }
    }
}
