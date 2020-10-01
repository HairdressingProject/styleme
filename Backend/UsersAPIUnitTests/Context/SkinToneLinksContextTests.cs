using UsersAPI.Models;
using UsersAPI.Services.Context;
using UsersAPIUnitTests.Fakes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace UsersAPIUnitTests.Context
{
    public class SkinToneLinksContextTests
    {
        private SkinToneLinksContext _skinToneLinksContext;
        private FakeDatabase _db;

        public SkinToneLinksContextTests()
        {
            _db = new FakeDatabase();
            _skinToneLinksContext = new SkinToneLinksContext(_db.SkinToneLinks);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfSkinToneLinks()
        {
            // Arrange     
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            List<SkinToneLinks> expected = _db.SkinToneLinks;

            // Act
            List<SkinToneLinks> actual = await _skinToneLinksContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredSkinToneLinks()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            List<SkinToneLinks> expected = _db.SkinToneLinks.FindAll(c =>
            c.LinkName.Trim().ToLower().Contains("ivory"));

            // Act
            // Equivalent to GET /skin_tone_links?limit=1000&offset=0&search=ivory
            List<SkinToneLinks> actual = await _skinToneLinksContext.Browse("1000", "0", "ivory");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            int expected = _db.SkinToneLinks.Count;

            // Act
            int actual = await _skinToneLinksContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            int expected = 1;

            // Act
            // Equivalent to GET /skin_tone_links/count?search=afro
            int actual = await _skinToneLinksContext.Count("choco");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsSkinToneLinksById()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            ulong id = 1;
            SkinToneLinks expected = _db.SkinToneLinks.FirstOrDefault(c => c.Id == id);

            // Act
            SkinToneLinks actual = await _skinToneLinksContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            ulong id = 2;
            List<SkinToneLinks> currentSkinToneLinks = _db.SkinToneLinks;
            SkinToneLinks current = currentSkinToneLinks.FirstOrDefault(c => c.Id == id);
            SkinToneLinks updated = current.ShallowCopy();
            updated.LinkName = "chocolate link updated";
            updated.LinkUrl = "https://thatsisterimages.s3.amazonaws.com/wp-content/uploads/2018/04/26160555/shutterstock_251650981.jpg";

            SkinToneLinks updatedSkinToneLink = new SkinToneLinks
            {
                Id = id,
                LinkName = updated.LinkName,
                LinkUrl = updated.LinkUrl,
                SkinToneId = updated.SkinToneId
            };

            bool expected = true;

            // Act
            bool actual = await _skinToneLinksContext.Edit(id, updatedSkinToneLink);
            SkinToneLinks u = _db.SkinToneLinks.FirstOrDefault(fs => fs.Id == id);
            _db.SkinToneLinks = new List<SkinToneLinks>(currentSkinToneLinks);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedSkinToneLink.LinkUrl, u.LinkUrl);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsSkinToneLinkAdded()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            int currentSkinToneLinksCount = _db.SkinToneLinks.Count;
            List<SkinToneLinks> currentSkinToneLinks = _db.SkinToneLinks;

            SkinToneLinks expected = new SkinToneLinks
            {
                Id = 3,
                LinkName = "ivory link 2",
                LinkUrl = "https://duskyskin.com/wp-content/uploads/2020/03/What-is-Ivory-Skin-Tone.jpg",
                SkinToneId = 2
            };

            // Act
            SkinToneLinks actual = await _skinToneLinksContext.Add(expected);
            int updatedSkinToneLinksCount = _db.SkinToneLinks.Count;
            _db.SkinToneLinks = new List<SkinToneLinks>(currentSkinToneLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentSkinToneLinksCount + 1, updatedSkinToneLinksCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsSkinToneLinkDeleted()
        {
            // Arrange
            _skinToneLinksContext = _db.SeedSkinToneLinksContext();
            ulong id = 2;
            List<SkinToneLinks> currentSkinToneLinks = _db.SkinToneLinks;
            int currentSkinToneLinksCount = _db.SkinToneLinks.Count;
            SkinToneLinks expected = _db.SkinToneLinks.FirstOrDefault(u => u.Id == id);

            // Act
            SkinToneLinks actual = await _skinToneLinksContext.Delete(id);
            int updatedSkinToneLinksCount = _db.SkinToneLinks.Count;
            _db.SkinToneLinks = new List<SkinToneLinks>(currentSkinToneLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentSkinToneLinksCount - 1, updatedSkinToneLinksCount);
        }
    }
}
