using AdminApi.Models_v2_1;
using System;
using System.Collections.Generic;
using System.Text;

namespace ApiUnitTests.Seeds
{
    public class HairStyleLinksSeed
    {
        public static List<HairStyleLinks> Seed()
        {
            return new List<HairStyleLinks>
            {
                new HairStyleLinks
                {
                    Id = 1,
                    LinkName = "bob link",
                    LinkUrl = "https://content.latest-hairstyles.com/wp-content/uploads/layered-bob-hairstyles.jpg",
                    HairStyleId = 1
                },
                new HairStyleLinks
                {
                    Id = 2,
                    LinkName = "afro link",
                    LinkUrl = "https://i.pinimg.com/originals/71/f2/64/71f26409a5258363fff337f0219ecaeb.jpg",
                    HairStyleId = 2
                }
            };
        }
    }
}
