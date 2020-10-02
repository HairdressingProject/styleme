using UsersAPI.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace UsersAPIUnitTests.Seeds
{
    public class SkinToneLinksSeed
    {
        public static List<SkinToneLinks> Seed()
        {
            return new List<SkinToneLinks>
            {
                new SkinToneLinks
                {
                    Id = 1,
                    LinkName = "ivory link",
                    LinkUrl = "https://skincaregeeks.com/wp-content/uploads/2020/02/what-is-ivory-skin-tone.jpg",
                    SkinToneId = 1
                },
                new SkinToneLinks
                {
                    Id = 2,
                    LinkName = "chocolate link",
                    LinkUrl = "https://i.pinimg.com/originals/c2/08/c4/c208c4bd1f2478dec4d44dd7ae015fc9.jpg",
                    SkinToneId = 2
                }
            };
        }
    }
}
