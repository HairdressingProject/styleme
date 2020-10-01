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
    public class SkinTonesContextTests
    {
        private SkinTonesContext _skinTonesContext;
        private FakeDatabase _db;

        public SkinTonesContextTests()
        {
            _db = new FakeDatabase();
            _skinTonesContext = new SkinTonesContext(_db.SkinTones);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfSkinTones()
        {
            // Arrange     
            _skinTonesContext = _db.SeedSkinTonesContext();
            List<SkinTones> expected = _db.SkinTones;

            // Act
            List<SkinTones> actual = await _skinTonesContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredSkinTones()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            List<SkinTones> expected = _db.SkinTones.FindAll(st => st.SkinToneName == "ivory");

            // Act
            // Equivalent to GET /skin_tones?limit=1000&offset=0&search=ivory
            List<SkinTones> actual = await _skinTonesContext.Browse("1000", "0", "ivory");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            int expected = _db.SkinTones.Count;

            // Act
            int actual = await _skinTonesContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            int expected = 1;

            // Act
            // Equivalent to GET /skin_tones/count?search=ivory
            int actual = await _skinTonesContext.Count("ivory");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsSkinToneById()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            ulong id = 1;
            SkinTones expected = _db.SkinTones.FirstOrDefault(c => c.Id == id);

            // Act
            SkinTones actual = await _skinTonesContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            ulong id = 2;
            List<SkinTones> currentSkinTones = _db.SkinTones;
            SkinTones current = currentSkinTones.FirstOrDefault(c => c.Id == id);
            SkinTones updated = current.ShallowCopy();
            updated.SkinToneName = "brown";

            SkinTones updatedSkinTone = new SkinTones
            {
                Id = id,
                SkinToneName = updated.SkinToneName
            };

            bool expected = true;

            // Act
            bool actual = await _skinTonesContext.Edit(id, updatedSkinTone);
            SkinTones u = _db.SkinTones.FirstOrDefault(c => c.Id == id);
            _db.SkinTones = new List<SkinTones>(currentSkinTones);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedSkinTone.SkinToneName, u.SkinToneName);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsSkinToneAdded()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            int currentSkinTonesCount = _db.SkinTones.Count;
            List<SkinTones> currentSkinTones = _db.SkinTones;

            SkinTones expected = new SkinTones
            {
                Id = 3,
                SkinToneName = "brown"
            };

            // Act
            SkinTones actual = await _skinTonesContext.Add(expected);
            int updatedSkinTonesCount = _db.SkinTones.Count;
            _db.SkinTones = new List<SkinTones>(currentSkinTones);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentSkinTonesCount + 1, updatedSkinTonesCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsSkinToneDeleted()
        {
            // Arrange
            _skinTonesContext = _db.SeedSkinTonesContext();
            ulong id = 2;
            List<SkinTones> currentSkinTones = _db.SkinTones;
            int currentSkinTonesCount = _db.SkinTones.Count;
            SkinTones expected = _db.SkinTones.FirstOrDefault(u => u.Id == id);

            // Act
            SkinTones actual = await _skinTonesContext.Delete(id);
            int updatedSkinTonesCount = _db.SkinTones.Count;
            _db.SkinTones = new List<SkinTones>(currentSkinTones);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentSkinTonesCount - 1, updatedSkinTonesCount);
        }
    }
}
