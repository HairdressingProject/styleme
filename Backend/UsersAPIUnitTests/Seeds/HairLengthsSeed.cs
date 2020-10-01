using UsersAPI.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace UsersAPIUnitTests.Seeds
{
    public class HairLengthsSeed
    {
        public static List<HairLengths> Seed()
        {
            return new List<HairLengths>
            {
                new HairLengths
                {
                    Id = 1,
                    HairLengthName = "short"
                },
                new HairLengths
                {
                    Id = 2,
                    HairLengthName = "medium"
                }
            };
        }
    }
}
