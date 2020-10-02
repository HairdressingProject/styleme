using UsersAPI.Models;
using System.Collections.Generic;

namespace UsersAPIUnitTests.Seeds
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
