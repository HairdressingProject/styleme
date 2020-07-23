using AdminApi.Models_v2_1;
using System.Collections.Generic;

namespace ApiUnitTests.Seeds
{
    public class HairStylesSeed
    {
        public static List<HairStyles> Seed()
        {
            return new List<HairStyles>
            {
                new HairStyles
                {
                    Id = 1,
                    HairStyleName = "bob"
                },
                new HairStyles
                {
                    Id = 2,
                    HairStyleName = "afro"
                }
            };
        }
    }
}
