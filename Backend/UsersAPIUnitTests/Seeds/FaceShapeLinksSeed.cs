using UsersAPI.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace UsersAPIUnitTests.Seeds
{
    public class FaceShapeLinksSeed
    {
        public static List<FaceShapeLinks> Seed()
        {
            return new List<FaceShapeLinks>
            {
                new FaceShapeLinks
                {
                    Id = 1,
                    LinkName = "oval link",
                    LinkUrl = "https://www.byrdie.com/thmb/6Nrr5EmgHGtV7sapEmAsM8gyF54=/700x700/smart/filters:no_upscale()/cdn.cliqueinc.com__posts__208817__how-to-apply-makeup-for-your-face-shape-1981920-1479419653-e2a47f02fa6248ce93d8629b33674af6.gif",
                    FaceShapeId = 1
                },
                new FaceShapeLinks
                {
                    Id = 2,
                    LinkName = "rectangular link",
                    LinkUrl = "https://www.byrdie.com/thmb/OoQOWzDNJe5CYB14UU1gyzwve6o=/835x700/filters:no_upscale():max_bytes(150000):strip_icc()/cdn.cliqueinc.com__cache__posts__79015__how-to-figure-out-your-face-shape-79015-1513284395954-main.700x0c-062c64abdad04e6e9ba74a586a27f85c.jpg",
                    FaceShapeId = 2
                }
            };
        }
    }
}
