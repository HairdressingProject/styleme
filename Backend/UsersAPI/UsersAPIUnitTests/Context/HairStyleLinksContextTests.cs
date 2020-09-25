using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Fakes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace ApiUnitTests.Context
{
    public class HairStyleLinksContextTests
    {
        private HairStyleLinksContext _hairStyleLinksContext;
        private FakeDatabase _db;

        public HairStyleLinksContextTests()
        {
            _db = new FakeDatabase();
            _hairStyleLinksContext = new HairStyleLinksContext(_db.HairStyleLinks);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfHairStyleLinks()
        {
            // Arrange     
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            List<HairStyleLinks> expected = _db.HairStyleLinks;

            // Act
            List<HairStyleLinks> actual = await _hairStyleLinksContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredHairStyleLinks()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            List<HairStyleLinks> expected = _db.HairStyleLinks.FindAll(c =>
            c.LinkName.Trim().ToLower().Contains("afro"));

            // Act
            // Equivalent to GET /hair_style_links?limit=1000&offset=0&search=afro
            List<HairStyleLinks> actual = await _hairStyleLinksContext.Browse("1000", "0", "afro");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            int expected = _db.HairStyleLinks.Count;

            // Act
            int actual = await _hairStyleLinksContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            int expected = 1;

            // Act
            // Equivalent to GET /hair_style_links/count?search=afro
            int actual = await _hairStyleLinksContext.Count("afro");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsHairStyleLinksById()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            ulong id = 1;
            HairStyleLinks expected = _db.HairStyleLinks.FirstOrDefault(c => c.Id == id);

            // Act
            HairStyleLinks actual = await _hairStyleLinksContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            ulong id = 2;
            List<HairStyleLinks> currentHairStyleLinks = _db.HairStyleLinks;
            HairStyleLinks current = currentHairStyleLinks.FirstOrDefault(c => c.Id == id);
            HairStyleLinks updated = current.ShallowCopy();
            updated.LinkName = "afro links updated";
            updated.LinkUrl = "https://cdn.shopify.com/s/files/1/1767/9375/files/lyssamariexo_large.png?v=1568126512";

            HairStyleLinks updatedHairStyleLink = new HairStyleLinks
            {
                Id = id,
                LinkName = updated.LinkName,
                LinkUrl = updated.LinkUrl,
                HairStyleId = updated.HairStyleId
            };

            bool expected = true;

            // Act
            bool actual = await _hairStyleLinksContext.Edit(id, updatedHairStyleLink);
            HairStyleLinks u = _db.HairStyleLinks.FirstOrDefault(fs => fs.Id == id);
            _db.HairStyleLinks = new List<HairStyleLinks>(currentHairStyleLinks);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedHairStyleLink.LinkUrl, u.LinkUrl);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsHairStyleLinkAdded()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            int currentHairStyleLinksCount = _db.HairStyleLinks.Count;
            List<HairStyleLinks> currentHairStyleLinks = _db.HairStyleLinks;

            HairStyleLinks expected = new HairStyleLinks
            {
                Id = 3,
                LinkName = "bob link 2",
                LinkUrl = "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-854996960-1508951083.jpg",
                HairStyleId = 2
            };

            // Act
            HairStyleLinks actual = await _hairStyleLinksContext.Add(expected);
            int updatedHairStyleLinksCount = _db.HairStyleLinks.Count;
            _db.HairStyleLinks = new List<HairStyleLinks>(currentHairStyleLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairStyleLinksCount + 1, updatedHairStyleLinksCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsHairStyleLinkDeleted()
        {
            // Arrange
            _hairStyleLinksContext = _db.SeedHairStyleLinksContext();
            ulong id = 2;
            List<HairStyleLinks> currentHairStyleLinks = _db.HairStyleLinks;
            int currentHairStyleLinksCount = _db.HairStyleLinks.Count;
            HairStyleLinks expected = _db.HairStyleLinks.FirstOrDefault(u => u.Id == id);

            // Act
            HairStyleLinks actual = await _hairStyleLinksContext.Delete(id);
            int updatedHairStyleLinksCount = _db.HairStyleLinks.Count;
            _db.HairStyleLinks = new List<HairStyleLinks>(currentHairStyleLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairStyleLinksCount - 1, updatedHairStyleLinksCount);
        }
    }
}
