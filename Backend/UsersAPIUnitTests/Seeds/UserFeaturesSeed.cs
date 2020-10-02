using UsersAPI.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace UsersAPIUnitTests.Seeds
{
    public class UserFeaturesSeed
    {
        public static List<UserFeatures> Seed()
        {
            return new List<UserFeatures>
            {
                new UserFeatures
                {
                    Id = 1,
                    UserId = 1,
                    FaceShapeId = 1,
                    HairColourId = 1,
                    HairLengthId = 1,
                    HairStyleId = 1,
                    SkinToneId = 1                    
                },
                new UserFeatures
                {
                    Id = 2,
                    UserId = 2,
                    FaceShapeId = 2,
                    HairColourId = 2,
                    HairLengthId = 2,
                    HairStyleId = 2,
                    SkinToneId = 2
                }
            };
        }
    }
}
