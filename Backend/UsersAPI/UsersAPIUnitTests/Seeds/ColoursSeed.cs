using AdminApi.Models_v2_1;
using System.Collections.Generic;

namespace ApiUnitTests.Seeds
{
    public class ColoursSeed
    {
        public static List<Colours> Seed()
        {
            return new List<Colours>
            {
                new Colours
                {
                    Id = 1,
                    ColourName = "Red",
                    ColourHash = "#FF0000"
                },
                new Colours
                {
                    Id = 2,
                    ColourName = "Blue",
                    ColourHash = "#0000FF"
                }
            };
        }
    }
}
