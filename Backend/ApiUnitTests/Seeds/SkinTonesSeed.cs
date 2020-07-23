using AdminApi.Models_v2_1;
using System.Collections.Generic;

namespace ApiUnitTests.Seeds
{
    public class SkinTonesSeed
    {
        public static List<SkinTones> Seed()
        {
            return new List<SkinTones>
            {
                new SkinTones
                {
                    Id = 1,
                    SkinToneName = "ivory"
                },
                new SkinTones
                {
                    Id = 2,
                    SkinToneName = "chocolate"
                }
            };
        }
    }
}
