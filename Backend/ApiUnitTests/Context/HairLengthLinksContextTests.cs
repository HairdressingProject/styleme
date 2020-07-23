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
    public class HairLengthLinksContextTests
    {
        private HairLengthLinksContext _hairLengthLinksContext;
        private FakeDatabase _db;

        public HairLengthLinksContextTests()
        {
            _db = new FakeDatabase();
            _hairLengthLinksContext = new HairLengthLinksContext(_db.HairLengthLinks);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfHairLengthLinks()
        {
            // Arrange     
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            List<HairLengthLinks> expected = _db.HairLengthLinks;

            // Act
            List<HairLengthLinks> actual = await _hairLengthLinksContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredHairLengthLinks()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            List<HairLengthLinks> expected = _db.HairLengthLinks.FindAll(c =>
            c.LinkName.Trim().ToLower().Contains("short"));

            // Act
            // Equivalent to GET /hair_length_links?limit=1000&offset=0&search=short
            List<HairLengthLinks> actual = await _hairLengthLinksContext.Browse("1000", "0", "short");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            int expected = _db.HairLengthLinks.Count;

            // Act
            int actual = await _hairLengthLinksContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            int expected = 1;

            // Act
            // Equivalent to GET /hair_length_links/count?search=medium
            int actual = await _hairLengthLinksContext.Count("medium");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsHairLengthLinksById()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            ulong id = 1;
            HairLengthLinks expected = _db.HairLengthLinks.FirstOrDefault(c => c.Id == id);

            // Act
            HairLengthLinks actual = await _hairLengthLinksContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            ulong id = 2;
            List<HairLengthLinks> currentHairLengthLinks = _db.HairLengthLinks;
            HairLengthLinks current = currentHairLengthLinks.FirstOrDefault(c => c.Id == id);
            HairLengthLinks updated = current.ShallowCopy();
            updated.LinkName = "medium links updated";
            updated.LinkUrl = "https://i.pinimg.com/originals/56/16/79/56167980a30fa0d3bb098e7eeafdd411.jpg";

            HairLengthLinks updatedHairLengthLink = new HairLengthLinks
            {
                Id = id,
                LinkName = updated.LinkName,
                LinkUrl = updated.LinkUrl,
                HairLengthId = updated.HairLengthId
            };

            bool expected = true;

            // Act
            bool actual = await _hairLengthLinksContext.Edit(id, updatedHairLengthLink);
            HairLengthLinks u = _db.HairLengthLinks.FirstOrDefault(fs => fs.Id == id);
            _db.HairLengthLinks = new List<HairLengthLinks>(currentHairLengthLinks);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedHairLengthLink.LinkUrl, u.LinkUrl);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsHairLengthLinkAdded()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            int currentHairLengthLinksCount = _db.HairLengthLinks.Count;
            List<HairLengthLinks> currentHairLengthLinks = _db.HairLengthLinks;

            HairLengthLinks expected = new HairLengthLinks
            {
                Id = 3,
                LinkName = "medium link 2",
                LinkUrl = "https://i2.wp.com/therighthairstyles.com/wp-content/uploads/2016/10/10-messy-curly-medium-length-bob.jpg?w=500&ssl=1",
                HairLengthId = 2
            };

            // Act
            HairLengthLinks actual = await _hairLengthLinksContext.Add(expected);
            int updatedHairLengthLinksCount = _db.HairLengthLinks.Count;
            _db.HairLengthLinks = new List<HairLengthLinks>(currentHairLengthLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairLengthLinksCount + 1, updatedHairLengthLinksCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsHairLengthLinkDeleted()
        {
            // Arrange
            _hairLengthLinksContext = _db.SeedHairLengthLinksContext();
            ulong id = 2;
            List<HairLengthLinks> currentHairLengthLinks = _db.HairLengthLinks;
            int currentHairLengthLinksCount = _db.HairLengthLinks.Count;
            HairLengthLinks expected = _db.HairLengthLinks.FirstOrDefault(u => u.Id == id);

            // Act
            HairLengthLinks actual = await _hairLengthLinksContext.Delete(id);
            int updatedHairLengthLinksCount = _db.HairLengthLinks.Count;
            _db.HairLengthLinks = new List<HairLengthLinks>(currentHairLengthLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairLengthLinksCount - 1, updatedHairLengthLinksCount);
        }
    }
}
