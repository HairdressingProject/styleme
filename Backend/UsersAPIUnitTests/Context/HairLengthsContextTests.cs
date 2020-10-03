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
    public class HairLengthsContextTests
    {
        private HairLengthsContext _hairLengthsContext;
        private FakeDatabase _db;

        public HairLengthsContextTests()
        {
            _db = new FakeDatabase();
            _hairLengthsContext = new HairLengthsContext(_db.HairLengths);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfHairLengths()
        {
            // Arrange     
            _hairLengthsContext = _db.SeedHairLengthsContext();
            List<HairLengths> expected = _db.HairLengths;

            // Act
            List<HairLengths> actual = await _hairLengthsContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredHairLengths()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            List<HairLengths> expected = _db.HairLengths.FindAll(hl => hl.HairLengthName == "short");

            // Act
            // Equivalent to GET /hair_lengths?limit=1000&offset=0&search=short
            List<HairLengths> actual = await _hairLengthsContext.Browse("1000", "0", "short");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            int expected = _db.HairLengths.Count;

            // Act
            int actual = await _hairLengthsContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            int expected = 1;

            // Act
            // Equivalent to GET /HairLengths/count?search=short
            int actual = await _hairLengthsContext.Count("short");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsHairLengthById()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            ulong id = 1;
            HairLengths expected = _db.HairLengths.FirstOrDefault(c => c.Id == id);

            // Act
            HairLengths actual = await _hairLengthsContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            ulong id = 2;
            List<HairLengths> currentHairLengths = _db.HairLengths;
            HairLengths current = currentHairLengths.FirstOrDefault(c => c.Id == id);
            HairLengths updated = current.ShallowCopy();
            updated.HairLengthName = "long";

            HairLengths updatedHairLength = new HairLengths
            {
                Id = id,
                HairLengthName = updated.HairLengthName
            };

            bool expected = true;

            // Act
            bool actual = await _hairLengthsContext.Edit(id, updatedHairLength);
            HairLengths u = _db.HairLengths.FirstOrDefault(c => c.Id == id);
            _db.HairLengths = new List<HairLengths>(currentHairLengths);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedHairLength.HairLengthName, u.HairLengthName);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsHairLengthAdded()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            int currentHairLengthsCount = _db.HairLengths.Count;
            List<HairLengths> currentHairLengths = _db.HairLengths;

            HairLengths expected = new HairLengths
            {
                Id = 3,
                HairLengthName = "long"
            };

            // Act
            HairLengths actual = await _hairLengthsContext.Add(expected);
            int updatedHairLengthsCount = _db.HairLengths.Count;
            _db.HairLengths = new List<HairLengths>(currentHairLengths);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairLengthsCount + 1, updatedHairLengthsCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsHairLengthDeleted()
        {
            // Arrange
            _hairLengthsContext = _db.SeedHairLengthsContext();
            ulong id = 2;
            List<HairLengths> currentHairLengths = _db.HairLengths;
            int currentHairLengthsCount = _db.HairLengths.Count;
            HairLengths expected = _db.HairLengths.FirstOrDefault(u => u.Id == id);

            // Act
            HairLengths actual = await _hairLengthsContext.Delete(id);
            int updatedHairLengthsCount = _db.HairLengths.Count;
            _db.HairLengths = new List<HairLengths>(currentHairLengths);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairLengthsCount - 1, updatedHairLengthsCount);
        }
    }
}
