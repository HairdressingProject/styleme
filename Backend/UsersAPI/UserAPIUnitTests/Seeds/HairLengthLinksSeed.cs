using AdminApi.Models_v2_1;
using System;
using System.Collections.Generic;
using System.Text;

namespace ApiUnitTests.Seeds
{
    public class HairLengthLinksSeed
    {
        public static List<HairLengthLinks> Seed()
        {
            return new List<HairLengthLinks>
            {
                new HairLengthLinks
                {
                    Id = 1,
                    LinkName = "short link",
                    LinkUrl = "https://content.latest-hairstyles.com/wp-content/uploads/best-short-a-line-bob-haircuts-500x333.jpg",
                    HairLengthId = 1
                },
                new HairLengthLinks
                {
                    Id = 2,
                    LinkName = "medium link",
                    LinkUrl = "https://i0.wp.com/www.hadviser.com/wp-content/uploads/2020/01/7-messy-medium-length-hairstyle-BwCkEK7AeBy.jpg?resize=1035%2C1205&ssl=1",
                    HairLengthId = 2
                }
            };
        }
    }
}
